//
//  DVCardCreationControllerViewController.h
//  SaveIt
//
//  Created by Bharath Booshan on 6/19/12.
//  Copyright (c) 2012 Integral Development Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVCardCell.h"
@class DVCategory;
@class DVCard;
@class DVCardCreationController;

@protocol DVCardCreationDelegate <NSObject>

-(void)cardCreation:(DVCardCreationController*)controller didEditCard:(DVCard*)newCard;

@end

@interface DVCardCreationController : UIViewController<UITableViewDataSource, UITableViewDelegate,DVCardFieldCellDelegate>
{
    IBOutlet UITableView *mCardInfoView;
    IBOutlet UIImageView *mCardIconView;
    IBOutlet UILabel *mCardTitleView;
    IBOutlet UIView *mEditableHeaderView;
    IBOutlet UIView *mNormalHeaderView;
    
    UIBarButtonItem *mEditButton;
    UIBarButtonItem *mDoneButton;
    UIBarButtonItem *mCancelButton;
    __unsafe_unretained id<DVCardCreationDelegate> _creatorDelegate;
    
}
@property(nonatomic, unsafe_unretained)id<DVCardCreationDelegate> creatorDelegate;


- (void)createCardForCategory:(DVCategory*)parentCategory;
- (void)showCardInfo:(DVCard*)card;

@end
