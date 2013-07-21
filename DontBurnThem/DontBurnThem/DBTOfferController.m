//
//  DBTBookDetailsViewController.m
//  DontBurnThem
//
//  Created by Pietro Saccardi on 20/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import "DBTOfferController.h"
#import "DBTOpenLibraryBook.h"
#import "DBTMapCell.h"
#import "DBTOffer.h"
#import "DBTImageCell.h"
#import "DBTButtonCell.h"
#import "DBTTextCell.h"

@interface DBTOfferController () {
    UIActionSheet *bookStatesActionSheet;
    CLLocationCoordinate2D _location;
}
@property (nonatomic, retain) UITableViewCell *stateCell;
@property (nonatomic, retain) DBTMapCell *mapCell;
@property (nonatomic, retain) DBTTextCell *priceCell;
- (void)setupPrivateVariables;
@end

@implementation DBTOfferController

- (void)setupPrivateVariables
{
    bookStatesActionSheet=[[UIActionSheet alloc] initWithTitle:@"State of the book"
                                                      delegate:self
                                             cancelButtonTitle:nil
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:nil];
    for (NSString *str in [DBTOffer bookStates])
         [bookStatesActionSheet addButtonWithTitle:str];
    
    _offer=[[DBTOffer alloc] init];
}

- (void)setOffer:(DBTOffer *)offer
{
    [_offer autorelease];
    _offer=[offer retain];
    
    [self.tableView reloadData];
}

- (void)dealloc
{
    self.stateCell=nil;
    self.mapCell=nil;
    self.priceCell=nil;
    [bookStatesActionSheet release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        [self setupPrivateVariables];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self=[super initWithCoder:aDecoder])) {
        [self setupPrivateVariables];
    }
    return self;
}

- (void)setReadOnly:(BOOL)readOnly
{
    if (_readOnly==readOnly) return;
    
    _readOnly=readOnly;
    [self.tableView reloadData];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    if ((self=[super initWithStyle:style])) {
        [self setupPrivateVariables];
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 1:
                    return 177.;
                    break;
            }
            break;
        case 1:
        case 2:
            return 30.;
            break;
        case 3:
            return 200.;
    }
    
    return tableView.rowHeight;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=nil;
    switch (indexPath.section) {
        case 0:
            
            switch (indexPath.row) {
                case 0:
                    cell=[tableView dequeueOrCreateCellWithIdentifier:@"TitleCell"
                                                             andClass:[UITableViewCell class]];
                    [cell.textLabel setText:self.offer.book.title];
                    [cell.detailTextLabel setText:self.offer.book.subtitle];
                    break;
                    
                case 1:
                    cell=[tableView dequeueOrCreateCellWithIdentifier:@"ImageCell"
                                                             andClass:[DBTImageCell class]];
                    [(DBTImageCell *)cell setImageURL:self.offer.book.imageURL];
                    
                default:
                    break;
            }
            break;
            
        case 1:
            
            cell=[tableView dequeueOrCreateCellWithIdentifier:@"TextCell"
                                                     andClass:[UITableViewCell class]];
            [cell.textLabel setText:[self.offer.book.authors objectAtIndex:indexPath.row]];
            break;
            
        case 2:
            cell=[tableView dequeueOrCreateCellWithIdentifier:@"TextCell"
                                                     andClass:[UITableViewCell class]];
            [cell.textLabel setText:[self.offer.book.publishers objectAtIndex:indexPath.row]];
            
            break;
        case 3:
            cell=[tableView dequeueOrCreateCellWithIdentifier:@"MapCell"
                                                     andClass:[DBTMapCell class]];
            self.mapCell=(DBTMapCell *)cell;
            [self.mapCell.mapView removeAnnotations:self.mapCell.mapView.annotations];
            if ([self isReadOnly])
                [self.mapCell.mapView addAnnotation:self.offer];
            break;
        case 4:
            switch (indexPath.row) {
                case 0:
                    cell=[tableView dequeueOrCreateCellWithIdentifier:@"ComboCell"
                                                             andClass:[DBTButtonCell class]];
                    self.stateCell=cell;
                    [(DBTButtonCell *)cell setUserInteractionEnabled:![self isReadOnly]];
                    [cell.detailTextLabel setText:[[DBTOffer bookStates] objectAtIndex:self.offer.state]];
                    break;
                case 1:
                    cell=[tableView dequeueOrCreateCellWithIdentifier:@"PriceCell"
                                                             andClass:[DBTTextCell class]];
                    self.priceCell=(DBTTextCell *)cell;
                    [[(DBTTextCell *)cell textField] setDelegate:self];
                    [self.priceCell.textField setEnabled:![self isReadOnly]];
                    [[(DBTTextCell *)cell textField] setText:[NSString stringWithFormat:@"%0.2f", self.offer.price]];
                    
                default:
                    break;
            }
            
            break;
        case 5:
            switch (indexPath.row) {
                case 0:
                    cell=[tableView dequeueOrCreateCellWithIdentifier:@"ButtonCell"
                                                             andClass:[DBTButtonCell class]];
                    [cell.textLabel setText:([self isReadOnly] ? @"Close" : @"Sell")];

                    break;
                    
                case 1:
                    cell=[tableView dequeueOrCreateCellWithIdentifier:@"ButtonCell"
                                                             andClass:[DBTButtonCell class]];
                    [cell.textLabel setText:@"Close"];
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    
    return cell;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGFloat price;
    [[NSScanner scannerWithString:[textField text]] scanFloat:&price];
    
    self.offer.price=price;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.priceCell.textField endEditing:NO];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
        case 1:
            return self.offer.book.authors.count;
        case 2:
            return self.offer.book.publishers.count;
        case 3:
            return 1;
        case 4:
            return 2;
        case 5:
            return ([self isReadOnly] ? 1 : 2);
            
        default:
            return 0;
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // set the value
    self.offer.state=buttonIndex;
    [self.stateCell.detailTextLabel setText:[[DBTOffer bookStates] objectAtIndex:buttonIndex]];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (![self isReadOnly])
        [self.offer setLocation:userLocation.coordinate];
}

- (void)buttonCellWasClicked:(DBTButtonCell *)cell
{
    [self.priceCell.textField endEditing:NO];

    switch ([self.tableView indexPathForCell:cell].section) {
        case 4:
            [bookStatesActionSheet showInView:self.view];
            break;
        
        case 5:
            if ([self isReadOnly] || [self.tableView indexPathForCell:cell].row==1) {
                [self dismiss];
            } else {
                
                [cell setEnabled:NO];
                [[self offer] pushAsynchronouslyToServer:^(BOOL result, NSError *err) {
                    [cell setEnabled:YES];
                    
                    if (!result) {
                        NSLog(@"Failure!!");
                    } else {
                        [self dismiss];
                    }
                }];
            }
            break;
             
        default:
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Book";
            break;
        case 1:
            return @"Authors";
            break;
        case 2:
            return @"Publishers";
            break;
        case 3:
            return @"Your position";
            break;
        case 4:
            return @"Offer info";
        case 5:
            return nil;
            
        default:
            return nil;
            break;
    }
}


@end
