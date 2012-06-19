//
//  DVCardsViewController.h
//  SaveIt
//
//  Created by Bharath Booshan on 5/29/12.
//  Copyright (c) 2012 Integral Development Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVCategory.h"

@class DVCategoryManager;
@interface DVCardsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *mCardsListView;
    
    DVCategoryManager *_categoryManager;
    DVCategory *mCurrentCategory;
    
    
}


@end
