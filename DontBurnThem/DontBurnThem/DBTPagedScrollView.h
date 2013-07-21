//
//  DBTPagedScrollView.h
//  DontBurnThem
//
//  Created by Pietro Saccardi on 21/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBTPagedScrollView : UIScrollView <UIScrollViewDelegate>
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
- (IBAction)updatePage:(id)sender;
@end
