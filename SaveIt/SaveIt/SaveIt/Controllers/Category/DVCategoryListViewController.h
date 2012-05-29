//
//  DVCategoryListViewController.h
//  SaveIt
//
//  Created by Bharath Booshan on 5/29/12.
//  Copyright (c) 2012 Integral Development Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DVCategoryListViewController : UIViewController<UITableViewDataSource>
{
    IBOutlet UITableView *mCategoryListView;
}
@property(nonatomic, strong)  UITableView *categoryListView;


@end
