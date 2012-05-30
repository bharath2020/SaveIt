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
#import "DTGridViewCell.h"

#define TOTAL_COLUMNS 4

@interface DVCategoryListViewController ()
- (void)initialise;
- (void)updateEditToolbar;
@end

@implementation DVCategoryListViewController
@synthesize categoryListView = mCategoryListView;
@synthesize categoryGridView = mCategoryGridView;
@synthesize mEditToolBar;
@synthesize mSelectAllButton;
@synthesize mDeleteButton;


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
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editCategory:)];
    self.navigationItem.rightBarButtonItem = editButton;
    

    
    // Do any additional setup after loading the view from its nib.
    self.title = @"Category";
    
    mCategoryGridView = [[DTGridView alloc] initWithFrame:self.view.bounds];
    self.categoryGridView.autoresizingMask = self.view.autoresizingMask;
    [self.view addSubview:mCategoryGridView];
    mCategoryGridView.delegate = self;
    mCategoryGridView.dataSource = self;
    mCategoryGridView.backgroundColor = [UIColor whiteColor];
    
    [self.view bringSubviewToFront:mEditToolBar];
    [self setEditing:NO animated:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.categoryGridView = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)editCategory:(id)sender
{
    [self setEditing:!self.editing animated:YES];
}

- (IBAction)deleteCategory:(id)sender
{
    [[DVCategoryManager sharedInstance] removeAllSelectedItems];
}

#pragma Category List Updated
- (void)categoryListUpdated:(NSNotification*)notif
{
    [self.categoryListView reloadData];
    [mCategoryGridView reloadData];
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
    categoryCell.imageView.image = [category icon];
    
    return categoryCell;
}

#pragma DTGridView Protocol
- (NSInteger)numberOfRowsInGridView:(DTGridView *)gridView
{
    NSUInteger totalCategories =  ([[DVCategoryManager sharedInstance] totalCategories] );
    return totalCategories > 0 ? (totalCategories / TOTAL_COLUMNS) + 1 : 0;
}
/*!
 @abstract Asks the data source to return the number of columns for the given row in the grid view.
 @para The grid view object requesting this information.
 @para The index of the given row.
 @return The number of colums in the row of the grid view.
 */
- (NSInteger)numberOfColumnsInGridView:(DTGridView *)gridView forRowWithIndex:(NSInteger)index
{
    NSUInteger totalCategories =  ([[DVCategoryManager sharedInstance] totalCategories] );

    return MIN(TOTAL_COLUMNS, totalCategories);
}

- (CGFloat)gridView:(DTGridView *)gridView heightForRow:(NSInteger)rowIndex
{
    return 80.0;
}

- (CGFloat)gridView:(DTGridView *)gridView widthForCellAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex
{
    return 80.0;
}

- (DTGridViewCell *)gridView:(DTGridView *)gridView viewForRow:(NSInteger)rowIndex column:(NSInteger)columnIndex
{
    DTGridViewCell *cell = [gridView dequeueReusableCellWithIdentifier:@"cell"];
    
	if (!cell) {
		cell = [[DTGridViewCell alloc] initWithReuseIdentifier:@"cell"];
	}
    
    NSUInteger index = (rowIndex * TOTAL_COLUMNS) + columnIndex;
    
    DVCategory *category = [[DVCategoryManager sharedInstance] categoryAtIndex:index];
    cell.titleLabel.text = category.categoryName;
    cell.imageView.image = [category icon];
    cell.tick = [[DVCategoryManager sharedInstance] isItemAtIndexSelected:index];
    

	return cell;
}

#pragma mark Editing

- (void)updateEditToolbar
{
    
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if( editing )
    {
        [UIView animateWithDuration:(animated ? 0.25 : 0.0f) animations:^{
            CGRect editToolBar = mEditToolBar.frame;
            editToolBar.origin.y = self.view.bounds.size.height - editToolBar.size.height;
            mEditToolBar.frame =editToolBar;
        }
        completion:^(BOOL finished){
                        }];
    }
    else {
        [UIView animateWithDuration:(animated ? 0.25 : 0.0f) animations:^{
            CGRect editToolBar = mEditToolBar.frame;
            editToolBar.origin.y = self.view.bounds.size.height;
            mEditToolBar.frame =editToolBar;
        }
         completion:^(BOOL finished){
         }];
    }
    [self updateEditToolbar];
}

- (void)gridView:(DTGridView *)gridView selectionMadeAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex
{
    NSUInteger index = (rowIndex * TOTAL_COLUMNS) + columnIndex;
    [[DVCategoryManager sharedInstance] toggleSelectionAtIndex:index];

    DTGridViewCell *cell =    [gridView cellForRow:rowIndex column:columnIndex];
    cell.tick = [[DVCategoryManager sharedInstance] isItemAtIndexSelected:index];
}


@end
