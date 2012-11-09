//
//  DVCard.m
//  SaveIt
//
//  Created by Bhagya on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DVCard.h"
#import "DVHelper.h"
#import "DVCategory.h"
#import "UIImage+Loader.h"

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


NSString *const DVCardDidUpdateNotification = @"card_update";
NSString *const DVCardDidUpdateNotification = @"card_update"; 


@implementation DVCard
//-------------Synthesize
@synthesize  cardID=mCardID;
@synthesize  title=mTitle;
@synthesize  category=mCategory;
@synthesize  iconName=mIconName;
@synthesize  note=mNote;
@synthesize  isFavorite=mIsFavorite;
@dynamic     lastModifiedDate;
@synthesize  lastModifiedInterval;

//----------- init
- (id)init
{
    self = [super init];
    if( self )
    {
        mFields = [[NSMutableArray alloc] init];
        self.cardID = NSUIntegerMax;
    }
    return self;
}

#pragma Copying
- (id)copyWithZone:(NSZone *)zone
{
    DVCard *newCard = [[DVCard alloc] init];
    newCard.cardID = self.cardID;
    newCard.iconName = self.iconName;
    newCard.lastModifiedInterval = self.lastModifiedInterval;
    newCard.title = self.title;
    newCard.note = self.note;
    newCard.isFavorite = self.isFavorite;
    newCard.category  = self.category;
    if( self->mFields )
    {
        for( NSDictionary *dict in self->mFields )
        {
            [newCard->mFields addObject:[NSMutableDictionary dictionaryWithDictionary:dict]];
        }
    }
    return  newCard;    
}

-(void)copyFromCard:(DVCard*)otherCard
{
    self.cardID = otherCard.cardID;
    self.title = otherCard.title;
    self.iconName = otherCard.iconName;
    self.lastModifiedInterval = otherCard.lastModifiedInterval;
    self.note = otherCard.note;
    self.isFavorite = otherCard.isFavorite;
    self.category = otherCard.category;
    if( self->mFields )
    {
        [self->mFields removeAllObjects];
        [self->mFields  addObjectsFromArray:otherCard->mFields];
    }
}

#pragma Getters
- (NSString *)note
{
    return mNote ? mNote : @"";
}
 - (NSString *)title
{
    return  mTitle ? mTitle : @"";
}

#pragma Methods

