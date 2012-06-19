//
//  DVCard.h
//  SaveIt
//
//  Created by Bhagya on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DVCategory;

#define CARD_ID @"card_id"
#define CARD_TITLE @"card_title"
#define CARD_CATEGORY_ID @"card_category_id"
#define CARD_ICON_NAME @"card_icon_name"
#define CARD_FIELD_NAME @"card_field_name"
#define CARD_FIELD_SCRAMBLE @"card_field_scramble"
#define CARD_FIELD_VALUES @"card_field_value"
#define CARD_NOTE @"card_note"
#define CARD_IS_FAVORITE @"card_is_favorite"
#define CARD_LAST_MODIFIED @"card_last_modified"

extern NSString *const DVCardDidUpdateNotification;

@class DVCategory;

@interface DVCard : NSObject
{
    NSUInteger mCardID;
    NSString *mTitle;
    DVCategory *mCategory;
    NSString *mIconName;
    NSMutableArray *mFields;
    NSString *mNote;
    BOOL mIsFavorite;
    NSTimeInterval mLastModifiedDate;
}

@property(nonatomic) NSUInteger cardID;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong)DVCategory *category;
@property(nonatomic, strong)NSString *iconName;
@property(nonatomic, strong)NSString *note;
@property(nonatomic) BOOL isFavorite;
@property(nonatomic, readonly) NSDate *lastModifiedDate;
@property(nonatomic, assign) NSTimeInterval lastModifiedInterval;
@property(strong, nonatomic, readonly) UIImage *icon;

+(DVCard*)cardFromCategory:(DVCategory*)category;
-(BOOL)hasCardId;

#pragma mark field list
-(NSUInteger)totalFieldNames;
-(NSString*)fieldNameAtIndex:(NSUInteger)fieldIndex;
-(NSString*)fieldValueAtIndex:(NSUInteger)fieldIndex;
-(BOOL)isFieldScrambledAtIndex:(NSUInteger)fieldIndex;
-(void)addFieldValue:(NSString*)fieldValue fieldName:(NSString*)fieldName isScramble:(BOOL)scramble;
-(void)removeFieldValueAtIndex:(NSUInteger)fieldIndex;
-(void)setFieldValue:(NSString*)newValue atIndex:(NSUInteger)index;

-(NSString*)fieldNameString;
-(NSString*)fieldValueString;
-(NSString*)scrambleString;
-(void)setFieldNames:(NSString *)fieldNames scramble:(NSString*)scramble fieldValues:(NSString *)fieldValues;

-(void)loadDetails;

@end
