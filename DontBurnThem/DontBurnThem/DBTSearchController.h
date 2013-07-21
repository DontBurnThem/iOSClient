//
//  DBTSearchController.h
//  DontBurnThem
//
//  Created by Pietro Saccardi on 21/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBTPagedScrollView.h"

@interface DBTSearchController : UIViewController
@property (nonatomic, retain) IBOutlet UILabel *label1;
@property (nonatomic, retain) IBOutlet UILabel *label2;
@property (nonatomic, retain) IBOutlet UIButton *parameters;
@property (nonatomic, retain) IBOutlet DBTPagedScrollView *pages;
@property (nonatomic, assign, getter=areResultsFullScreen) BOOL resultsFullScreen;

- (IBAction)toggleParameters:(id)sender;

@end
