//
//  DVInputTextFieldCellCell.h
//  SaveIt
//
//  Created by Bharath Booshan on 5/31/12.
//  Copyright (c) 2012 Integral Development Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DVInputTextFieldCell : UITableViewCell
{
    IBOutlet UILabel *mTitleLabel;
    IBOutlet UITextField *mValueField;
    IBOutlet UIImageView *mImageView;
}
@property( nonatomic, strong) UIImageView *mImageView;
@property( nonatomic, strong) UITextField *mValueField;
@property( nonatomic, strong) UILabel     *mTitleLabel;


@end
