//
//  DVCardsViewController.m
//  SaveIt
//
//  Created by Bharath Booshan on 5/29/12.
//  Copyright (c) 2012 Integral Development Corporation. All rights reserved.
//

#import "DVCardsViewController.h"
#import "DVCategoryManager.h"
#import "DVCardManager.h"
#import "DVCard.h"
#import "DVCardCreationController.h"

@interface DVCardsViewController ()

@end


@implementation DVCardsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Cards";
        _categoryManager = [DVCategoryManager sharedInstance];

    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _categoryManager = [DVCategoryManager sharedInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_categoryManager loadCategories:^(BOOL finished){
        DVCategory *category = [_categoryManager categoryAtIndex:0];
        [category loadCards:^(BOOL finished){
            mCurrentCategory=category;
            [mCardsListView reloadData]; 
        }];
    }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.title = @"Cards";

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [mCurrentCategory.cardManager   totalCards];
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
    
    DVCard *card = [mCurrentCategory.cardManager cardAtIndex:indexPath.row];
    categoryCell.textLabel.text = card.title;
    categoryCell.imageView.image = card.icon;
    return categoryCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DVCard *card = [mCurrentCategory.cardManager cardAtIndex:indexPath.row];
    DVCardCreationController *cardCreation = [[DVCardCreationController alloc] initWithNibName:@"DVCardCreationController" bundle:nil];
    [self.navigationController pushViewController:cardCreation animated:YES];
    [cardCreation showCardInfo:card];
}

@end
