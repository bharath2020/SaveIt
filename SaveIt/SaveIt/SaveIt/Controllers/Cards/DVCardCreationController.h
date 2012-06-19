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

@interface DVCardCreationController : UIViewController
{
    IBOutlet UITableView *mCardInfoView;
    IBOutlet UIImageView *mCardIconView;
    IBOutlet UILabel *mCardTitleView;
    
}

- (void)createCardForCategory:(DVCategory*)parentCategory;
- (void)showCardInfo:(DVCard*)card;

@end
