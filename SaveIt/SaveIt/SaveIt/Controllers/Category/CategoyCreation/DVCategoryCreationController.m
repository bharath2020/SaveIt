//
//  DVCategoryCreationController.m
//  SaveIt
//
//  Created by Bharath Booshan on 5/31/12.
//  Copyright (c) 2012 Integral Development Corporation. All rights reserved.
//

#import "DVCategoryCreationController.h"
#import "DVInputTextFieldCell.h"
#import "DVCategory.h"

@interface DVCategoryCreationController ()
{
    DVCategory *mCategory;
    DVCategory *mEditableCategory;
}
@property(nonatomic,strong) DVCategory *category;
@property(nonatomic, strong)DVCategory *editableCategory;
- (void)updateDisplay;
- (void)extractDataFromUI;
@end

@implementation DVCategoryCreationController
@synthesize mCategoryDescriptionField;
@synthesize mTitleLabel;
@synthesize mIconImageView;
@synthesize mCategoryListView;
@synthesize category = mCategory;
@synthesize editableCategory = mEditableCategory;
@synthesize mEditableHeaderView;
@synthesize mNormalHeaderView;
@synthesize creatorDelegate = _creatorDelegate;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mCategoryListView.backgroundColor = [UIColor colorWithRed:1.0 green:254.0/255.0 blue:200.0/255.0 alpha:1.0];
    mEditableHeaderView.backgroundColor = [UIColor colorWithRed:1.0 green:254.0/255.0 blue:200.0/255.0 alpha:1.0];
    mNormalHeaderView.backgroundColor = [UIColor colorWithRed:1.0 green:254.0/255.0 blue:200.0/255.0 alpha:1.0];
    
    mCategoryListView.delegate =self;
    // Do any additional setup after loading the view from its nib.
    mEditButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editCategory:)];
    self.navigationItem.rightBarButtonItem = mEditButton;
    
    mDoneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(editCategory:)];
    mCancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelEditing:)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    //self.mTableView = nil;
   // self.mCategoryDescriptionField=nil;
   // self.mTitleLabel = nil;
   // self.mIconImageView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    [self updateDisplay];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)showDetailsOfCategory:(DVCategory*)category
{
    self.category = category;
    if( ![category hasCategoryID] )
    {
        [self editCategory:mEditButton];
    }
}

- (void)updateDisplay
{
    //set the image
//    mIconImageView.image = [mCategory icon];
//    mTitleLabel.text = mCategory.categoryName;
    UIView *tableHeaderView = mCategoryListView.tableHeaderView;
    UIImageView *imageView = (UIImageView*)[tableHeaderView viewWithTag:899];
    imageView.image = [mCategory icon];
    UILabel *titleLabel = (UILabel*)[tableHeaderView viewWithTag:799];
    titleLabel.text = mCategory.categoryName;
}

- (void)extractDataFromUI
{
    mEditableCategory.categoryName = [(UILabel*)[mCategoryListView.tableHeaderView viewWithTag:799] text];
}

- (void)editCategory:(id)sender
{
    
    if( sender == mDoneButton )
    {
        [self extractDataFromUI];
        [self.category copyFromCategory:mEditableCategory];
        [self.creatorDelegate categoryCreation:self didEditCategory:self.category];
        [mCategoryListView reloadData];
    }
    [self setEditing:!mCategoryListView.isEditing animated:YES];

}

- (void)cancelEditing:(id)sender
{
    [self setEditing:NO animated:YES];
    [mCategoryListView reloadData];
}

#pragma Table Editing
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    
    if( editing )
    {
        self.editableCategory = [mCategory copy];    
    }
   
    
    [mCategoryListView setEditing:editing animated:animated];
    mCategoryListView.tableHeaderView = editing ? mEditableHeaderView : mNormalHeaderView;
    [mCategoryListView reloadData];
    self.navigationItem.rightBarButtonItem = editing ? mDoneButton : mEditButton;
    self.navigationItem.leftBarButtonItem = editing ? mCancelButton : nil;
    [self updateDisplay];
}

