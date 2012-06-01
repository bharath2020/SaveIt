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
}
@property(nonatomic,strong) DVCategory *category;
- (void)updateDisplay;
@end

@implementation DVCategoryCreationController
@synthesize mCategoryDescriptionField;
@synthesize mTitleLabel;
@synthesize mIconImageView;
@synthesize mCategoryListView;
@synthesize category = mCategory;



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
    // Do any additional setup after loading the view from its nib.
    mEditButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editCategory:)];
    self.navigationItem.rightBarButtonItem = mEditButton;
    
    mDoneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(editCategory:)];
    
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)showDetailsOfCategory:(DVCategory*)category
{
    self.category = category;
}

- (void)updateDisplay
{
    
}

- (void)editCategory:(id)sender
{
    [self setEditing:mCategoryListView.isEditing animated:YES];
}

#pragma Table Editing
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [mCategoryListView setEditing:editing animated:animated];
    [mCategoryListView reloadData];
}

#pragma UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [mCategory totalFieldNames] + (tableView.isEditing ? 1 : 0);
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( tableView.editing && indexPath.row == [mCategory totalFieldNames])
    {
        static NSString *addCellID = @"add_cell";
        UITableViewCell *addCell = [tableView dequeueReusableCellWithIdentifier:addCellID];
        if (! addCell )
        {
            addCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addCellID];
        
        }
        addCell.textLabel.text =@"Add New Field";
        return  addCell;
    }
    
    static NSString *categoryCellID = @"category_detail";

    DVInputTextFieldCell *categoryCell = (DVInputTextFieldCell*)[tableView dequeueReusableCellWithIdentifier:categoryCellID];
    if( !categoryCell )
    {
        UINib *categoryCellNib = [UINib nibWithNibName:@"DVInputTextFieldCell" bundle:nil];
        UIViewController *categoryCellController = [[UIViewController alloc] init];
        [categoryCellNib instantiateWithOwner:categoryCellController options:nil];
        categoryCell =(DVInputTextFieldCell*) categoryCellController.view;
    }
    
    categoryCell.mTitleLabel.text = [mCategory fieldNameAtIndex:indexPath.row];
    categoryCell.mValueField.text = [mCategory fieldNameAtIndex:indexPath.row];
    categoryCell.mImageView.image = [mCategory isFieldScrambledAtIndex:indexPath.row] ?  [UIImage imageNamed:@"Lock_icon.png"] : [UIImage imageNamed:@"unlock.png"];
    
    return categoryCell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( tableView.isEditing )
    {
        if( indexPath.row == [mCategory totalFieldNames] )
        {
            return UITableViewCellEditingStyleInsert;
        }
        return  UITableViewCellEditingStyleDelete;
    }
    return  UITableViewCellEditingStyleNone;
}



@end
