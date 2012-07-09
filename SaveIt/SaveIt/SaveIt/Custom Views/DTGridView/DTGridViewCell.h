//
//  DTGridViewCell.h
//  GridViewTester
//
//  Created by Daniel Tull on 06.04.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTGridViewCellInfoProtocol.h"

@protocol DTGridViewCellDelegate;

typedef enum _GridCellType
{
    eGridCellImageAndTextType,
    eGridCellImageType
}EGridCellType;

/*!
 @class DTGridViewCell
 @abstract 
 @discussion 
*/
@interface DTGridViewCell : UIView <DTGridViewCellInfoProtocol> {

	NSUInteger xPosition, yPosition;
	NSString *identifier;
	
	BOOL selected;
	BOOL highlighted;
	
	id<DTGridViewCellDelegate> delegate;
    
    UIImageView *imageView;
    UIImageView *_selectedStateImageView;
    UILabel *mTitleLabel;
    EGridCellType _gridCellType;
	
}
@property (nonatomic, assign) id delegate;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, assign) BOOL tick;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, assign) EGridCellType gridCellType;

- (id)initWithReuseIdentifier:(NSString *)identifier;
- (void)prepareForReuse;
@end

@protocol DTGridViewCellDelegate

-(void)gridViewCellWasTouched:(DTGridViewCell *)gridViewCell;

@end
