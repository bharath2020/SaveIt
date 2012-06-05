//
//  DVCategoryCreationController.h
//  SaveIt
//
//  Created by Bharath Booshan on 5/31/12.
//  Copyright (c) 2012 Integral Development Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVCategory.h"
#import "DVInputTextFieldCell.h"

@interface DVCategoryCreationController : UIViewController<UITableViewDataSource, UITableViewDelegate, DVInputTextFieldCellDelegate>
{
    IBOutlet UITableView *mCategoryListView;
    IBOutlet UIImageView *mIconImageView;
    IBOutlet UILabel *mCategoryDescriptionField;
    IBOutlet UILabel *mTitleLabel;
    IBOutlet UIView *mEditableHeaderView;
    IBOutlet UIView *mNormalHeaderView;
    UIBarButtonItem *mEditButton;
    UIBarButtonItem *mDoneButton;
    UIBarButtonItem *mCancelButton;
}
@property(nonatomic, strong)UILabel *mCategoryDescriptionField;
@property(nonatomic, strong)UILabel *mTitleLabel;
@property(nonatomic, strong)UIImageView *mIconImageView;
@property(nonatomic, strong)UITableView *mCategoryListView;
@property(nonatomic, strong)UIView *mEditableHeaderView;
@property(nonatomic, strong)UIView *mNormalHeaderView;


-(void)showDetailsOfCategory:(DVCategory*)category;
@end
