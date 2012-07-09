//
//  DVCategoryListViewController.h
//  SaveIt
//
//  Created by Bharath Booshan on 5/29/12.
//  Copyright (c) 2012 Integral Development Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DTGridView.h"
#import "DVCategoryCreationController.h"

@class DVCategoryListViewController;

@protocol DVCategorySelectionProtocol <NSObject>

//if the delegate returns true it will handle the selection action, else the default behavior of showing the category details will be executed.
- (BOOL)categoryListView:(DVCategoryListViewController*)categoryListView didSelectCategory:(DVCategory*)category;
@end

@interface DVCategoryListViewController : UIViewController<UITableViewDataSource,DTGridViewDataSource, DTGridViewDelegate, DVCategoryCreationProtocol,UIActionSheetDelegate>
{
    IBOutlet UITableView *mCategoryListView;
    DTGridView *mCategoryGridView;
    IBOutlet UIToolbar *mEditToolBar;
    IBOutlet UIBarItem *mSelectAllButton;
    IBOutlet UIBarItem *mDeleteButton;
    UIBarButtonItem *mEditButton;
    UIBarButtonItem *mDoneButton;
    __unsafe_unretained id <DVCategorySelectionProtocol> _categorySelectionDelegate;
}
@property(nonatomic, strong) DTGridView *categoryGridView;
@property(nonatomic, strong) UIToolbar *mEditToolBar;
@property(nonatomic, strong) UIBarItem *mSelectAllButton;
@property(nonatomic, strong) UIBarItem *mDeleteButton;
@property(nonatomic, unsafe_unretained) id <DVCategorySelectionProtocol> categorySelectionDelegate;

-(IBAction)editCategory:(id)sender;
-(IBAction)selectAll:(id)sender;
-(IBAction)deletSelected:(id)sender;

@end
