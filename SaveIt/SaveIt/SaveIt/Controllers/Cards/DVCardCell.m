//
//  DVCardCellCell.m
//  SaveIt
//
//  Created by Bharath Booshan on 6/21/12.
//  Copyright (c) 2012 Integral Development Corporation. All rights reserved.
//

#import "DVCardCell.h"

@implementation DVCardCell
@synthesize cellDelegate=_cellDelegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [mFieldValueField setDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:mFieldValueField];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFieldTitle:(NSString*)newTitle
{
    [mFieldTitleLabel setText:newTitle];
}

- (void)setFieldValue:(NSString*)newValue
{
    [mFieldValueField setText:newValue];
}

- (void)setScrambleImage:(UIImage*)image
{
    [mScrambleStateImageView setImage:image];
}

- (IBAction)buttonTap:(id)sender
{
    
}

#pragma UITextFieldCell Delegate
- (void)textDidChange:(NSNotification*)notif
{
    [_cellDelegate textFieldCellTextDidChange:self text:mFieldValueField.text];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_cellDelegate textFieldCellDidBeginEditing:self];
}


@end
