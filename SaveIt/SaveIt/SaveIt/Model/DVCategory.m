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
@synthesize categoryID;
@dynamic lastModifiedDate;
@synthesize iconName;
@dynamic icon;


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


//- (id)copyWithZone:(NSZone *)zone
//{
//    
//}

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
    return  nil;
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
    return categoryID != NSUIntegerMax;
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
    [mFieldNames addObject:fieldValue];    
}

-(void)removeFieldValueAtIndex:(NSUInteger)fieldIndex
{
    if( fieldIndex < [mFieldNames count] )
    {
        [mFieldNames removeObjectAtIndex:fieldIndex];   
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



-(void)setFieldNames:(NSString *)fieldNames scramble:(NSString*)scramble
{
    NSArray *fieldNameArray = [fieldNames componentsSeparatedByString:@"|"];
    NSArray *scrambleArray = [scramble componentsSeparatedByString:@"|"];
    
    if( [fieldNameArray count] == [scrambleArray count] )
    {
        [mFieldNames removeAllObjects];
        for( NSUInteger index = 0 ; index < [fieldNameArray count] ; index++ )
        {
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[fieldNameArray objectAtIndex:index], CAT_FIELD_NAME_KEY,  [scrambleArray objectAtIndex:index], CAT_FIELD_SCRAMBLE_KEY, nil];
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
        [fieldValues addObject:[self fieldNameAtIndex:fieldIndex]];
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
