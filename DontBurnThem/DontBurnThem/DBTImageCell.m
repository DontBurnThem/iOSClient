//
//  DBTImageCell.m
//  DontBurnThem
//
//  Created by Pietro Saccardi on 20/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import "DBTImageCell.h"

@implementation DBTImageCell

- (void)setImageURL:(NSURL *)imageURL
{
    if ([imageURL isEqual:_imageURL]) return;
    
    [_imageURL autorelease];
    _imageURL=[imageURL copy];
    
    // load the image
    [(UIImageView *)[self viewWithTag:1] setImage:[UIImage imageNamed:@"EmptyImage"]];
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:imageURL]
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *resp, NSData *data, NSError *err) {
                               
                               // load image
                               [(UIImageView *)[self viewWithTag:1] setImage:[UIImage imageWithData:data]];
                               
                           }];
}

@end
