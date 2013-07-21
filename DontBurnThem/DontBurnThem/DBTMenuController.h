//
//  DBTMenuControllerViewController.h
//  DontBurnThem
//
//  Created by Pietro Saccardi on 20/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@class DBTOpenLibraryBook;

@interface DBTMenuController : UIViewController <ZBarReaderViewDelegate>

@property (nonatomic, retain) IBOutlet UIButton *scanButton;
@property (nonatomic, retain) IBOutlet UIButton *searchButton;
@property (nonatomic, retain) ZBarReaderViewController *barcodeScanner;
@property (nonatomic, retain) DBTOpenLibraryBook *scannedBook;

- (void)setGUIEnabled:(BOOL)val;
- (IBAction)openScanner:(id)sender;

@end
