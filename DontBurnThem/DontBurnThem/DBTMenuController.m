//
//  DBTMenuControllerViewController.m
//  DontBurnThem
//
//  Created by Pietro Saccardi on 20/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import "DBTMenuController.h"
#import "DBTOpenLibraryBook.h"
#import "DBTMakeOfferController.h"

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

- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    for (ZBarSymbol *symbol in symbols) {
        
        // take the code
        NSString *isbn=[symbol data];
        
        isbn=@"0201558025";
        
        self.scannedBook=[DBTOpenLibraryBook bookInfoWithJSONData:[NSURLConnection sendSynchronousRequest:[DBTOpenLibraryBook requestForISBN:isbn]
                                                                                            returningResponse:NULL
                                                                                                        error:NULL]
                                                                error:NULL];
        
        if (self.scannedBook) {
            [self.barcodeScanner dismissViewControllerAnimated:YES completion:^{
                [self performSegueWithIdentifier:@"BookDetails" sender:self];
            }];
        } else {
            UIAlertView *av=[[UIAlertView alloc] initWithTitle:@"Failure"
                                                       message:@"Unable to get book details."
                                                      delegate:nil
                                             cancelButtonTitle:@"Ok"
                                             otherButtonTitles: nil];
            
            [[av autorelease] show];
        }
        
        return;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BookDetails"]) {
        [(DBTMakeOfferController *)segue.destinationViewController setBook:self.scannedBook];
    }
}

- (void)openScanner:(id)sender
{
#warning edit this
#if false
    if (!self.barcodeScanner) {
        self.barcodeScanner=[[ZBarReaderViewController new] autorelease];
        [self.barcodeScanner setShowsZBarControls:YES];
        [self.barcodeScanner.readerView setReaderDelegate:self];
    }
    
    [self presentViewController:self.barcodeScanner
                       animated:YES
                     completion:NULL];
#else
    // take the code
    NSString *isbn=@"0201558025";
    
    self.scannedBook=[DBTOpenLibraryBook bookInfoWithJSONData:[NSURLConnection sendSynchronousRequest:[DBTOpenLibraryBook requestForISBN:isbn]
                                                                                        returningResponse:NULL
                                                                                                    error:NULL]
                                                            error:NULL];
    
    if (!self.scannedBook) {
        UIAlertView *av=[[UIAlertView alloc] initWithTitle:@"Failure"
                                                   message:@"Unable to get book details."
                                                  delegate:nil
                                         cancelButtonTitle:@"Ok"
                                         otherButtonTitles: nil];
        
        [[av autorelease] show];
    } else {
        [self performSegueWithIdentifier:@"BookDetails" sender:self];
    }

#endif
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
