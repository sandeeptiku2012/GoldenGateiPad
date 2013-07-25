//
//  GGVolumeSlider.h
//  GoldenGate
//
//  Created by Andreas Petrov on 11/7/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @abstract 
 Because of a vertical offset on the volume slider thumb introduced in iOS 5.1
 We must do an incredible hack to get a centered slider thumb in MPVolumeView
 This class is used in GGVolumeView to do exactly that.
 */
@interface GGVolumeSlider : UISlider

- (CGRect)thumbRectForBounds:(CGRect)bounds
                   trackRect:(CGRect)rect
                       value:(float)value;
@end
