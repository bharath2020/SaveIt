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
#import "DVFieldEditorController.h"

@interface DVCardCreationController ()
{
    DVCard *_cardToView;
    DVCard *_editableCard;
    NSIndexPath *_selectedIndexPath;
    NSUInteger _currentCardIndex;
}
@property(nonatomic, strong) DVCard *cardToView;
@property(nonatomic, strong) DVCard *editableCard;

- (void)updateHeaders;
- (void)refreshDisplay;
- (void)extractDataFromUI;
- (void)updateNavigationControls;

@end

@implementation DVCardCreationController
@synthesize cardToView = _cardToView;
@synthesize editableCard = _editableCard;
@synthesize creatorDelegate = _creatorDelegate;
@synthesize cardCreationType;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:[mEditableHeaderView viewWithTag:799]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object:mNotesTextView];
    [self setEditing:self.editing animated:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:[mEditableHeaderView viewWithTag:799]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:mNotesTextView];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self refreshDisplay];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma Data update

- (void)updateNavigationControls
{
    NSUInteger totalCards = [self.creatorDelegate cardCreateionNumberOfCards:self];
    mPrevButton.enabled = _currentCardIndex >0;
    mNextButton.enabled = _currentCardIndex != totalCards-1;
    mCardCountLabel.text = [NSString stringWithFormat:@"%d of %d", _currentCardIndex+1, totalCards];
}

- (void)updateHeaders
{
    DVCard *card = self.editing ? _editableCard : _cardToView;
    UIView *tableHeaderView = mCardInfoView.tableHeaderView;
    UIImageView *imageView = (UIImageView*)[tableHeaderView viewWithTag:899];
    imageView.image = [card icon];
    UILabel *titleLabel = (UILabel*)[tableHeaderView viewWithTag:799];
    titleLabel.text = [card title];
    [mNotesTextView setText:[card note]];
    [mNotesLabelView setText:[card note]];
    
    //adjust the size of the notes tableview
    CGSize textSize = [[card note] sizeWithFont:mNotesLabelView.font constrainedToSize:CGSizeMake(mNotesLabelView.frame.size.width, 100.0f)];
    CGRect textFrame = [mNotesLabelView.superview frame];
    textFrame.size.height = textSize.height+10.0;
    [mNotesLabelView.superview setFrame:textFrame];
}

- (void)refreshDisplay
{
    [self updateHeaders];
    [mCardInfoView reloadData];
    [self updateNavigationControls];
}

#pragma Public Methods
- (void)createCardForCategory:(DVCategory*)parentCategory
{
    
}

- (void)showCardInfo:(DVCard*)card atIndex:(NSUInteger)cardIndex
{
   self.cardToView = card;
    _currentCardIndex = cardIndex;
    if ([card hasCardId] )
    {
        [self refreshDisplay];
    }
    else {
        [self editCard:mEditButton];
    }
}

#pragma Table Editing

- (void)extractDataFromUI
{
    _editableCard.title = [(UILabel*)[mCardInfoView.tableHeaderView viewWithTag:799] text];
    _editableCard.note = mNotesTextView.text;
}

