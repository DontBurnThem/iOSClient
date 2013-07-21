//
//  DBTOffer.m
//  DontBurnThem
//
//  Created by Pietro Saccardi on 21/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import "DBTOffer.h"
#import "DBTServer.h"
#import "DBTOpenLibraryBook.h"

@implementation DBTOffer
+ (DBTOffer *)offerWithBook:(DBTOpenLibraryBook *)book withPrice:(CGFloat)price andState:(NSUInteger)state
{
    return [[[DBTOffer alloc] initOfferWithBook:book
                                      withPrice:price
                                       andState:state] autorelease];
}

- (id)initOfferWithBook:(DBTOpenLibraryBook *)book withPrice:(CGFloat)price andState:(NSUInteger)state
{
    if ((self=[super init])) {
        self.book=book;
        self.price=price;
        self.state=state;
    }
    return self;
}

- (NSString *)isbnFromBookRef
{
    return [[NSURL URLWithString:self.bookRef] lastPathComponent];
}

+ (NSArray *)bookStates
{
    return @[@"Mint",
             @"Open",
             @"Used",
             @"Written",
             @"Damaged",
             @"Missing pages"
             ];
}

- (void)pushAsynchronouslyToServer:(void (^)(BOOL, NSError *))cbk
{
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       NSError *err=nil;
                       BOOL result=[self pushSynchronouslyToServerError:&err];
                       
                       cbk(result, err);
                   });
}

- (CLLocationCoordinate2D)coordinate
{
    return self.location;
}

- (NSString *)title
{
    if (self.book) return self.book.title;
    if (self.bookRef) return [self isbnFromBookRef];
    
    return [NSString stringWithFormat:@"%0.2f", self.price];
}

- (NSString *)subtitle
{
    return [NSString stringWithFormat:@"%0.2f, %@", self.price, [[DBTOffer bookStates] objectAtIndex:self.state]];
}

- (BOOL)pushSynchronouslyToServerError:(NSError **)err
{
    DBTServer *server=[DBTServer server];
    NSError *myErr=nil;
    
    BOOL contains=[server containsBook:self.book error:&myErr];
    
    if (myErr!=nil) {
        if (err!=NULL)
            *err=myErr;
        
        return NO;
    }
    
    if (!contains) {
        if (![server insertBook:self.book error:err])
            return NO;
    }
    
    return [server insertOffer:self error:err];
}

@end
