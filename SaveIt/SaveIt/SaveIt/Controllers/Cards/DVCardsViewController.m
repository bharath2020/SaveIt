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
{
    DVCategory *mCurrentCategory;
    NSUInteger _currentCategoryIndex;
    UISegmentedControl *navigationControl;

}
- (void)loadCategory:(DVCategory*)newCategory;
- (void)updateNavigationControl;
@end


@implementation DVCardsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Cards";
        self.tabBarItem.image = [UIImage imageNamed:@"44-shoebox.png"];
        _currentCategoryIndex= 0;
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
    
   
    mCardsListView.rowHeight = 60.0;
    
    navigationControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[UIImage imageNamed:@"up_arrow.png"], [UIImage imageNamed:@"down_arrow.png"],nil]];
    navigationControl.segmentedControlStyle = UISegmentedControlStyleBar;
    navigationControl.momentary = YES;
    [navigationControl addTarget:self action:@selector(navigateCategories:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *segmentBar = [[UIBarButtonItem alloc] initWithCustomView:navigationControl];
    self.navigationItem.rightBarButtonItem = segmentBar;
    
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewCard:)];
    self.navigationItem.leftBarButtonItem = addButton;
    // Do any additional setup after loading the view from its nib.
    [_categoryManager loadCategories:^(BOOL finished){
        DVCategory *category = [_categoryManager categoryAtIndex:0];
        [self loadCategory:category];
    }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    navigationControl=nil;

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

- (void)loadCategory:(DVCategory*)newCategory
{
    [newCategory loadCards:^(BOOL finished){
        mCurrentCategory=newCategory;
        [mCardsListView reloadData];
        [self updateNavigationControl];
    }];
    [self updateNavigationControl];

}

- (void)updateNavigationControl
{
    [navigationControl setEnabled:(_currentCategoryIndex>0) forSegmentAtIndex:0];
    [navigationControl setEnabled:(_currentCategoryIndex != [_categoryManager totalCategories]-1) forSegmentAtIndex:1];
    DVCategory *category = [_categoryManager categoryAtIndex:_currentCategoryIndex];
    self.title = category.categoryName;
}

#pragma Action
- (void)addNewCard:(id)sender
{
    DVCardCreationController *cardCreation = [[DVCardCreationController alloc] initWithNibName:@"DVCardCreationController" bundle:nil];
    cardCreation.cardCreationType = eCreateNewCardMode;
    cardCreation.hidesBottomBarWhenPushed = YES;
    [cardCreation setCreatorDelegate:self];
    [self.navigationController pushViewController:cardCreation animated:YES];
    
    [cardCreation showCardInfo:[DVCard cardFromCategory:mCurrentCategory] atIndex:[mCurrentCategory.cardManager totalCards]];
}

- (void)navigateCategories:(id)sender
{
    if( 0 == [sender selectedSegmentIndex] )
    {
        _currentCategoryIndex--;

    }
    else {
        _currentCategoryIndex++;

    }
    NSLog(@"prev %d", _currentCategoryIndex);
    DVCategory *nextCategory = [_categoryManager categoryAtIndex:_currentCategoryIndex];
    [self loadCategory:nextCategory];
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
    cardCreation.hidesBottomBarWhenPushed = YES;
    [cardCreation setCreatorDelegate:self];
    [self.navigationController pushViewController:cardCreation animated:YES];
    [cardCreation showCardInfo:card atIndex:indexPath.row];
}

#pragma DVCardCreationController
-(void)cardCreation:(DVCardCreationController*)controller didEditCard:(DVCard*)newCard
{
    if( controller.cardCreationType == eCreateNewCardMode )
    {
        [newCard.category.cardManager addCard:newCard];
        [self.navigationController popToViewController:self animated:YES];
    }
    else {
        
        //suppose if the category is being edited.
        if( [newCard.category isEqualToCategory:mCurrentCategory] )
        {
            [mCurrentCategory.cardManager saveCard:newCard];
        }
        else {
            [newCard.category.cardManager saveCard:newCard];
            [mCurrentCategory.cardManager loadCards:^(BOOL completed){
                [mCardsListView reloadData]; 
            }];
        }
    }
}

-(void)cardCreationDidCancel:(DVCardCreationController *)controller
{
    if( controller.cardCreationType == eCreateNewCardMode )
    {
        [self.navigationController popToViewController:self animated:YES];
    }
}

-(NSUInteger)cardCreateionNumberOfCards:(DVCardCreationController*)controller
{
    return [mCurrentCategory.cardManager totalCards];
}

-(DVCard*)cardCreation:(DVCardCreationController*)controller cardAtIndex:(NSUInteger)index
{
    return [mCurrentCategory.cardManager cardAtIndex:index];
}

@end
