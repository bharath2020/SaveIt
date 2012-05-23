//
//  DVCard.h
//  SaveIt
//
//  Created by Bhagya on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

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

#pragma mark field list
-(NSUInteger)totalFieldNames;
-(NSString*)fieldNameAtIndex:(NSUInteger)fieldIndex;
-(NSString*)fieldValueAtIndex:(NSUInteger)fieldIndex;
-(BOOL)isFieldScrambledAtIndex:(NSUInteger)fieldIndex;

-(NSString*)fieldNameString;
-(NSString*)fieldValueString;
-(NSString*)scrambleString;
-(void)setFieldNames:(NSString *)fieldNames scramble:(NSString*)scramble fieldValues:(NSString *)fieldValues;

@end
