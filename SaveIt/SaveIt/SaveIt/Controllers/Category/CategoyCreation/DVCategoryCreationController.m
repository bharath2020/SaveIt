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
@synthesize category = mCategory;
@synthesize mCategoryDescriptionField;
@synthesize mTitleLabel;
@synthesize mIconImageView;
@synthesize mCategoryFieldView;


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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.mCategoryFieldView = nil;
    self.mCategoryDescriptionField=nil;
    self.mTitleLabel = nil;
    self.mIconImageView = nil;
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




@end
