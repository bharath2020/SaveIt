//
//  DVCategoryManager.h
//  SaveIt
//
//  Created by Bhagya on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  DVCategory;

extern NSString * DVCategoriesUpdateNotification;

@interface DVCategoryManager : NSObject
{
    NSMutableArray *mObjects;
     
}

+(DVCategoryManager*)sharedInstance;

-(void)registerForUpdates:(SEL)selector target:(id)self;
-(void)unregisterFromUpdates:(id)target;

-(NSUInteger)totalCategories;
-(DVCategory *)categoryAtIndex:(NSUInteger)index;
-(void)loadCategories:(void (^)(BOOL finished))completed;

-(void)addCategory:(DVCategory*)newCategory;
-(void)removeCategory:(DVCategory*)category;

@end
