//
//  DVCardManager.h
//  SaveIt
//
//  Created by Bharath Booshan on 5/21/12.
//  Copyright (c) 2012 Integral Development Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DVCard;

extern NSString * DVCardsUpdateNotificationEvent;

@interface DVCardManager : NSObject
{
    NSMutableArray *mObjects;

}
-(void)registerForUpdates:(SEL)selector target:(id)self;
-(void)unregisterFromUpdates:(id)target;

-(NSUInteger)totalCards;
-(DVCard *)cardAtIndex:(NSUInteger)index;
-(void)loadCards:(void (^)(BOOL finished))completed;


@end
