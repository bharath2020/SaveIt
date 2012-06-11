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
//    self.layer.borderWidth = 1.0;
//    self.layer.borderColor = [UIColor grayColor].CGColor;
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
    CGRect imageRect , labelRect;
     CGRectDivide(self.bounds, &labelRect, &imageRect, 24.0, CGRectMaxYEdge);
    imageView.frame = imageRect;
    mTitleLabel.frame = labelRect;
    
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
    self.backgroundColor = (inTick ? [UIColor greenColor] : [ UIColor clearColor]);
}

#pragma mark -
#pragma mark Private Methods

- (DTGridView *)gridView {	
	UIResponder *r = [self nextResponder];
	if (![r isKindOfClass:[DTGridView class]]) return nil;
	return (DTGridView *)r;
}

@end
