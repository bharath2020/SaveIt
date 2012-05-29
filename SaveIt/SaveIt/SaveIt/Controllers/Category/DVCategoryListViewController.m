//
//  DVCategoryListViewController.m
//  SaveIt
//
//  Created by Bharath Booshan on 5/29/12.
//  Copyright (c) 2012 Integral Development Corporation. All rights reserved.
//

#import "DVCategoryListViewController.h"
#import "DVCategoryManager.h"
#import "DVCategory.h"

@interface DVCategoryListViewController ()
- (void)initialise;
@end

@implementation DVCategoryListViewController
@synthesize categoryListView = mCategoryListView;

- (void)initialise
{
    self.title = @"Category";

    [[DVCategoryManager sharedInstance] registerForUpdates:@selector(categoryListUpdated:) target:self];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if( self )
    {
        [self initialise];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initialise];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Category";
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma Category List Updated
- (void)categoryListUpdated:(NSNotification*)notif
{
    [self.categoryListView reloadData];
}

#pragma UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [[DVCategoryManager sharedInstance] totalCategories];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *categoryCellID = @"category";
    UITableViewCell *categoryCell = [tableView dequeueReusableCellWithIdentifier:categoryCellID];
    if( !categoryCell )
    {
        categoryCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:categoryCellID];
    }
    
    DVCategory *category = [[DVCategoryManager sharedInstance] categoryAtIndex:indexPath.row];
    categoryCell.textLabel.text = category.categoryName;
    
    return categoryCell;
}

@end
