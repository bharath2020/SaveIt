//
//  DVCardCreationControllerViewController.m
//  SaveIt
//
//  Created by Bharath Booshan on 6/19/12.
//  Copyright (c) 2012 Integral Development Corporation. All rights reserved.
//

#import "DVCardCreationController.h"
#import "DVCard.h"
#import "DVCategory.h"

@interface DVCardCreationController ()
{
    DVCard *_cardToView;
}
@property(nonatomic, strong) DVCard *cardToView;

- (void)updateHeaders;
- (void)refreshDisplay;
@end

@implementation DVCardCreationController
@synthesize cardToView = _cardToView;

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
    self.title = @"Card Info";
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [mCardInfoView reloadData];
}

#pragma Data update
- (void)updateHeaders
{
    NSLog(@"refre %@", [_cardToView title]);
    mCardTitleView.text = [_cardToView title];
    mCardIconView.image = [_cardToView icon];
}

- (void)refreshDisplay
{
    [self updateHeaders];
    [mCardInfoView reloadData];
}

#pragma Public Methods
- (void)createCardForCategory:(DVCategory*)parentCategory
{
    
}

- (void)showCardInfo:(DVCard*)card
{
   self.cardToView = card;
    [self refreshDisplay];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [_cardToView totalFieldNames]+1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cardCellID = @"category";
    UITableViewCell *cardCell = [tableView dequeueReusableCellWithIdentifier:cardCellID];
    if( !cardCell )
    {
        cardCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cardCellID];
        cardCell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        cardCell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
        cardCell.detailTextLabel.textColor = [UIColor blackColor];
    }
    
    if( indexPath.row == 0 )
    {
        cardCell.textLabel.text = @"Category";
        cardCell.detailTextLabel.text = [_cardToView category].categoryName;
    }
    else {
        cardCell.textLabel.text = [_cardToView fieldNameAtIndex:indexPath.row];
        cardCell.detailTextLabel.text = [_cardToView fieldValueAtIndex:indexPath.row];
    }
       
    return cardCell;
}


@end
