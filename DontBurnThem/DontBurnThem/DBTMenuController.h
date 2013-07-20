//
//  DBTMenuControllerViewController.h
//  DontBurnThem
//
//  Created by Pietro Saccardi on 20/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@class ZBarReaderViewController;

@interface DBTMenuController : UIViewController <ZBarReaderDelegate>

@property (nonatomic, retain) IBOutlet UIButton *scanButton;
@property (nonatomic, retain) ZBarReaderViewController *barcodeScanner;

- (void)setGUIEnabled:(BOOL)val;
- (IBAction)runBarcodeScanner:(id)sender;

@end
