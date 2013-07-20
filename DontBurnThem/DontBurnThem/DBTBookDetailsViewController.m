//
//  DBTBookDetailsViewController.m
//  DontBurnThem
//
//  Created by Pietro Saccardi on 20/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import "DBTBookDetailsViewController.h"
#import "DBTOpenLibraryBookInfo.h"
#import "DBTMapCell.h"
#import "DBTImageCell.h"
#import "DBTButtonCell.h"
#import "DBTTextCell.h"

@interface DBTBookDetailsViewController () {
    UIActionSheet *bookStatesActionSheet;
}
@property (nonatomic, retain) UITableViewCell *bookStateCell;
- (void)setupPrivateVariables;
@end

@implementation DBTBookDetailsViewController

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
    self.bookStateCell=nil;
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
                    [cell.textLabel setText:self.bookInfo.title];
                    [cell.detailTextLabel setText:self.bookInfo.subtitle];
                    break;
                    
                case 1:
                    cell=[tableView dequeueOrCreateCellWithIdentifier:@"ImageCell"
                                                             andClass:[DBTImageCell class]];
                    [(DBTImageCell *)cell setImageURL:self.bookInfo.imageURL];
                    
                default:
                    break;
            }
            break;
            
        case 1:
            
            cell=[tableView dequeueOrCreateCellWithIdentifier:@"TextCell"
                                                     andClass:[UITableViewCell class]];
            [cell.textLabel setText:[self.bookInfo.authors objectAtIndex:indexPath.row]];
            break;
            
        case 2:
            cell=[tableView dequeueOrCreateCellWithIdentifier:@"TextCell"
                                                     andClass:[UITableViewCell class]];
            [cell.textLabel setText:[self.bookInfo.publishers objectAtIndex:indexPath.row]];
            
            break;
        case 3:
            cell=[tableView dequeueOrCreateCellWithIdentifier:@"MapCell"
                                                     andClass:[DBTMapCell class]];
            break;
        case 4:
            switch (indexPath.row) {
                case 0:
                    cell=[tableView dequeueOrCreateCellWithIdentifier:@"ComboCell"
                                                             andClass:[UITableViewCell class]];
                    self.bookStateCell=cell;
                    [cell.textLabel setText:[self.bookStates objectAtIndex:self.currentBookState]];
                    break;
                case 1:
                    cell=[tableView dequeueOrCreateCellWithIdentifier:@"PriceCell"
                                                             andClass:[DBTTextCell class]];

                    [[(DBTTextCell *)cell textField] setDelegate:self];
                    [[(DBTTextCell *)cell textField] setText:[NSString stringWithFormat:@"%0.2f", self.currentBookPrice]];
                    
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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [[NSScanner scannerWithString:[textField text]] scanFloat:&_currentBookPrice];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
        case 1:
            return self.bookInfo.authors.count;
        case 2:
            return self.bookInfo.publishers.count;
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
    _currentBookState=buttonIndex;
    [self.bookStateCell.textLabel setText:[self.bookStates objectAtIndex:buttonIndex]];
}

- (void)buttonCellWasClicked:(DBTButtonCell *)cell
{
    [bookStatesActionSheet showInView:self.view];
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
            return @"Book state";
        case 5:
            return nil;
            
        default:
            return nil;
            break;
    }
}

- (void)setBookInfo:(DBTOpenLibraryBookInfo *)bookInfo
{
    [_bookInfo autorelease];
    _bookInfo=[bookInfo retain];
    
    [self.tableView reloadData];
}

@end
