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
    
    CGSize size=self.bounds.size;
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

- (void)relayoutSubviews
{
    static BOOL neverDoThis=NO;
    if (neverDoThis) {
        return;
    }
    neverDoThis=YES;
    
    NSArray *views=self.subviews;
    
    for (UIView *v in views) {
        [v removeFromSuperview];
    }
    
    CGFloat w=self.bounds.size.width;
    NSUInteger count=views.count;
    
    [self setContentSize:CGSizeMake(w*count, self.bounds.size.height)];
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithCapacity:count];
    NSMutableString *str=[NSMutableString stringWithString:@"H:|-0"];
    
    for (UIView *v in views) {
        
        [v setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:v];
        
        [dict setValue:v forKey:[NSString stringWithFormat:@"v%d",dict.count]];
        [str appendFormat:@"-[v%d(w)]-0", dict.count-1];
    }

    
    [str appendString:@"-|"];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:str
                                                                 options:0
                                                                 metrics:@{@"w": @(w)}
                                                                   views:dict]];
    
    for (UIView *v in views) {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[v]-0-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:@{@"v": v}]];
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:v
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeHeight
                                     multiplier:1
                                       constant:0]];
    }
    [self.pageControl setNumberOfPages:self.subviews.count];
}

- (void)dealloc
{
    self.pageControl=nil;
    
    [super dealloc];
}

@end