-(BOOL)hasCardId
{
    return self.cardID != NSUIntegerMax;
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

-(void)setFieldNames:(NSString *)fieldNames scramble:(NSString*)scramble fieldValues:(NSString *)fieldValues
{
    NSArray *fieldNameArray = [fieldNames componentsSeparatedByString:@"|"];
    NSArray *scrambleArray = [scramble componentsSeparatedByString:@"|"];
    NSArray *fieldValueArray = [fieldValues componentsSeparatedByString:@"|"];
    
    if( [fieldNameArray count] == [scrambleArray count] )
    {
        [mFields removeAllObjects];
        for( NSUInteger index = 0 ; index < [fieldNameArray count] ; index++ )
        {
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[fieldNameArray objectAtIndex:index], CARD_FIELD_NAME,  [scrambleArray objectAtIndex:index],CARD_FIELD_SCRAMBLE,[fieldValueArray objectAtIndex:index], CARD_FIELD_VALUE,nil];
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

-(BOOL)toggleScrambleAtIndex:(NSUInteger)fieldIndex
{
    BOOL isScrambled = [self isFieldScrambledAtIndex:fieldIndex];
    isScrambled = !isScrambled;
    if( fieldIndex < [mFields count] )
    {
        [[mFields objectAtIndex:fieldIndex] setObject:(isScrambled ? @"1" : @"0")  forKey:CARD_FIELD_SCRAMBLE];
    }
    return isScrambled;
}

-(void)setScramble:(BOOL)scrambleValue atIndex:(NSUInteger)index
{
    if( index < [mFields count] )
    {
        [[mFields objectAtIndex:index] setObject:(scrambleValue ? @"1" : @"0")  forKey:CARD_FIELD_SCRAMBLE];
    }
}

-(void)addFieldValue:(NSString*)fieldValue fieldName:(NSString*)fieldName isScramble:(BOOL)scramble
{
    [mFields addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:fieldName, CARD_FIELD_NAME,fieldValue, CARD_FIELD_VALUE,  [NSNumber numberWithBool:scramble], CARD_FIELD_SCRAMBLE, nil]];    
}

-(void)removeFieldValueAtIndex:(NSUInteger)fieldIndex
{
    if( fieldIndex < [mFields count] )
    {
        [mFields removeObjectAtIndex:fieldIndex];   
    }
}

-(void)setFieldName:(NSString *)newName atIndex:(NSUInteger)index
{
    if( index < [mFields count] && newName)
    {
        [[mFields objectAtIndex:index] setObject:newName forKey:CARD_FIELD_NAME];
    }

}

-(void)setFieldValue:(NSString*)newValue atIndex:(NSUInteger)index
{
    if( index < [mFields count] && newValue)
    {
        [[mFields objectAtIndex:index] setObject:newValue forKey:CARD_FIELD_VALUE];
    }
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

- (UIImage*)icon
{
    UIImage *icon =   [UIImage imageFromDocuments:self.iconName];
    return  icon!= nil ? icon : [UIImage imageNamed:@"no_cat_image.png"];
}

-(void)loadDetails
{
    FMDatabaseQueue *dbQueue = [DVHelper databaseQueue];
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *reverse){
        
        FMResultSet *result = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM CARD WHERE %@ = %u",CARD_ID, self.cardID ]];
        
        while ([result next]) {
            self.cardID = [result unsignedLongLongIntForColumn:CARD_ID];
            self.title = [result stringForColumn:CARD_TITLE];
            self.iconName = [result stringForColumn:CARD_ICON_NAME];
            NSString *fieldNames = [result stringForColumn:CARD_FIELD_NAME];
            NSString *fieldValues = [result stringForColumn:CARD_FIELD_VALUES];
            NSString *scramble = [result stringForColumn:CARD_FIELD_SCRAMBLE];
            [self setFieldNames:fieldNames scramble:scramble fieldValues:fieldValues];
            self.isFavorite = [result boolForColumn:CARD_IS_FAVORITE];
            self.lastModifiedInterval = [result doubleForColumn:CARD_LAST_MODIFIED];
            
            
            NSUInteger categoryID = [result unsignedLongLongIntForColumn:CARD_CATEGORY_ID];
            FMResultSet *categorySearchResult = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM CATEGORY WHERE %@ = %u", CATEGORY_ID , categoryID]];
            
            if( [categorySearchResult next] )
            {
                DVCategory *category = [DVCategory newCategoryWithID:categoryID];
                
                category.categoryID = [categorySearchResult unsignedLongLongIntForColumn:CATEGORY_ID];
                category.categoryName = [categorySearchResult stringForColumn:CATEGORY_NAME];
                category.iconName = [categorySearchResult stringForColumn:CATEGORY_FIELD_ICON_NAME];
                self.category = category;
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter ] postNotificationName:DVCardDidUpdateNotification object:self];
        });
    }];
}

#pragma Creation
+(DVCard*)cardFromCategory:(DVCategory*)category
{
    DVCard *card  = [[DVCard alloc] init];
    for( NSUInteger fieldIndex = 0 ; fieldIndex < [category totalFieldNames]; fieldIndex++ )
    {
        [card addFieldValue:@"" fieldName:[category fieldValueAtIndex:fieldIndex] isScramble:[category isFieldScrambledAtIndex:fieldIndex]];
    }
    card.iconName = category.iconName;
    
    card.category = category;
    return  card;
}

@end
