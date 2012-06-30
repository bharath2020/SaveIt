//
//  DVIconPickerControllerViewController.h
//  SaveIt
//
//  Created by Bharath Booshan on 6/26/12.
//  Copyright (c) 2012 Integral Development Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTGridView.h"

@class DVIconPickerController;

@protocol DVIconPickerDelegate <NSObject>

- (void)iconPicker:(DVIconPickerController *)picker didSelectImage:(UIImage *)image withName:(NSString *)imageName;

@end

@interface DVIconPickerController : UIViewController<DTGridViewDataSource,DTGridViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    DTGridView *mIconGridView;
    __unsafe_unretained id <DVIconPickerDelegate> _pickerDelegate;
}
@property(nonatomic, unsafe_unretained)id <DVIconPickerDelegate> pickerDelegate;

-(void)showImages;

@end
