//
//  DVCardManager.h
//  SaveIt
//
//  Created by Bharath Booshan on 5/21/12.
//  Copyright (c) 2012 Integral Development Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DVCard,DVCategory;

extern NSString * DVCardsUpdateNotificationEvent;



@interface DVCardManager : NSObject
{
    NSMutableArray *mObjects;
    __unsafe_unretained DVCategory *_parentCategory;

}
@property(nonatomic, unsafe_unretained) DVCategory *parentCategory;

-(void)registerForUpdates:(SEL)selector target:(id)self;
-(void)unregisterFromUpdates:(id)target;

-(NSUInteger)totalCards;
-(DVCard *)cardAtIndex:(NSUInteger)index;
-(void)loadCards:(void (^)(BOOL finished))completed;


@end
