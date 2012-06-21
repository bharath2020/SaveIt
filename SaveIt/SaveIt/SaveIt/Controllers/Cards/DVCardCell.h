//
//  DVCardCellCell.h
//  SaveIt
//
//  Created by Bharath Booshan on 6/21/12.
//  Copyright (c) 2012 Integral Development Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DVCardCell : UITableViewCell
{
    IBOutlet UILabel *mFieldTitleLabel;
    IBOutlet UITextField *mFieldValueField;
    IBOutlet UIImageView *mScrambleStateImageView;
}
- (IBAction)buttonTap:(id)sender;


- (void)setFieldTitle:(NSString*)newTitle;
- (void)setFieldValue:(NSString*)newValue;
- (void)setScrambleImage:(UIImage*)image;

@end
