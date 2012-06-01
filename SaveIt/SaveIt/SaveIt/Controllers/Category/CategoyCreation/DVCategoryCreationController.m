//
//  DVCategoryCreationController.m
//  SaveIt
//
//  Created by Bharath Booshan on 5/31/12.
//  Copyright (c) 2012 Integral Development Corporation. All rights reserved.
//

#import "DVCategoryCreationController.h"
#import "DVInputTextFieldCell.h"

@interface DVCategoryCreationController ()

@end

@implementation DVCategoryCreationController

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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  4;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *categoryCellID = @"category_detail";
    DVInputTextFieldCell *categoryCell = (DVInputTextFieldCell*)[tableView dequeueReusableCellWithIdentifier:categoryCellID];
    if( !categoryCell )
    {
        UINib *categoryCellNib = [UINib nibWithNibName:@"DVInputTextFieldCell" bundle:nil];
        [categoryCellNib instantiateWithOwner:self options:nil];
        
    }
    
//    DVCategory *category = [[DVCategoryManager sharedInstance] categoryAtIndex:indexPath.row];
//    categoryCell.textLabel.text = category.categoryName;
//    categoryCell.imageView.image = [category icon];
    
    return categoryCell;
}


@end
