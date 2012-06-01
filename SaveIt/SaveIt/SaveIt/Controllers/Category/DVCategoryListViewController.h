//
//  DVCategoryListViewController.h
//  SaveIt
//
//  Created by Bharath Booshan on 5/29/12.
//  Copyright (c) 2012 Integral Development Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DTGridView.h"

@interface DVCategoryListViewController : UIViewController<UITableViewDataSource,DTGridViewDataSource, DTGridViewDelegate>
{
    IBOutlet UITableView *mCategoryListView;
    DTGridView *mCategoryGridView;
    IBOutlet UIToolbar *mEditToolBar;
    IBOutlet UIBarItem *mSelectAllButton;
    IBOutlet UIBarItem *mDeleteButton;
    UIBarButtonItem *mEditButton;
    UIBarButtonItem *mDoneButton;
    

    
}
@property(nonatomic, strong) DTGridView *categoryGridView;
@property(nonatomic, strong) UIToolbar *mEditToolBar;
@property(nonatomic, strong) UIBarItem *mSelectAllButton;
@property(nonatomic, strong) UIBarItem *mDeleteButton;

-(IBAction)editCategory:(id)sender;
-(IBAction)selectAll:(id)sender;
-(IBAction)deletSelected:(id)sender;

@end
