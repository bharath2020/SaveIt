//
//  DVCardCellCell.h
//  SaveIt
//
//  Created by Bharath Booshan on 6/21/12.
//  Copyright (c) 2012 Integral Development Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DVCardCell;

@protocol DVCardFieldCellDelegate <NSObject>

-(void)textFieldCellDidBeginEditing:(DVCardCell*)cell;
-(void)textFieldCellTextDidChange:(DVCardCell*)cell text:(NSString*)newText;
-(void)textFieldCellDidTapButton:(DVCardCell*)cell;

@end

@interface DVCardCell : UITableViewCell<UITextFieldDelegate>
{
    IBOutlet UILabel *mFieldTitleLabel;
    IBOutlet UITextField *mFieldValueField;
    IBOutlet UIImageView *mScrambleStateImageView;
    __unsafe_unretained id<DVCardFieldCellDelegate> _cellDelegate;
}
@property( nonatomic, unsafe_unretained) id<DVCardFieldCellDelegate> cellDelegate;


- (IBAction)buttonTap:(id)sender;

- (void)setFieldTitle:(NSString*)newTitle;
- (void)setFieldValue:(NSString*)newValue;
- (void)setScrambleImage:(UIImage*)image;

@end