#pragma UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DVCategory *category = tableView.editing ? mEditableCategory : mCategory;
    return  [category totalFieldNames] + (tableView.isEditing ? 1 : 0);
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DVCategory *category = mCategory;
    NSLog(@"%@", [mCategory fieldValueAtIndex:1]);
    if( tableView.editing )
    {
        category = mEditableCategory;
    }
    if( tableView.editing && indexPath.row == [category totalFieldNames])
    {
        static NSString *addCellID = @"add_cell";
        UITableViewCell *addCell = [tableView dequeueReusableCellWithIdentifier:addCellID];
        if (! addCell )
        {
            addCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addCellID];
            
        }
        addCell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
        addCell.textLabel.text =@"Add New Field";
        return  addCell;
    }
    
     NSString *categoryCellID = @"category_detail";

    if( tableView.editing )
    {
        categoryCellID = @"category_detail_editing";
    }
       

    DVInputTextFieldCell *categoryCell = (DVInputTextFieldCell*)[tableView dequeueReusableCellWithIdentifier:categoryCellID];
    if( !categoryCell )
    {
        UINib *categoryCellNib = [UINib nibWithNibName:@"DVInputTextFieldCell" bundle:nil];
        UIViewController *categoryCellController = [[UIViewController alloc] init];
        [categoryCellNib instantiateWithOwner:categoryCellController options:nil];
        categoryCell =(DVInputTextFieldCell*) categoryCellController.view;
        categoryCell.cellDelegate= self;
    }
    
    if(tableView.editing)
    {
        [categoryCell setCellType:eEditableTextField];
    }
    else {
        [categoryCell setCellType:eNormalTextField];
    }
    
    categoryCell.mTitleLabel.text = [category fieldNameAtIndex:indexPath.row];
    [categoryCell setTitle: [category fieldValueAtIndex:indexPath.row]];
    categoryCell.mImageView.image = [category isFieldScrambledAtIndex:indexPath.row] ?  [UIImage imageNamed:@"Lock_icon.png"] : [UIImage imageNamed:@"unlock.png"];
    
    return categoryCell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( tableView.isEditing )
    {
        if( indexPath.row == [mEditableCategory totalFieldNames] )
        {
            return UITableViewCellEditingStyleInsert;
        }
        return  UITableViewCellEditingStyleDelete;
    }
    return  UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( tableView.editing && editingStyle == UITableViewCellEditingStyleInsert )
    {
        [mEditableCategory addFieldValue:@"Field_test"];
        [tableView reloadData];
    }
}

#pragma DVInputTextFieldCellDelegate
-(void)textFieldCellTextDidChange:(DVInputTextFieldCell*)cell text:(NSString*)newText
{
    NSIndexPath *cellIndex = [mCategoryListView indexPathForCell:cell];
    [mEditableCategory setFieldValue:newText atIndex:cellIndex.row];
}

-(void)textFieldCellDidBeginEditing:(DVInputTextFieldCell*)cell
{
    CGRect cellRect = [mCategoryListView rectForRowAtIndexPath:[mCategoryListView indexPathForCell:cell]];
    CGRect visibleRect = CGRectMake(0.0, mCategoryListView.contentOffset.y, 320.0, 200.0);
    
    if( !CGRectIntersectsRect(visibleRect, cellRect) )
    {
        //get the difference between visible rect and the cell rect
        float diff =  cellRect.origin.y - (visibleRect.origin.y + visibleRect.size.height - cellRect.size.height);
        CGPoint contentOffset = mCategoryListView.contentOffset;
        contentOffset.y = contentOffset.y + diff;
        [mCategoryListView setContentOffset:contentOffset animated:NO];
    }
}

-(void)textFieldCellDidTapButton:(DVInputTextFieldCell*)cell
{
    if( mCategoryListView.editing )
    {
        NSIndexPath *cellIndex = [mCategoryListView indexPathForCell:cell];
        BOOL isScrambled = [mEditableCategory toggleScrambleAtIndex:cellIndex.row];
        cell.mImageView.image = isScrambled ?  [UIImage imageNamed:@"Lock_icon.png"] : [UIImage imageNamed:@"unlock.png"];

    }
}

#pragma KeyboardNotification
- (void)keyboardDidShow:(NSNotification*)notif
{
    CGRect tableFrame = mCategoryListView.frame;
    tableFrame.size.height =200.0;
    mCategoryListView.frame = tableFrame;
}

- (void)keyboardDidHide:(NSNotification*)notif
{
    CGRect tableFrame = mCategoryListView.frame;
    tableFrame.size.height =self.view.bounds.size.height ;//nav bar height
    mCategoryListView.frame = tableFrame;
}


@end
