//
//  DVInputTextFieldCell.m
//  SaveIt
//
//  Created by Bharath Booshan on 5/31/12.
//  Copyright (c) 2012 Integral Development Corporation. All rights reserved.
//

#import "DVInputTextFieldCell.h"

@interface DVInputTextFieldCell() 
- (void)initialise;
@end

@implementation DVInputTextFieldCell
@synthesize mImageView;
@synthesize mValueField;
@synthesize mTitleLabel;
@synthesize mValueFieldLabel;
@synthesize cellDelegate=_cellDelegate;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if( self )
    {
        [self initialise];
    }
    return self;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initialise];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
    [mValueField setDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:mValueField];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initialise
{

}


- (void)setCellType:(EInputCellType)inputCellType
{
    _cellType = inputCellType;
    if( inputCellType == eEditableTextField )
    {
        mValueField.hidden = NO;
        mValueFieldLabel.hidden = YES;
    }
    else {
        mValueFieldLabel.hidden = NO;
        mValueField.hidden = YES;
    }
}

- (void)setIconImage:(UIImage*)image
{
    [mImageView setImage:image];
}

- (void)setTitle:(NSString*)title
{
    if( _cellType != eEditableTextField )
    {
        mValueFieldLabel.text = title;
    }
    else {
        mValueField.text = title;
    }
}

- (IBAction)buttonTap:(id)sender
{
    [_cellDelegate textFieldCellDidTapButton:self];   
}


#pragma UITextFieldCell Delegate
- (void)textDidChange:(NSNotification*)notif
{
    [_cellDelegate textFieldCellTextDidChange:self text:mValueField.text];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_cellDelegate textFieldCellDidBeginEditing:self];
}



@end
