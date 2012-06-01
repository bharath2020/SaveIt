//
//  DVCategoryManager.m
//  SaveIt
//
//  Created by Bhagya on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DVCategoryManager.h"
#import "DVHelper.h"
#import "FMDatabase.h"
#import "DVCategory.h"



NSString * DVCategoriesUpdateNotification = @"categories_update";
NSString * DVCategoriesSelectionUpdatedNotification = @"categories_selection_update";

static DVCategoryManager *sSharedManager = nil;
@implementation DVCategoryManager

+(DVCategoryManager*)sharedInstance
{
    if( sSharedManager == nil )
    {
        sSharedManager = [[DVCategoryManager alloc] init];
    }
    return  sSharedManager;
}

//-----------------Init
-(id)init
{
    self = [super init];
    if( self )
    {
        mObjects = [[NSMutableArray alloc] init];
        _selectedItems = [[NSMutableSet alloc] init];
        [self loadCategories:^(BOOL completed){
        }];
    }
    return self;
}

//-----------------Methods

-(void)registerForUpdates:(SEL)selector target:(id)observer
{
   @try
    {
        [self unregisterFromUpdates:observer];
        [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:DVCategoriesUpdateNotification object:self];
    }
    @catch(NSException *e)
    {
        
    }
}

-(void)unregisterFromUpdates:(id)target
{
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:target name:DVCategoriesUpdateNotification object:self];
    }
    @catch (NSException *exception) {
        
    }
}

-(void)registerForSelectionUpdates:(SEL)selector target:(id)target
{
    @try
    {
        [self unregisterFromSelectionUpdates:target];
        [[NSNotificationCenter defaultCenter] addObserver:target selector:selector name:DVCategoriesSelectionUpdatedNotification object:self];
    }
    @catch(NSException *e)
    {
        
    }
}

-(void)unregisterFromSelectionUpdates:(id)target
{
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:target name:DVCategoriesSelectionUpdatedNotification object:self];
    }
    @catch (NSException *exception) {
        
    }
}

-(NSUInteger)totalCategories
{
    return [mObjects count];
}

-(DVCategory *)categoryAtIndex:(NSUInteger)index
{
    DVCategory *category = nil;
    if (index < [mObjects count] )
    {
        category = [mObjects objectAtIndex:index];
    }
    return  category;
}

-(void)loadCategories:(void (^)(BOOL finished))completed
{
    FMDatabaseQueue *dbQueue = [DVHelper databaseQueue];
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *reverse){
        FMResultSet *result = [db executeQuery:@"SELECT * FROM CATEGORY"];
        NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
        
        while ([result next]) {
            DVCategory *category = [[DVCategory alloc]init];
            category.categoryID = [result unsignedLongLongIntForColumn:CATEGORY_ID];
            category.categoryName = [result stringForColumn:CATEGORY_NAME];
            [category setFieldNames:[result stringForColumn:CATEGORY_FIELD_NAMES] scramble:[result stringForColumn:CATEGORY_FIELD_SCRAMBLE]];
            category.iconName = [result stringForColumn:CATEGORY_FIELD_ICON_NAME];
            [categoryArray addObject:category];
            }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [mObjects removeAllObjects];
            [mObjects addObjectsFromArray:categoryArray];
            [[NSNotificationCenter defaultCenter ] postNotificationName:DVCategoriesUpdateNotification object:self];
            completed(YES);
        });
    }];
}

#pragma Category Manipulate Method
-(void)addCategory:(DVCategory*)newCategory
{
    FMDatabaseQueue *dbQueue = [DVHelper databaseQueue];
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *reverse){
        
        NSString *query = [NSString stringWithFormat:@"INSERT INTO CATEGORY(%@, %@, %@, %@) VALUES('%@', '%@', '%@', '%@' )", CATEGORY_NAME, CATEGORY_FIELD_NAMES,CATEGORY_FIELD_SCRAMBLE, CATEGORY_FIELD_ICON_NAME , newCategory.categoryName, [newCategory fieldValueString], [newCategory scrambleString], newCategory.iconName ];
        NSLog(@"%@", query);
        BOOL status = [db executeUpdate:query];
        if( status )
        {
            newCategory.categoryID = [db lastInsertRowId];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [mObjects addObject:newCategory];
            [[NSNotificationCenter defaultCenter ] postNotificationName:DVCategoriesUpdateNotification object:self];
        });
    }];
}

-(void)removeCategory:(DVCategory*)category
{
    FMDatabaseQueue *dbQueue = [DVHelper databaseQueue];
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *reverse){
        if( [category hasCategoryID] )
        {
            BOOL status = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM CATEGORY WHERE %@ = %u", CATEGORY_ID, category.categoryID]];
            if( status )
            {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [mObjects removeObject:category];
                    [[NSNotificationCenter defaultCenter ] postNotificationName:DVCategoriesUpdateNotification object:self];
                });
            }
        }
    }];
}

//selection management
- (void)deselectItemAtIndex:(NSUInteger)index
{
    DVCategory *category = [self categoryAtIndex:index];
    if( category )
    {
        [_selectedItems removeObject:category];
        [[NSNotificationCenter defaultCenter] postNotificationName:DVCategoriesSelectionUpdatedNotification object:self];
    }
}

- (void)toggleSelectionAtIndex:(NSUInteger)index
{
    if( [self isItemAtIndexSelected:index] )
    {
        [self deselectItemAtIndex:index];
    }
    else 
    {
        [self selectItemAtIndex:index];
    }
}

- (void)selectItemAtIndex:(NSUInteger)index
{
    DVCategory *category = [self categoryAtIndex:index];
    if( category )
    {
        [_selectedItems addObject:category];
        [[NSNotificationCenter defaultCenter] postNotificationName:DVCategoriesSelectionUpdatedNotification object:self];
    }
}

- (BOOL)isItemAtIndexSelected:(NSUInteger)index
{
    DVCategory *category = [self categoryAtIndex:index];
    return   [_selectedItems containsObject:category];
}

- (NSArray *)selectedItems
{
    return  [_selectedItems allObjects];
}

- (void)removeAllSelectedItems
{
    FMDatabaseQueue *dbQueue = [DVHelper databaseQueue];
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *reverse){
        
        NSMutableString *selectedItemIndex = [[NSMutableString alloc] initWithString:@""];

        for( DVCategory *category in _selectedItems )
        {
            if( [category hasCategoryID] )
            {
                   [selectedItemIndex appendFormat:@"%u,", category.categoryID];
            }
            
            //remove the last comma
            if( [selectedItemIndex length]>1)
            {
                selectedItemIndex = [[selectedItemIndex substringWithRange:NSMakeRange(0, [selectedItemIndex length]-1)] mutableCopy];
            }
        }
        
        
            BOOL status = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM CATEGORY WHERE %@ IN ( %@ )", CATEGORY_ID, selectedItemIndex]];
            if( status )
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [mObjects removeObjectsInArray:[_selectedItems allObjects]];
                    [[NSNotificationCenter defaultCenter ] postNotificationName:DVCategoriesUpdateNotification object:self];
                });
            }
    }];
}

- (void)selectAll
{
    [_selectedItems removeAllObjects];
    [_selectedItems addObjectsFromArray:mObjects];
    [[NSNotificationCenter defaultCenter] postNotificationName:DVCategoriesSelectionUpdatedNotification object:self];
}

@end
