//
//  DBTSearchController.h
//  DontBurnThem
//
//  Created by Pietro Saccardi on 21/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBTPagedScrollView.h"

@class DBTOffer;

@interface DBTSearchController : UIViewController <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, UITextFieldDelegate>
@property (nonatomic, retain) IBOutlet UILabel *label1;
@property (nonatomic, retain) IBOutlet UILabel *label2;
@property (nonatomic, retain) IBOutlet UIButton *parameters;
@property (nonatomic, retain) IBOutlet UITextField *authorField;
@property (nonatomic, retain) IBOutlet UITextField *isbnField;
@property (nonatomic, retain) IBOutlet UITextField *titleField;
@property (nonatomic, retain) IBOutlet DBTPagedScrollView *pages;
@property (nonatomic, retain) IBOutlet MKMapView *map;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet NSLayoutConstraint *animationConstraint;
@property (nonatomic, assign, getter=areResultsFullScreen) BOOL resultsFullScreen;

@property (nonatomic, retain) NSArray *foundOffers;
@property (nonatomic, retain) DBTOffer *selectedOffer;

- (IBAction)toggleParameters:(id)sender;
- (void)runSearch;
- (void)showDetails;
@end
