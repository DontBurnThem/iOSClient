//
//  DBTMenuControllerViewController.m
//  DontBurnThem
//
//  Created by Pietro Saccardi on 20/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import "DBTMenuController.h"

@interface DBTMenuController ()

@end

@implementation DBTMenuController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // check if there is a fb session
    if (FB_ISSESSIONOPENWITHSTATE([FBSession activeSession].state)) {
        [self setGUIEnabled:YES];
    } else {
        // perform login
        [FBSession openActiveSessionWithReadPermissions:nil
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                          if (FB_ISSESSIONOPENWITHSTATE(status)) {
                                              [self setGUIEnabled:YES];
                                          } else {
                                              
                                              // handle error
                                              UIAlertView *msg=[[UIAlertView alloc] initWithTitle:@"Login error"
                                                                                          message:[error localizedDescription]
                                                                                         delegate:nil
                                                                                cancelButtonTitle:@"Ok"
                                                                                otherButtonTitles:nil];
                                              
                                              [msg show];
                                              
                                              [msg autorelease];
                                          }
                                      }];
    }
}

- (void)runBarcodeScanner:(id)sender
{
    if (!self.barcodeScanner) {
        self.barcodeScanner=[[ZBarReaderViewController new] autorelease];
    }
    
    [self.barcodeScanner setReaderDelegate:self];
    
    [self presentViewController:self.barcodeScanner
                       animated:YES
                     completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // get the result
    for (ZBarSymbol *symbol in [info objectForKey: ZBarReaderControllerResults]) {
        NSLog(@"%@ (type %d)", symbol.data, symbol.type);
    }
    
    
    [self.barcodeScanner dismissViewControllerAnimated:YES completion:NULL];
}

- (void)setGUIEnabled:(BOOL)val
{
    [self.scanButton setEnabled:val];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