- (void)editCard:(id)sender
{
    if( sender == mDoneButton )
    {
        
       [self extractDataFromUI];
        
        if( [_editableCard.title isEqualToString:@""] )
        {
            UIAlertView *askForTitle = [[UIAlertView alloc] initWithTitle:@"Please enter the Title." message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [askForTitle show];
            return;
        }
        else {
            [_cardToView copyFromCard:_editableCard];
            [self.creatorDelegate cardCreation:self didEditCard:_cardToView];
            [mCardInfoView reloadData];
        }      
    }
    else {
        self.editableCard = [_cardToView copy];    
    }
    [self setEditing:!mCardInfoView.editing animated:YES];
}

- (void)cancelEditing:(id)sender
{
    [self setEditing:NO animated:YES];
    [self.creatorDelegate cardCreationDidCancel:self];
}

- (IBAction)editImage:(id)sender
{
    DVIconPickerController *iconPicker = [[DVIconPickerController alloc] initWithNibName:@"DVIconPickerController" bundle:nil];
    iconPicker.pickerDelegate = self;
    [self.navigationController pushViewController:iconPicker animated:YES];
    [iconPicker showImages];
}

- (IBAction)nextCard:(id)sender
{
    _currentCardIndex++;
    DVCard *nextCard = [self.creatorDelegate cardCreation:self cardAtIndex:_currentCardIndex];
    self.cardToView = nextCard;
    [self refreshDisplay];
}

- (IBAction)prevCard:(id)sender
{
    _currentCardIndex--;
    DVCard *nextCard = [self.creatorDelegate cardCreation:self cardAtIndex:_currentCardIndex];
    self.cardToView = nextCard;
    [self refreshDisplay];
}

#pragma Card Editing
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
   
    
    [mCardInfoView setEditing:editing animated:animated];
    mCardInfoView.tableHeaderView = editing ? mEditableHeaderView : mNormalHeaderView;
    mCardInfoView.tableFooterView = editing ? mEditableFooterView : mNormalFooterView;

    [mCardInfoView reloadData];
    self.navigationItem.rightBarButtonItem = editing ? mDoneButton : mEditButton;
    self.navigationItem.leftBarButtonItem = editing ? mCancelButton : nil;
    [self updateHeaders];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DVCard *card = tableView.editing ? _editableCard : _cardToView;
    NSUInteger totalRows = 0;
    totalRows = [card totalFieldNames]+1;
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
    DVCard *card = tableView.editing ? _editableCard : _cardToView;

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
            cardCell.detailTextLabel.text = [card category].categoryName;
        }
        else {
            cardCell.editingAccessoryType = UITableViewCellAccessoryNone;
            cardCell.textLabel.text = [card fieldNameAtIndex:indexPath.row-1];
            cardCell.detailTextLabel.text = [card fieldValueAtIndex:indexPath.row-1];
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
             }
            cardEditingCell.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            [cardEditingCell setCellDelegate:self];
            [cardEditingCell setFieldTitle:[card fieldNameAtIndex:indexPath.row-1]];
            [cardEditingCell setFieldValue:[card fieldValueAtIndex:indexPath.row-1]];
            [ cardEditingCell setScrambleImage: [card  isFieldScrambledAtIndex:indexPath.row-1] ?  [UIImage imageNamed:@"Lock_icon.png"] : [UIImage imageNamed:@"unlock.png"]];
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( tableView.editing && editingStyle == UITableViewCellEditingStyleInsert )
    {
        [_editableCard addFieldValue:@"Field" fieldName:@"Field Name" isScramble:NO];
        [tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndexPath = indexPath;
    if( indexPath.row ==0 )
    {
        DVCategoryListViewController *categoryListView = [[DVCategoryListViewController alloc] initWithNibName:@"DVCategoryListViewController" bundle:nil];
        categoryListView.categorySelectionDelegate = self;
        [self.navigationController pushViewController:categoryListView animated:YES];
    }
    else {
        DVFieldEditorController *fieldEditor = [[DVFieldEditorController alloc] initWithNibName:@"DVFieldEditorController" bundle:nil];
        fieldEditor.fieldEditorDelegate = self;
        [self.navigationController pushViewController:fieldEditor animated:YES];
        [fieldEditor editWithFieldName:[_editableCard fieldNameAtIndex:indexPath.row-1] fieldValue:[_editableCard fieldValueAtIndex:indexPath.row-1] scramble:[_editableCard isFieldScrambledAtIndex:indexPath.row-1]];
    }
}

#pragma DVCardCellDelegate
-(void)textFieldCellTextDidChange:(DVCardCell*)cell text:(NSString*)newText
{
    NSIndexPath *cellIndex = [mCardInfoView indexPathForCell:cell];
    [_editableCard setFieldValue:newText atIndex:cellIndex.row-1];
}

-(void)textFieldCellDidBeginEditing:(DVCardCell*)cell
{
    CGRect cellRect = [mCardInfoView rectForRowAtIndexPath:[mCardInfoView indexPathForCell:cell]];
    CGRect visibleRect = CGRectMake(0.0, mCardInfoView.contentOffset.y, 320.0, 200.0);
    
    if( !CGRectIntersectsRect(visibleRect, cellRect) )
    {
        //get the difference between visible rect and the cell rect
        float diff =  cellRect.origin.y - (visibleRect.origin.y + visibleRect.size.height - cellRect.size.height);
        CGPoint contentOffset = mCardInfoView.contentOffset;
        contentOffset.y = contentOffset.y + diff;
        [mCardInfoView setContentOffset:contentOffset animated:NO];
    }
}

-(void)textFieldCellDidTapButton:(DVCardCell*)cell
{
    if( mCardInfoView.editing )
    {
        NSIndexPath *cellIndex = [mCardInfoView indexPathForCell:cell];
        BOOL isScrambled = [_editableCard toggleScrambleAtIndex:cellIndex.row-1];
        [cell setScrambleImage:  isScrambled ?  [UIImage imageNamed:@"Lock_icon.png"] : [UIImage imageNamed:@"unlock.png"]];
    }
}

#pragma UITextFieldDidChange
- (void)textDidChange:(id)sender
{
    [_editableCard setTitle:[(UITextField*)[sender object] text]];
}

- (void)textViewDidChange:(id)sender
{
    [_editableCard setNote:[mNotesTextView text]];

}

#pragma KeyboardNotification
- (void)keyboardDidShow:(NSNotification*)notif
{
    CGRect tableFrame = mCardInfoView.frame;
    tableFrame.size.height =200.0;
    mCardInfoView.frame = tableFrame;
}

- (void)keyboardDidHide:(NSNotification*)notif
{
    CGRect tableFrame = mCardInfoView.frame;
    tableFrame.size.height =self.view.bounds.size.height ;//nav bar height
    mCardInfoView.frame = tableFrame;
}

#pragma Icon Pickup
- (void)iconPicker:(DVIconPickerController *)picker didSelectImage:(UIImage *)image withName:(NSString *)imageName
{
    [_editableCard setIconName:imageName];
    [self.navigationController popToViewController:self animated:YES];
}

#pragma DVFieldEditorDelegate
- (void)fieldEditor:(DVFieldEditorController*)controller didEditFieldName:(NSString*)fieldName fieldValue:(NSString *)fieldValue scramble:(BOOL)scramble
{
    [_editableCard setFieldValue:fieldValue atIndex:_selectedIndexPath.row-1];
    [_editableCard setScramble:scramble atIndex:_selectedIndexPath.row -1];
    [_editableCard setFieldName:fieldName atIndex:_selectedIndexPath.row-1];
    [self.navigationController popToViewController:self animated:YES];
}

- (void)fieldEditorDidCancel:(DVFieldEditorController*)controller
{
    [self.navigationController popToViewController:self animated:YES];
}


#pragma DVCardSelectionProtocol
- (BOOL)categoryListView:(DVCategoryListViewController*)categoryListView didSelectCategory:(DVCategory*)category
{
    if( ![_editableCard hasCardId] )
    {
        if( ![_editableCard.category isEqualToCategory:category] )
        {
            DVCard *newCard = [DVCard cardFromCategory:category];
            self.cardToView = newCard;
            self.editableCard = newCard;
        }
        else {
            _editableCard.iconName = category.iconName;

        }
    }
    else {
        _editableCard.category = category;
    }
    [self refreshDisplay];
    [self.navigationController popToViewController:self animated:YES];
    return YES;
}

@end
