//
//  DVCardCellCell.m
//  SaveIt
//
//  Created by Bharath Booshan on 6/21/12.
//  Copyright (c) 2012 Integral Development Corporation. All rights reserved.
//

#import "DVCardCell.h"

@implementation DVCardCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
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

@end
