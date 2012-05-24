//
//  DVCategory.h
//  SaveIt
//
//  Created by Bhagya on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DVCategory : NSObject
{
    NSUInteger mCategoryID;
    NSString * mCategeoryName;
    NSMutableArray *mFieldNames;
    NSTimeInterval *mLastModified;
    NSString *mIconName;
}

@property(nonatomic,assign) NSUInteger categoryID;
@property(strong,nonatomic) NSString *categoryName;
@property(readonly, nonatomic) NSDate *lastModifiedDate;
@property(strong, nonatomic) NSString *iconName;
//category creation
+(DVCategory*)newCategory;
+(DVCategory*)newCategoryWithID:(NSUInteger)catID;


-(BOOL)hasCategoryID;

//methods
-(void)setFieldNames:(NSString *)fieldNames scramble:(NSString*)scramble;
-(NSString*)fieldValueString;
-(NSString*)scrambleString;

//traverse the fields list
-(NSUInteger)totalFieldNames;
-(NSString*)fieldNameAtIndex:(NSUInteger)fieldIndex;
-(BOOL)isFieldScrambledAtIndex:(NSUInteger)fieldIndex;

@end
