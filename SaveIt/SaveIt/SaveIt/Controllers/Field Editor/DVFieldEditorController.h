//
//  DVFieldEditorController.h
//  SaveIt
//
//  Created by Bharath Booshan on 7/3/12.
//  Copyright (c) 2012 Integral Development Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  DVFieldEditorController;

@protocol DVFieldEditorProtocol <NSObject>

- (void)fieldEditor:(DVFieldEditorController*)controller didEditFieldName:(NSString*)fieldName fieldValue:(NSString *)fieldValue scramble:(BOOL)scramble;
- (void)fieldEditorDidCancel:(DVFieldEditorController*)controller;
@end

@interface DVFieldEditorController : UIViewController
{
    IBOutlet UITextField *mFieldNameField;
    IBOutlet UITextField *mFieldValueField;
    IBOutlet UIImageView *mFieldScrambleImageView;
    BOOL isScrambled;
    __unsafe_unretained id<DVFieldEditorProtocol> fieldEditorDelegate;
}
@property(nonatomic, assign) BOOL isScrambled;
@property(nonatomic, unsafe_unretained)id<DVFieldEditorProtocol> fieldEditorDelegate; 

- (IBAction)scramble:(id)sender;
- (void)editWithFieldName:(NSString *)fieldName fieldValue:(NSString *)fieldValue scramble:(BOOL)scramble;
                                                            

@end
