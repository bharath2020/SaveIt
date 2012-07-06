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
        self.tabBarItem.image = [UIImage imageNamed:@"44-shoebox.png"];

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
    mCardsListView.rowHeight = 60.0;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewCard:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.title = @"Cards";

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [mCardsListView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma Action
- (void)addNewCard:(id)sender
{
    DVCardCreationController *cardCreation = [[DVCardCreationController alloc] initWithNibName:@"DVCardCreationController" bundle:nil];
    cardCreation.cardCreationType = eCreateNewCardMode;
    [cardCreation setCreatorDelegate:self];
    [self.navigationController pushViewController:cardCreation animated:YES];
    
    [cardCreation showCardInfo:[DVCard cardFromCategory:mCurrentCategory]];
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
        categoryCell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    [cardCreation setCreatorDelegate:self];
    [self.navigationController pushViewController:cardCreation animated:YES];
    [cardCreation showCardInfo:card];
}

#pragma DVCardCreationController
-(void)cardCreation:(DVCardCreationController*)controller didEditCard:(DVCard*)newCard
{
    if( controller.cardCreationType == eCreateNewCardMode )
    {
        [mCurrentCategory.cardManager addCard:newCard];
        [self.navigationController popToViewController:self animated:YES];
    }
    else {
        [mCurrentCategory.cardManager saveCard:newCard];
    }
}

-(void)cardCreationDidCancel:(DVCardCreationController *)controller
{
    if( controller.cardCreationType == eCreateNewCardMode )
    {
        [self.navigationController popToViewController:self animated:YES];
    }
}

@end
