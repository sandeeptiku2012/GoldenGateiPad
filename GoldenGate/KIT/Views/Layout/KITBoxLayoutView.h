//
//  KITBoxLayoutView.h
//  KIT
//
//  Created by Andreas Petrov on 2/8/12.
//  Copyright (c) 2012 Reaktor. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 * Subviews of this view will be lain out in either a vertical or horizontal fashion according to
 * the order of the views. 
 * The first subview will act as an anchor from which all other views are arranged.
 */
@interface KITBoxLayoutView : UIView

typedef enum
{
    KITBoxLayoutViewLayoutDirectionVertical,
    KITBoxLayoutViewLayoutDirectionHorizontal
} KITBoxLayoutViewLayoutDirection;

typedef enum
{
    KITBoxLayoutViewPaddingModeAutomatic, // Padding will be automatically calculated based on the initial distance between subviews
    KITBoxLayoutViewPaddingModeManual // Padding will be set to a fixed value defined by the paddingSize property
} KITBoxLayoutViewPaddingMode;

/*!
 * Set to determine layout direction.
 */
@property (assign, nonatomic) KITBoxLayoutViewLayoutDirection layoutDirection;

/*!
 * The number of pixels to set between subsequent UI elements.
 * Will be ignored if paddingMode == KITBoxLayoutViewPaddingModeAutomatic
 */
@property (assign, nonatomic) CGFloat paddingSize;


/*!
 * See inline comments on KITBoxLayoutViewPaddingMode for details on the padding modes.
 */
@property (assign, nonatomic)  KITBoxLayoutViewPaddingMode paddingMode;

@end
