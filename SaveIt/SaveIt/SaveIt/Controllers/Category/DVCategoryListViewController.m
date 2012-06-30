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
#import "DVCategoryCreationController.h"

#define TOTAL_COLUMNS 4
#define CELL_HEIGHT 80
#define CELL_WIDTH 80

@interface DVCategoryListViewController ()
{
    DVCategoryManager *_sharedCategoryManager;

}
- (void)initialise;
- (void)updateEditToolbar;
- (void)showActionItems;
@end

@implementation DVCategoryListViewController
@synthesize categoryGridView = mCategoryGridView;
@synthesize mEditToolBar;
@synthesize mSelectAllButton;
@synthesize mDeleteButton;


- (void)initialise
{
    self.title = @"Category";
    self.tabBarItem.image = [UIImage imageNamed:@"104-index-cards.png"];

    [[DVCategoryManager sharedInstance] registerForUpdates:@selector(categoryListUpdated:) target:self];
    _sharedCategoryManager = [DVCategoryManager sharedInstance];
    [_sharedCategoryManager registerForSelectionUpdates:@selector(categorySelectionUpdate:) target:self];
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

    
   // mEditButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editCategory:)];
    mEditButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActions:)];
    self.navigationItem.rightBarButtonItem = mEditButton;
    
    mDoneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(editCategory:)];
    
    
    // Do any additional setup after loading the view from its nib.
    self.title = @"Category";
    
    mCategoryGridView = [[DTGridView alloc] initWithFrame:self.view.bounds];
    self.categoryGridView.autoresizingMask = self.view.autoresizingMask;
    mCategoryGridView.delegate = self;
    mCategoryGridView.dataSource = self;
    mCategoryGridView.backgroundColor = [UIColor colorWithRed:1.0 green:254.0/255.0 blue:200.0/255.0 alpha:1.0];
    float cellOffset = (self.view.frame.size.width - (CELL_WIDTH * TOTAL_COLUMNS))/ (TOTAL_COLUMNS+1);
    mCategoryGridView.cellOffset = CGPointMake(cellOffset , cellOffset);
    mCategoryGridView.initialYOffset = 10.0;
    [self.view addSubview:mCategoryGridView];

    [self.view bringSubviewToFront:mEditToolBar];
    [self setEditing:NO animated:NO];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.categoryGridView = nil;
    mEditButton=nil;
    mDoneButton=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [mCategoryGridView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)showActions:(id)sender
{
    [self showActionItems];
}

-(IBAction)editCategory:(id)sender
{
    [self setEditing:!self.editing animated:YES];
}

- (IBAction)deleteCategory:(id)sender
{
    [[DVCategoryManager sharedInstance] removeAllSelectedItems];
}

- (IBAction)selectAll:(id)sender
{
    [[DVCategoryManager sharedInstance] selectAll];
    [mCategoryGridView reloadData];
}

-(IBAction)deletSelected:(id)sender
{
    [[DVCategoryManager sharedInstance] removeAllSelectedItems];
}

#pragma Category List Updated
- (void)categoryListUpdated:(NSNotification*)notif
{
    [mCategoryListView reloadData];
    [mCategoryGridView reloadData];
}

- (void)categorySelectionUpdate:(NSNotification*)notif
{
//    [mCategoryGridView reloadData];
//    NSLog(@"selection");
    [self updateEditToolbar];
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
    

    return MIN(TOTAL_COLUMNS, totalCategories - (index * TOTAL_COLUMNS));
}

- (CGFloat)gridView:(DTGridView *)gridView heightForRow:(NSInteger)rowIndex
{
    return CELL_HEIGHT;
}

- (CGFloat)gridView:(DTGridView *)gridView widthForCellAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex
{
    return CELL_WIDTH;
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

- (void)gridView:(DTGridView *)gridView selectionMadeAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex
{
    NSUInteger index = (rowIndex * TOTAL_COLUMNS) + columnIndex;
    if( self.editing)
    {
        [[DVCategoryManager sharedInstance] toggleSelectionAtIndex:index];
        
        DTGridViewCell *cell =    [gridView cellForRow:rowIndex column:columnIndex];
        cell.tick = [[DVCategoryManager sharedInstance] isItemAtIndexSelected:index];
        [self updateEditToolbar];
    }
    else {
        //show category creation
        DVCategoryCreationController *categoryCreator = [[DVCategoryCreationController alloc] initWithNibName:@"DVCategoryCreationController" bundle:[NSBundle mainBundle]];
        categoryCreator.creatorDelegate = self;
        [self.navigationController pushViewController:categoryCreator animated:YES];
        [categoryCreator showDetailsOfCategory:[_sharedCategoryManager categoryAtIndex:index]];
    }
}

#pragma mark Editing

- (void)showActionItems
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"What do you want to do?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add New Category", @"Edit", nil];
    [actionSheet showInView:self.tabBarController.view];
}

- (void)updateEditToolbar
{
    NSUInteger selectedItemsCount = [[_sharedCategoryManager selectedItems] count];
    mSelectAllButton.enabled = [_sharedCategoryManager totalCategories] != selectedItemsCount;
    mDeleteButton.enabled = selectedItemsCount >0;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if( editing )
    {
        self.navigationItem.rightBarButtonItem = mDoneButton;

        [UIView animateWithDuration:(animated ? 0.25 : 0.0f) animations:^{
            CGRect editToolBar = mEditToolBar.frame;
            editToolBar.origin.y = self.view.bounds.size.height - editToolBar.size.height;
            mEditToolBar.frame =editToolBar;
        }
        completion:^(BOOL finished){
                        }];
    }
    else {
        self.navigationItem.rightBarButtonItem = mEditButton;

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

#pragma CategoryCreationProtocol 
-(void)categoryCreation:(DVCategoryCreationController*)controller didEditCategory:(DVCategory*)newCategory
{
    BOOL pullBack = ![newCategory hasCategoryID];
    [_sharedCategoryManager saveCategory:newCategory];
    if( pullBack )
    {
        [self.navigationController popToViewController:self animated:YES];
    }
}

#pragma UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d",buttonIndex);

    switch (buttonIndex) {
        case 0:
        {
            DVCategoryCreationController *categoryCreator = [[DVCategoryCreationController alloc] initWithNibName:@"DVCategoryCreationController" bundle:[NSBundle mainBundle]];
            categoryCreator.creatorDelegate = self;
            [self.navigationController pushViewController:categoryCreator animated:YES];
            [categoryCreator showDetailsOfCategory:[DVCategory newCategory]];
        }
            break;
        case 1:
        {
            [self editCategory:nil];
        }
            break;
       
        default:
            break;
    }
}




@end
