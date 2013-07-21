//
//  DBTButtonCell.m
//  DontBurnThem
//
//  Created by Pietro Saccardi on 20/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import "DBTButtonCell.h"

@implementation DBTButtonCell

- (void)setEnabled:(BOOL)enabled
{
    [self setUserInteractionEnabled:enabled];
    [self.textLabel setEnabled:enabled];
    _enabled=enabled;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setSelected:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate buttonCellWasClicked:self];
    [self setSelected:NO animated:YES];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setSelected:NO animated:YES];
}

@end
