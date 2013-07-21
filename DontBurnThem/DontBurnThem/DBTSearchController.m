//
//  DBTSearchController.m
//  DontBurnThem
//
//  Created by Pietro Saccardi on 21/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import "DBTSearchController.h"

#define ANIMATON_DELTA 104.

@interface DBTSearchController ()

@end

@implementation DBTSearchController

- (void)toggleParameters:(id)sender
{
    self.resultsFullScreen=!self.resultsFullScreen;
}

- (void)setResultsFullScreen:(BOOL)resultsFullScreen
{
    if (resultsFullScreen!=_resultsFullScreen) {
        _resultsFullScreen=resultsFullScreen;
        
        if (resultsFullScreen) {
            
            [UIView animateWithDuration:0.2 animations:^{
                
                CGRect frame=self.pages.frame;
                frame.size.height+=ANIMATON_DELTA;
                frame.origin.y-=ANIMATON_DELTA;
                
                [self.pages setFrame:frame];
                
                frame=self.parameters.frame;
                frame.origin.y-=ANIMATON_DELTA;
                [self.parameters setFrame:frame];
                
                [self.label1 setAlpha:1.];
                [self.label2 setAlpha:1.];
                
                [self.parameters setHighlighted:NO];
            }];
            
        } else {
            
            [UIView animateWithDuration:0.2 animations:^{
                
                CGRect frame=self.pages.frame;
                frame.size.height-=ANIMATON_DELTA;
                frame.origin.y+=ANIMATON_DELTA;
                
                [self.pages setFrame:frame];
                
                frame=self.parameters.frame;
                frame.origin.y+=ANIMATON_DELTA;
                [self.parameters setFrame:frame];
                
                [self.label1 setAlpha:0.];
                [self.label2 setAlpha:0.];
                
                [self.parameters setHighlighted:YES];
            }];
                        
        }
    }
}

@end
