//
//  DBTSearchController.m
//  DontBurnThem
//
//  Created by Pietro Saccardi on 21/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import "DBTSearchController.h"
#import "DBTOffer.h"
#import "DBTOpenLibraryBook.h"
#import "DBTServer.h"
#import "DBTOfferCell.h"
#import "DBTOfferController.h"

@interface DBTSearchController ()

- (void)runSearchInternal;
- (void)filterOffers:(NSArray *)off;
@end

@implementation DBTSearchController


- (void)runSearch
{
    [self.authorField endEditing:YES];
    [self.titleField endEditing:YES];
    [self.isbnField endEditing:YES];
    [self performSelectorInBackground:@selector(runSearchInternal) withObject:nil];
}

- (void)filterOffers:(NSArray *)off
{
    NSMutableArray *offers=[NSMutableArray arrayWithArray:off];
    
    NSString *authorQuery=[self.authorField.text lowercaseStringAndRemoveWhitespace];
    NSString *titleQuery=[self.titleField.text lowercaseStringAndRemoveWhitespace];
    
    for (NSUInteger i=0; i<offers.count; ++i) {
        
        DBTOffer *offer=[offers objectAtIndex:i];
        
        [offer setBook:[DBTOpenLibraryBook fetchBookWithISBN:[offer isbnFromBookRef]]];
        
        // check if matches
        if (!offer.book) continue;
        
        BOOL matches=YES;
        
        if (authorQuery.length>0) {
            NSString *haystack=[[offer.book.authors componentsJoinedByString:@","] lowercaseStringAndRemoveWhitespace];
            
            if ([haystack rangeOfString:authorQuery].length==0)
                matches=NO;
        }
        
        if (titleQuery.length>0) {
            NSString *haystack=[[offer.book.title stringByAppendingFormat:@",%@", offer.book.subtitle] lowercaseStringAndRemoveWhitespace];
            
            if ([haystack rangeOfString:titleQuery].length==0)
                matches=NO;
        }
        
        if (matches) continue;
        
        // otherwise, remove
        [offers removeObjectAtIndex:i];
        --i;
    }
    
    [self performSelectorOnMainThread:@selector(setFoundOffers:) withObject:offers waitUntilDone:NO];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.foundOffers.count==0) {
        [self.isbnField becomeFirstResponder];
    }
}

- (void)runSearchInternal
{
    NSArray *results=[[DBTServer server] lookForOffersHere:self.map.userLocation.location.coordinate
                                                    radius:25.
                                              optionalISBN:(self.isbnField.text.length>0 ? self.isbnField.text : nil)
                                                     error:NULL];
    [self performSelectorOnMainThread:@selector(setFoundOffers:) withObject:results waitUntilDone:NO];
    
    [self performSelectorInBackground:@selector(filterOffers:)
                           withObject:results];
}

- (void)toggleParameters:(id)sender
{
    self.resultsFullScreen=!self.resultsFullScreen;
}

- (void)setFoundOffers:(NSArray *)foundOffers
{
    [_foundOffers autorelease];
    _foundOffers=[foundOffers retain];
    
    // place overlays
    [self.map removeAnnotations:self.map.annotations];
    [self.map addAnnotations:foundOffers];
    [self.tableView reloadData];
}

- (void)setResultsFullScreen:(BOOL)resultsFullScreen
{
    if (resultsFullScreen!=_resultsFullScreen) {
        _resultsFullScreen=resultsFullScreen;
        
        if (resultsFullScreen) {
            
            [UIView animateWithDuration:0.2 animations:^{
                
                [self.animationConstraint setConstant:26.];
                [self.view layoutIfNeeded];
                
                [self.label1 setAlpha:1.];
                [self.label2 setAlpha:1.];
                
                
            } completion:^(BOOL finished) {
                [self.parameters setHighlighted:NO];
                [self runSearch];
            }];
            
        } else {
            
            [UIView animateWithDuration:0.2 animations:^{
                
                [self.animationConstraint setConstant:133.];
                [self.view layoutIfNeeded];

                [self.label1 setAlpha:0.];
                [self.label2 setAlpha:0.];
                
                
            } completion:^(BOOL finished) {
                [self.parameters setHighlighted:YES];
            }];
                        
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"OfferDetails"]) {
        [(DBTOfferController *)segue.destinationViewController setReadOnly:YES];
        [(DBTOfferController *)segue.destinationViewController setOffer:self.selectedOffer];
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    self.selectedOffer=(DBTOffer *)view.annotation;
    [self showDetails];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[DBTOffer class]]) {
        static NSString *reuseId = @"Default";
        
        MKPinAnnotationView *aView = (MKPinAnnotationView *)[mapView                                                          dequeueReusableAnnotationViewWithIdentifier:reuseId];
        if (aView == nil)
        {
            aView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                     reuseIdentifier:reuseId] autorelease];
            aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            aView.canShowCallout = YES;
        }
        
        aView.annotation = annotation;
        
        return aView;
    }
    return nil;
}

- (void)showDetails
{
    [self performSegueWithIdentifier:@"OfferDetails" sender:self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    self.selectedOffer=[self.foundOffers objectAtIndex:indexPath.row];
    [self showDetails];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.foundOffers.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueOrCreateCellWithIdentifier:@"OfferCell" andClass:[DBTOfferCell class]];
    
    [(DBTOfferCell *)cell loadOffer:[self.foundOffers objectAtIndex:indexPath.row] fromLocation:self.map.userLocation.location];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

@end
