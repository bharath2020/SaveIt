//
//  DVCategoryCreationController.h
//  SaveIt
//
//  Created by Bharath Booshan on 5/31/12.
//  Copyright (c) 2012 Integral Development Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVCategory.h"

@interface DVCategoryCreationController : UIViewController<UITableViewDataSource>
{
    IBOutlet UITableView *mCategoryFieldsView;
    IBOutlet UIImageView *mIconImageView;
    IBOutlet UILabel *mCategoryDescriptionField;
    IBOutlet UILabel *mTitleLabel;
}
@property(nonatomic, strong)UILabel *mCategoryDescriptionField;
@property(nonatomic, strong)UILabel *mTitleLabel;
@property(nonatomic, strong)UIImageView *mIconImageView;
@property(nonatomic, strong)UITableView *mCategoryFieldView;


-(void)showDetailsOfCategory:(DVCategory*)category;
@end
