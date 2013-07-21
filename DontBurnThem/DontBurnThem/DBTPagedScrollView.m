//
//  DBTPagedScrollView.m
//  DontBurnThem
//
//  Created by Pietro Saccardi on 21/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import "DBTPagedScrollView.h"

@interface DBTPagedScrollView () {
    CGFloat scrollingW;
    BOOL alreadyLayout;
}
@end

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
    
    CGRect frame=CGRectMake(scrollingW*pageControl.currentPage,
                            0.,
                            scrollingW,
                            self.frame.size.height);
    
    [self scrollRectToVisible:frame animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSUInteger page=floor((self.contentOffset.x-scrollingW/2)/scrollingW) + 1;
    self.pageControl.currentPage=page;
}

- (void)layoutSubviews
{
    [self relayoutSubviews];
    [super layoutSubviews];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    alreadyLayout=NO;
}

- (void)relayoutSubviews
{
    if (self.bounds.size.width==0. || self.bounds.size.height==0.)
        return;
    
    if (alreadyLayout) return;
    
    alreadyLayout=YES;
    
    
    NSArray *views=self.subviews;
    
    for (UIView *v in views) {
        [v removeFromSuperview];
    }
    
    CGFloat w=self.bounds.size.width;
    scrollingW=w;
    
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
    
    [dict release];
}

- (void)dealloc
{
    self.pageControl=nil;
    
    [super dealloc];
}

@end
