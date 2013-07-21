//
//  DBTOffer.m
//  DontBurnThem
//
//  Created by Pietro Saccardi on 21/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import "DBTOffer.h"
#import "DBTServer.h"

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

- (BOOL)pushSynchronouslyToServerError:(NSError **)err
{
    DBTServer *server=[DBTServer server];
    NSError *myErr=nil;
    
    BOOL contains=[server containsBook:self.book error:&myErr];
    
    if (myErr!=nil) {
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
