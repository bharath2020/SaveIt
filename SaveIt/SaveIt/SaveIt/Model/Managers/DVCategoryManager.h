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
extern NSString * DVCategoriesSelectionUpdatedNotification;

@interface DVCategoryManager : NSObject
{
    NSMutableArray *mObjects;
    NSMutableSet *_selectedItems;

     
}

+(DVCategoryManager*)sharedInstance;

-(void)registerForUpdates:(SEL)selector target:(id)target;
-(void)unregisterFromUpdates:(id)target;
-(void)registerForSelectionUpdates:(SEL)selector target:(id)target;
-(void)unregisterFromSelectionUpdates:(id)target;

-(NSUInteger)totalCategories;
-(DVCategory *)categoryAtIndex:(NSUInteger)index;
-(void)loadCategories:(void (^)(BOOL finished))completed;

-(void)addCategory:(DVCategory*)newCategory;
-(void)removeCategory:(DVCategory*)category;

//selection management
- (void)selectItemAtIndex:(NSUInteger)index;
- (BOOL)isItemAtIndexSelected:(NSUInteger)index;
- (NSArray *)selectedItems;
- (void)removeAllSelectedItems;
- (void)toggleSelectionAtIndex:(NSUInteger)index;
- (void)deselectItemAtIndex:(NSUInteger)index;
- (void)selectAll;

@end
