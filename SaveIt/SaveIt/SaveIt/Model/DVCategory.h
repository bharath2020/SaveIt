//
//  DVCategory.h
//  SaveIt
//
//  Created by Bhagya on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DVCardManager;

//---------Table Keys
#define CATEGORY_ID @"category_id"
#define CATEGORY_NAME @"category_name"
#define CATEGORY_FIELD_NAMES  @"category_fields"
#define CATEGORY_FIELD_SCRAMBLE  @"category_field_scramble"
#define CATEGORY_FIELD_ICON_NAME @"category_icon_name"

extern NSString *DVCategoryUpdatedNotification;

@interface DVCategory : NSObject<NSCopying>
{
    @public
    NSUInteger mCategoryID;
    NSString * mCategeoryName;
    NSMutableArray *mFieldNames;
    NSTimeInterval mLastModified;
    NSString *mIconName;
    DVCardManager *mCardManager;
}

@property(nonatomic,assign) NSUInteger categoryID;
@property(strong,nonatomic) NSString *categoryName;
@property(readonly, nonatomic) NSDate *lastModifiedDate;
@property(strong, nonatomic) NSString *iconName;
@property(strong, nonatomic, readonly) UIImage *icon;
@property(nonatomic, assign) NSTimeInterval lasteModifiedInterval;
@property(nonatomic, strong) DVCardManager *cardManager;
//category creation
+(DVCategory*)newCategory;
+(DVCategory*)newCategoryWithID:(NSUInteger)catID;
-(void)copyFromCategory:(DVCategory*)otherCategory;

-(BOOL)hasCategoryID;
-(BOOL)isEqualToCategory:(DVCategory *)otherCategory;

//methods
-(void)setFieldNames:(NSString *)fieldNames scramble:(NSString*)scramble;
-(NSString*)fieldValueString;
-(NSString*)scrambleString;

//traverse the fields list
-(NSUInteger)totalFieldNames;
-(NSString*)fieldNameAtIndex:(NSUInteger)fieldIndex;
-(BOOL)isFieldScrambledAtIndex:(NSUInteger)fieldIndex;
-(BOOL)toggleScrambleAtIndex:(NSUInteger)fieldIndex;
-(NSString*)fieldValueAtIndex:(NSUInteger)fieldIndex;
-(void)addFieldValue:(NSString*)fieldValue;
-(void)removeFieldValueAtIndex:(NSUInteger)fieldIndex;
-(void)setFieldValue:(NSString*)newValue atIndex:(NSUInteger)index;

//card list
-(NSUInteger)totalCards;


//load the cards on completion the completedBlock will be invoked where you can get the cards loaded
-(void)loadCards:(void (^)(BOOL finished))compltedBlock;


@end
