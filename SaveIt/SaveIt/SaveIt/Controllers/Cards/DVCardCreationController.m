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
#import "DVCardCell.h"

@interface DVCardCreationController ()
{
    DVCard *_cardToView;
    DVCard *_editableCard;
}
@property(nonatomic, strong) DVCard *cardToView;
@property(nonatomic, strong) DVCard *editableCard;

- (void)updateHeaders;
- (void)refreshDisplay;
@end

@implementation DVCardCreationController
@synthesize cardToView = _cardToView;
@synthesize editableCard = _editableCard;

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
    
    mCardInfoView.backgroundColor = [UIColor colorWithRed:1.0 green:254.0/255.0 blue:200.0/255.0 alpha:1.0];
    mEditableHeaderView.backgroundColor = [UIColor colorWithRed:1.0 green:254.0/255.0 blue:200.0/255.0 alpha:1.0];
    mNormalHeaderView.backgroundColor = [UIColor colorWithRed:1.0 green:254.0/255.0 blue:200.0/255.0 alpha:1.0];
    
    mCardInfoView.delegate =self;
    // Do any additional setup after loading the view from its nib.
    mEditButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editCard:)];
    self.navigationItem.rightBarButtonItem = mEditButton;
    
    mDoneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(editCard:)];
    mCancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelEditing:)];
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
    UIView *tableHeaderView = mCardInfoView.tableHeaderView;
    UIImageView *imageView = (UIImageView*)[tableHeaderView viewWithTag:899];
    imageView.image = [_cardToView icon];
    UILabel *titleLabel = (UILabel*)[tableHeaderView viewWithTag:799];
    titleLabel.text = [_cardToView title];
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

#pragma Table Editing

- (void)editCard:(id)sender
{
    [self setEditing:!mCardInfoView.editing animated:YES];
}

- (void)cancelEditing:(id)sender
{
    [self setEditing:NO animated:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
//    if( editing )
//    {
//        self.editableCategory = [mCategory copy];    
//    }
    
    [mCardInfoView setEditing:editing animated:animated];
    mCardInfoView.tableHeaderView = editing ? mEditableHeaderView : mNormalHeaderView;
    [mCardInfoView reloadData];
    self.navigationItem.rightBarButtonItem = editing ? mDoneButton : mEditButton;
    self.navigationItem.leftBarButtonItem = editing ? mCancelButton : nil;
    [self updateHeaders];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger totalRows = 0;
    totalRows = [_cardToView totalFieldNames]+1;
    if( tableView.editing )
    {
        totalRows++;    
    }
    return  totalRows;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cardCell = nil;
    if( indexPath.row == 0 ||  !tableView.editing )
    {
        static NSString *cardCellID = @"category";

        cardCell = [tableView dequeueReusableCellWithIdentifier:cardCellID];
        if( !cardCell )
        {
            cardCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cardCellID];
            cardCell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
            cardCell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
            cardCell.detailTextLabel.textColor = [UIColor blackColor];
        }
        if( indexPath.row == 0 )
        {
            cardCell.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            cardCell.textLabel.text = @"Category";
            cardCell.detailTextLabel.text = [_cardToView category].categoryName;
        }
        else {
            cardCell.editingAccessoryType = UITableViewCellAccessoryNone;
            cardCell.textLabel.text = [_cardToView fieldNameAtIndex:indexPath.row-1];
            cardCell.detailTextLabel.text = [_cardToView fieldValueAtIndex:indexPath.row-1];
        }
    }
    else {
        
        if( indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section]-1 )
        {
            static NSString *addCellID = @"add_cell";
            cardCell  = [tableView dequeueReusableCellWithIdentifier:addCellID];
            if( !cardCell )
            {
                cardCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:addCellID];
                cardCell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
                cardCell.textLabel.text =@"Add New Field";
            }
        }
        else {
            static NSString *editingCellID = @"edit_card_cell";
            DVCardCell *cardEditingCell = [tableView dequeueReusableCellWithIdentifier:editingCellID];
            if( !cardEditingCell )
            {
                UINib *cardCellNib = [UINib nibWithNibName:@"DVCardCell" bundle:nil];
                UIViewController *cardCellController = [[UIViewController alloc] init];
                [cardCellNib instantiateWithOwner:cardCellController options:nil];
                cardEditingCell =(DVCardCell*) cardCellController.view;
                // cardCell.cellDelegate= self;
            }
            [cardEditingCell setFieldTitle:[_cardToView fieldNameAtIndex:indexPath.row-1]];
            [cardEditingCell setFieldValue:[_cardToView fieldValueAtIndex:indexPath.row-1]];
            [ cardEditingCell setScrambleImage: [_cardToView  isFieldScrambledAtIndex:indexPath.row] ?  [UIImage imageNamed:@"Lock_icon.png"] : [UIImage imageNamed:@"unlock.png"]];
            cardCell = cardEditingCell;
        }
    }
   
    
          
    return cardCell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellEditingStyle cellEditing = UITableViewCellEditingStyleNone;
    if( tableView.editing )
    {
       if( indexPath.row != 0)
       {
           if( indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section]-1 )
           {
               cellEditing = UITableViewCellEditingStyleInsert;
           }
           else {
               cellEditing = UITableViewCellEditingStyleDelete;
           }
       }
    }
    return  cellEditing;
}


@end
