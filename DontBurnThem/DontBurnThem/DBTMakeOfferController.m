//
//  DBTBookDetailsViewController.m
//  DontBurnThem
//
//  Created by Pietro Saccardi on 20/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import "DBTMakeOfferController.h"
#import "DBTOpenLibraryBook.h"
#import "DBTMapCell.h"
#import "DBTOffer.h"
#import "DBTImageCell.h"
#import "DBTButtonCell.h"
#import "DBTTextCell.h"

@interface DBTMakeOfferController () {
    UIActionSheet *bookStatesActionSheet;
}
@property (nonatomic, retain) UITableViewCell *stateCell;
@property (nonatomic, retain) DBTMapCell *mapCell;
@property (nonatomic, retain) DBTTextCell *priceCell;
- (void)setupPrivateVariables;

- (DBTOffer *)makeAnOffer;
@end

@implementation DBTMakeOfferController

- (void)setupPrivateVariables
{
    _bookStates=[@[@"Mint",
                 @"Open",
                 @"Used",
                 @"Written",
                 @"Damaged",
                 @"Missing pages"
                 ] retain];
    
    bookStatesActionSheet=[[UIActionSheet alloc] initWithTitle:@"State of the book"
                                                      delegate:self
                                             cancelButtonTitle:nil
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:nil];
    for (NSString *str in _bookStates)
         [bookStatesActionSheet addButtonWithTitle:str];
}

- (void)dealloc
{
    [_bookStates release];
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
                    [cell.textLabel setText:self.book.title];
                    [cell.detailTextLabel setText:self.book.subtitle];
                    break;
                    
                case 1:
                    cell=[tableView dequeueOrCreateCellWithIdentifier:@"ImageCell"
                                                             andClass:[DBTImageCell class]];
                    [(DBTImageCell *)cell setImageURL:self.book.imageURL];
                    
                default:
                    break;
            }
            break;
            
        case 1:
            
            cell=[tableView dequeueOrCreateCellWithIdentifier:@"TextCell"
                                                     andClass:[UITableViewCell class]];
            [cell.textLabel setText:[self.book.authors objectAtIndex:indexPath.row]];
            break;
            
        case 2:
            cell=[tableView dequeueOrCreateCellWithIdentifier:@"TextCell"
                                                     andClass:[UITableViewCell class]];
            [cell.textLabel setText:[self.book.publishers objectAtIndex:indexPath.row]];
            
            break;
        case 3:
            cell=[tableView dequeueOrCreateCellWithIdentifier:@"MapCell"
                                                     andClass:[DBTMapCell class]];
            self.mapCell=(DBTMapCell *)cell;
            break;
        case 4:
            switch (indexPath.row) {
                case 0:
                    cell=[tableView dequeueOrCreateCellWithIdentifier:@"ComboCell"
                                                             andClass:[UITableViewCell class]];
                    self.stateCell=cell;
                    [cell.detailTextLabel setText:[self.bookStates objectAtIndex:self.state]];
                    break;
                case 1:
                    cell=[tableView dequeueOrCreateCellWithIdentifier:@"PriceCell"
                                                             andClass:[DBTTextCell class]];
                    self.priceCell=(DBTTextCell *)cell;
                    [[(DBTTextCell *)cell textField] setDelegate:self];
                    [[(DBTTextCell *)cell textField] setText:[NSString stringWithFormat:@"%0.2f", self.price]];
                    
                default:
                    break;
            }
            
            break;
        case 5:
            cell=[tableView dequeueOrCreateCellWithIdentifier:@"ButtonCell"
                                                     andClass:[DBTButtonCell class]];
            [cell.textLabel setText:@"Sell"];
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (CLLocationCoordinate2D)location
{
    return self.mapCell.mapView.userLocation.location.coordinate;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [[NSScanner scannerWithString:[textField text]] scanFloat:&_price];
}

- (DBTOffer *)makeAnOffer
{
    DBTOffer *offer=[DBTOffer offerWithBook:self.book
                                  withPrice:self.price
                                   andState:self.state];
    
    offer.location=self.location;
    
    return offer;
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
            return self.book.authors.count;
        case 2:
            return self.book.publishers.count;
        case 3:
            return 1;
        case 4:
            return 2;
        case 5:
            return 1;
            
        default:
            return 0;
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // set the value
    _state=buttonIndex;
    [self.stateCell.detailTextLabel setText:[self.bookStates objectAtIndex:buttonIndex]];
}

- (void)buttonCellWasClicked:(DBTButtonCell *)cell
{
    [self.priceCell.textField endEditing:NO];

    switch ([self.tableView indexPathForCell:cell].section) {
        case 4:
            [bookStatesActionSheet showInView:self.view];
            break;
        
        case 5:
            [cell setEnabled:NO];
            
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

- (void)setBook:(DBTOpenLibraryBook *)book
{
    [_book autorelease];
    _book=[book retain];
    
    [self.tableView reloadData];
}

@end
