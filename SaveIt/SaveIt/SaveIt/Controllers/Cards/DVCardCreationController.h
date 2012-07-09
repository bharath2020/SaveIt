//
//  DVCardCreationControllerViewController.h
//  SaveIt
//
//  Created by Bharath Booshan on 6/19/12.
//  Copyright (c) 2012 Integral Development Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVCardCell.h"
#import "DVIconPickerController.h"
#import "DVFieldEditorController.h"
#import "DVCategoryListViewController.h"


@class DVCategory;
@class DVCard;
@class DVCardCreationController;

typedef enum _CardCreation
{
    eEditCardMode,
    eCreateNewCardMode
}ECardCreationType;

@protocol DVCardCreationDelegate <NSObject>

-(void)cardCreation:(DVCardCreationController*)controller didEditCard:(DVCard*)newCard;
-(void)cardCreationDidCancel:(DVCardCreationController*)controller;
-(NSUInteger)cardCreateionNumberOfCards:(DVCardCreationController*)controller;
-(DVCard*)cardCreation:(DVCardCreationController*)controller cardAtIndex:(NSUInteger)index;

@end

@interface DVCardCreationController : UIViewController<UITableViewDataSource, UITableViewDelegate,DVCardFieldCellDelegate,DVIconPickerDelegate,DVFieldEditorProtocol,DVCategorySelectionProtocol>
{
    IBOutlet UITableView *mCardInfoView;
    IBOutlet UIImageView *mCardIconView;
    IBOutlet UILabel *mCardTitleView;
    IBOutlet UIView *mEditableHeaderView;
    IBOutlet UIView *mNormalHeaderView;
    IBOutlet UITextView *mNotesTextView;
    IBOutlet UILabel *mNotesLabelView;
    IBOutlet UIView *mEditableFooterView;
    IBOutlet UIView *mNormalFooterView;
    
    //navigation controls
    IBOutlet UIBarButtonItem *mPrevButton;
    IBOutlet UIBarButtonItem *mNextButton;
    IBOutlet UILabel *mCardCountLabel;
    
    UIBarButtonItem *mEditButton;
    UIBarButtonItem *mDoneButton;
    UIBarButtonItem *mCancelButton;
    __unsafe_unretained id<DVCardCreationDelegate> _creatorDelegate;
    ECardCreationType _cardCreationType;
    
}
@property(nonatomic, unsafe_unretained)id<DVCardCreationDelegate> creatorDelegate;
@property(nonatomic, assign) ECardCreationType cardCreationType;

- (IBAction)editImage:(id)sender;
- (void)createCardForCategory:(DVCategory*)parentCategory;
- (void)showCardInfo:(DVCard*)card atIndex:(NSUInteger)cardIndex;

@end
