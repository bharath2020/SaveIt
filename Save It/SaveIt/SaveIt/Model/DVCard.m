//
//  DVCard.m
//  SaveIt
//
//  Created by Bhagya on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DVCard.h"

#define CARD_FIELD_ID  @"card_id"
#define CARD_TITLE     @"card_title"
#define CARD_CATEGORY_ID @"card_category_id"
#define CARD_ICON_NAME @"card_icon_name"
#define CARD_NOTE       @"card_note"
#define CARD_IS_FAVORITE @"card_is_favorite"
#define CARD_LAST_MODIFIED_TIME @"card_last_modified"
#define CARD_FIELD_NAME @"card_field_name"
#define CARD_FIELD_VALUE @"card_field_value"

//-----card field dict
#define CARD_FIELD_NAME @"card_field_name"
#define CARD_FIELD_VALUE @"card_field_value"
#define CARD_FIELD_SCRAMBLE @"card_field_scramble"



@implementation DVCard
//-------------Synthesize
@synthesize  cardID=mCardID;
@synthesize  title=mTitle;
@synthesize  category=mCategory;
@synthesize  iconName=mIconName;
@synthesize  note=mNote;
@synthesize  isFavorite=mIsFavorite;
@dynamic   lastModifiedDate;

//----------- init
- (id)init
{
    self = [super init];
    if( self )
    {
        mFields = [[NSMutableArray alloc] init];
    }
    return self;
}

-(NSDate*)lastModifiedDate
{
    return [NSDate dateWithTimeIntervalSince1970:mLastModifiedDate];
}


-(NSUInteger)totalFieldNames
{
    return [mFields count];
}

-(NSString*)fieldNameAtIndex:(NSUInteger)fieldIndex
{
    NSString *fieldName = @"";
    if (fieldIndex < [mFields count] )
    {
        fieldName = [[mFields objectAtIndex:fieldIndex] valueForKey:CARD_FIELD_NAME];
    }
    return  fieldName;
}


-(NSString*)fieldValueAtIndex:(NSUInteger)fieldIndex
{
    NSString *fieldName = @"";
    if (fieldIndex < [mFields count] )
    {
        fieldName = [[mFields objectAtIndex:fieldIndex] valueForKey:CARD_FIELD_VALUE];
    }
    return  fieldName;
}

-(void)setFieldNames:(NSString *)fieldNames scramble:(NSString*)scramble
{
    NSArray *fieldNameArray = [fieldNames componentsSeparatedByString:@"|"];
    NSArray *scrambleArray = [scramble componentsSeparatedByString:@"|"];
    
    if( [fieldNameArray count] == [scrambleArray count] )
    {
        [mFields removeAllObjects];
        for( NSUInteger index = 0 ; index < [fieldNameArray count] ; index++ )
        {
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[fieldNameArray objectAtIndex:index], CARD_FIELD_NAME,  [scrambleArray objectAtIndex:index],CARD_FIELD_VALUE,  nil];
            [mFields addObject:dict];
        }
    }

}

-(BOOL)isFieldScrambledAtIndex:(NSUInteger)fieldIndex
{
    BOOL isScrambled = NO;
    if (fieldIndex < [mFields count] )
    {
        isScrambled = [(NSString*)[[mFields objectAtIndex:fieldIndex] valueForKey:CARD_FIELD_SCRAMBLE] boolValue];
    }
    return  isScrambled;
}

-(NSString*)fieldNameString
{
    NSMutableArray *fieldNames = [[NSMutableArray alloc] init];
    NSUInteger fieldCount = [self totalFieldNames];
    for ( NSUInteger fieldIndex=0; fieldIndex < fieldCount ; fieldIndex++ )
    {
        [fieldNames addObject:[self fieldNameAtIndex:fieldIndex]];
    }
    return  [fieldNames componentsJoinedByString:@"|"];
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


@end
