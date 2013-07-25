//
//  KITLinkedTextField+.h
//  KIT
//
//  Created by Andreas Petrov on 2/15/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @abstract A UITextField that can be linked with a nextView.
 @discussion
 When linked the Return button on the keyboard will become a "Next" button instead unless the next view is a button.
 If nextView is a button that button will be pressed when the user hits return on the keyboard.
 Useful for linking textfields in forms and login views.
 */
@interface KITLinkedTextField : UITextField <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *nextView;

@end
