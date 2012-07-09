//
//  DTGridViewCell.m
//  GridViewTester
//
//  Created by Daniel Tull on 06.04.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTGridViewCell.h"
#import "DTGridView.h"
#import <QuartzCore/QuartzCore.h>

#pragma mark Private Methods
@interface DTGridViewCell ()
- (DTGridView *)gridView;
@end



@implementation DTGridViewCell

@synthesize xPosition, yPosition, identifier, delegate, selected;
@synthesize highlighted, titleLabel = mTitleLabel, imageView;
@synthesize tick = _tick;
@synthesize gridCellType = _gridCellType;

@dynamic frame;

- (id)initWithReuseIdentifier:(NSString *)anIdentifier {
	
	if (![super initWithFrame:CGRectZero])
		return nil;
	

    
	identifier = [anIdentifier copy];
    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    
    mTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    mTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
	[self addSubview:mTitleLabel];
    mTitleLabel.textAlignment = UITextAlignmentCenter;
    mTitleLabel.backgroundColor = [UIColor clearColor];
    mTitleLabel.shadowColor = [UIColor whiteColor];
    mTitleLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    self.gridCellType = eGridCellImageAndTextType;
//    self.layer.borderWidth = 1.0;
//    self.layer.borderColor = [UIColor grayColor].CGColor;
    
    _selectedStateImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_selectedStateImageView];
	return self;
}

- (void)dealloc {
	[identifier release];
    self.imageView= nil;
    
    [super dealloc];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect imageRect , labelRect = CGRectZero;
    if( eGridCellImageAndTextType == _gridCellType  )
    {
        CGRectDivide(self.bounds, &labelRect, &imageRect, 24.0, CGRectMaxYEdge);
    }
    else {
        imageRect =self.bounds;
    }
    imageView.frame = imageRect;
    mTitleLabel.frame = labelRect;
    
    _selectedStateImageView.frame = CGRectMake(self.bounds.size.width-16.0,0.0, 16.0, 16.0);
}

- (void)awakeFromNib {
	identifier = nil;
}

- (void)prepareForReuse {
	self.selected = NO;
	self.highlighted = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	self.highlighted = YES;
	[super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	self.highlighted = NO;
	[super touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	self.highlighted = NO;
	[[self gridView] selectRow:self.yPosition column:self.xPosition scrollPosition:DTGridViewScrollPositionNone animated:YES];
	[self.delegate gridViewCellWasTouched:self];
	[super touchesEnded:touches withEvent:event];
}

-(void)setTick:(BOOL)inTick
{
    _selectedStateImageView.image = inTick ? [UIImage imageNamed:@"good_or_tick.png"] : nil;
}

#pragma mark -
#pragma mark Private Methods

- (DTGridView *)gridView {	
	UIResponder *r = [self nextResponder];
	if (![r isKindOfClass:[DTGridView class]]) return nil;
	return (DTGridView *)r;
}

@end
