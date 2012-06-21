//
//  DVCardCreationControllerViewController.h
//  SaveIt
//
//  Created by Bharath Booshan on 6/19/12.
//  Copyright (c) 2012 Integral Development Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DVCategory;
@class DVCard;

@interface DVCardCreationController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *mCardInfoView;
    IBOutlet UIImageView *mCardIconView;
    IBOutlet UILabel *mCardTitleView;
    IBOutlet UIView *mEditableHeaderView;
    IBOutlet UIView *mNormalHeaderView;
    
    UIBarButtonItem *mEditButton;
    UIBarButtonItem *mDoneButton;
    UIBarButtonItem *mCancelButton;

    
}


- (void)createCardForCategory:(DVCategory*)parentCategory;
- (void)showCardInfo:(DVCard*)card;

@end
