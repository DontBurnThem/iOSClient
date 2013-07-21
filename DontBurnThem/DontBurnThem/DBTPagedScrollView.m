//
//  DBTPagedScrollView.m
//  DontBurnThem
//
//  Created by Pietro Saccardi on 21/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import "DBTPagedScrollView.h"

@implementation DBTPagedScrollView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self=[super initWithCoder:aDecoder])) {
        self.delegate=self;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self=[super initWithFrame:frame])) {
        self.delegate=self;
    }
    return self;
}

- (void)updatePage:(id)sender
{
    UIPageControl *pageControl=(UIPageControl *)sender;
    
    CGSize size=self.frame.size;
    CGRect frame=CGRectMake(size.width*pageControl.currentPage,
                            0.,
                            size.width,
                            size.height);
    
    [self scrollRectToVisible:frame animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth=self.frame.size.width;
    NSUInteger page=floor((self.contentOffset.x-pageWidth/2)/pageWidth) + 1;
    self.pageControl.currentPage=page;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size=self.frame.size;
    for (NSUInteger i=0; i<self.subviews.count; ++i) {
        UIView *view=[self.subviews objectAtIndex:i];
        [view setFrame:CGRectMake(i*size.width,
                                  0.,
                                  size.width,
                                  size.height)];
    }
    
    [self.pageControl setNumberOfPages:self.subviews.count];
    [self setContentSize:CGSizeMake(self.subviews.count*size.width, size.height)];
}

- (void)dealloc
{
    self.pageControl=nil;
    
    [super dealloc];
}

@end
