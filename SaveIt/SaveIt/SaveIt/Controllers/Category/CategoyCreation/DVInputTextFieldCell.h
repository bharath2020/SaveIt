//
//  DVInputTextFieldCellCell.h
//  SaveIt
//
//  Created by Bharath Booshan on 5/31/12.
//  Copyright (c) 2012 Integral Development Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _InputCellType
{
    eEditableTextField=0,
    eNormalTextField
}EInputCellType;

@class DVInputTextFieldCell;
@protocol DVInputTextFieldCellDelegate <NSObject>

-(void)textFieldCellDidBeginEditing:(DVInputTextFieldCell*)cell;
-(void)textFieldCellTextDidChange:(DVInputTextFieldCell*)cell text:(NSString*)newText;
-(void)textFieldCellDidTapButton:(DVInputTextFieldCell*)cell;

@end

@interface DVInputTextFieldCell : UITableViewCell<UITextFieldDelegate>
{
    IBOutlet UILabel *mTitleLabel;
    IBOutlet UITextField *mValueField;
    IBOutlet UIImageView *mImageView;
    IBOutlet UILabel *mValueFieldLabel;
    __unsafe_unretained id<DVInputTextFieldCellDelegate> _cellDelegate;
    EInputCellType _cellType;
}
@property( nonatomic, strong) UIImageView *mImageView;
@property( nonatomic, strong) UITextField *mValueField;
@property( nonatomic, strong) UILabel     *mTitleLabel;
@property( nonatomic, strong) UILabel     *mValueFieldLabel;
@property( nonatomic, unsafe_unretained) id<DVInputTextFieldCellDelegate> cellDelegate;

- (IBAction)buttonTap:(id)sender;

- (void)setCellType:(EInputCellType)inputCellType;
- (void)setTitle:(NSString*)title;
- (void)setIconImage:(UIImage*)image;

@end
