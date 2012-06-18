//
//  DVCategory.m
//  SaveIt
//
//  Created by Bhagya on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DVCategory.h"
#import "DVCardManager.h"
#import "DVCard.h"
#import "DVHelper.h"
#import "UIImage+Loader.h"

//----------Constants
#define CAT_FIELD_NAME_KEY @"fieldname"
#define CAT_FIELD_SCRAMBLE_KEY @"isscramble"

NSString *DVCategoryUpdatedNotification = @"category_update";

@interface DVCategory()
- (void)categoryUpdated;
@end

@implementation DVCategory
@synthesize categoryName;
@synthesize categoryID=mCategoryID;
@dynamic lastModifiedDate;
@synthesize lasteModifiedInterval=mLastModified;
@synthesize iconName;
@dynamic icon;
@synthesize cardManager = mCardManager;


//-----------------Init
-(id)init
{
    self = [super init];
    if( self )
    {
        mFieldNames = [[NSMutableArray alloc] init];
        mCardManager = [[DVCardManager alloc] init];
        mCardManager.parentCategory = self;
        mCategoryID = NSUIntegerMax;
    }
    return self;
}


- (id)copyWithZone:(NSZone *)zone
{
    DVCategory *newCategory = [[DVCategory alloc] init];
    newCategory.categoryID = self.categoryID;
    newCategory.iconName = self.iconName;
    newCategory.lasteModifiedInterval = self.lasteModifiedInterval;
    if( self->mFieldNames )
    {
        for( NSDictionary *dict in self->mFieldNames )
        {
            [newCategory->mFieldNames addObject:[NSMutableDictionary dictionaryWithDictionary:dict]];
        }
    }
    return  newCategory;    
}

-(void)copyFromCategory:(DVCategory*)otherCategory
{
    self.categoryID = otherCategory.categoryID;
    self.categoryName = otherCategory.categoryName;
    self.iconName = otherCategory.iconName;
    self.lasteModifiedInterval = otherCategory.lasteModifiedInterval;
    if( self->mFieldNames )
    {
        [self->mFieldNames removeAllObjects];
        [self->mFieldNames  addObjectsFromArray:otherCategory->mFieldNames];
    }

}

- (void)dealloc
{
    NSUInteger totalCards = [mCardManager totalCards];
    for( NSUInteger cardIndex = 0 ; cardIndex < totalCards ; cardIndex++ )
    {
        DVCard *card = [mCardManager cardAtIndex:cardIndex];
        card.category = nil;
    }
}

+(DVCategory*)newCategory
{
    return  [[DVCategory alloc] init];    
}

+(DVCategory*)newCategoryWithID:(NSUInteger)catID
{
    DVCategory *category = [[DVCategory alloc] init];
    category.categoryID = catID;
    return  category;
}

//------------------gettesrs
- (NSString *)iconName
{
    return iconName ? iconName : @"";
}

- (UIImage*)icon
{
    UIImage *icon =   [UIImage imageFromDocuments:self.iconName];
    return  icon!= nil ? icon : [UIImage imageNamed:@"no_cat_image.png"];
}

//-----------------Methods

-(BOOL)hasCategoryID
{
    return mCategoryID != NSUIntegerMax;
}

-(NSUInteger)totalFieldNames
{
    return [mFieldNames count];
}

-(NSString*)fieldNameAtIndex:(NSUInteger)fieldIndex
{
    NSString *fieldName = @"";
    if (fieldIndex < [mFieldNames count] )
    {
        fieldName = [NSString stringWithFormat:@"Field %d",fieldIndex+1];
    }
    return  fieldName;
}

-(NSString*)fieldValueAtIndex:(NSUInteger)fieldIndex
{
    NSString *fieldName = @"";
    if (fieldIndex < [mFieldNames count] )
    {
        fieldName = [[mFieldNames objectAtIndex:fieldIndex] valueForKey:CAT_FIELD_NAME_KEY];
    }
    return  fieldName;
}

-(void)addFieldValue:(NSString*)fieldValue
{
    [mFieldNames addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:fieldValue, CAT_FIELD_NAME_KEY, [NSNumber numberWithBool:NO], CAT_FIELD_SCRAMBLE_KEY, nil]];    
}

-(void)removeFieldValueAtIndex:(NSUInteger)fieldIndex
{
    if( fieldIndex < [mFieldNames count] )
    {
        [mFieldNames removeObjectAtIndex:fieldIndex];   
    }
}

-(void)setFieldValue:(NSString*)newValue atIndex:(NSUInteger)index
{
    if( index < [mFieldNames count] && newValue)
    {
        [[mFieldNames objectAtIndex:index] setObject:newValue forKey:CAT_FIELD_NAME_KEY];
    }
}


-(BOOL)isFieldScrambledAtIndex:(NSUInteger)fieldIndex
{
    BOOL isScrambled = NO;
    if (fieldIndex < [mFieldNames count] )
    {
        isScrambled = [(NSString*)[[mFieldNames objectAtIndex:fieldIndex] valueForKey:CAT_FIELD_SCRAMBLE_KEY] boolValue];
    }
    return  isScrambled;
}

-(BOOL)toggleScrambleAtIndex:(NSUInteger)fieldIndex
{
    BOOL isScrambled = [self isFieldScrambledAtIndex:fieldIndex];
    isScrambled = !isScrambled;
    if( fieldIndex < [mFieldNames count] )
    {
        [[mFieldNames objectAtIndex:fieldIndex] setObject:(isScrambled ? @"1" : @"0")  forKey:CAT_FIELD_SCRAMBLE_KEY];
    }
    return isScrambled;
}


-(void)setFieldNames:(NSString *)fieldNames scramble:(NSString*)scramble
{
    NSArray *fieldNameArray = [fieldNames componentsSeparatedByString:@"|"];
    NSArray *scrambleArray = [scramble componentsSeparatedByString:@"|"];
    
    if( [fieldNameArray count] == [scrambleArray count] )
    {
        [mFieldNames removeAllObjects];
        for( NSUInteger index = 0 ; index < [fieldNameArray count] ; index++ )
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[fieldNameArray objectAtIndex:index], CAT_FIELD_NAME_KEY,  [scrambleArray objectAtIndex:index], CAT_FIELD_SCRAMBLE_KEY, nil];
            [mFieldNames addObject:dict];
        }
    }
}



-(NSString*)fieldValueString
{
    NSMutableArray *fieldValues = [[NSMutableArray alloc] init];
    NSUInteger fieldCount = [self totalFieldNames];
    for ( NSUInteger fieldIndex=0; fieldIndex < fieldCount ; fieldIndex++ )
    {
        [fieldValues addObject:[self fieldValueAtIndex:fieldIndex]];
    }
    return  [fieldValues componentsJoinedByString:@"|"];
}

-(NSString*)scrambleString
{
    NSMutableArray *fieldValues = [[NSMutableArray alloc] init];
    NSUInteger fieldCount = [self totalFieldNames];
    for ( NSUInteger fieldIndex=0; fieldIndex < fieldCount ; fieldIndex++ )
    {
        BOOL isScrambled = [self isFieldScrambledAtIndex:fieldIndex];
        [fieldValues addObject:(isScrambled ? @"1" : @"0")];
    }
    return  [fieldValues componentsJoinedByString:@"|"];
}

-(void)loadCards:(void (^)(BOOL finished))compltedBlock
{
    [mCardManager loadCards:compltedBlock];
}

#pragma Category Update
- (void)categoryUpdated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:DVCategoryUpdatedNotification object:nil];
}

@end
