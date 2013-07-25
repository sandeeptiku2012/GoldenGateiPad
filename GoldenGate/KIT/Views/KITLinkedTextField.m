//
//  KITLinkedTextField+.m
//  KIT
//
//  Created by Andreas Petrov on 2/15/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//

#import "KITLinkedTextField.h"

// Created to avoid the infinite recursion that happens when a UITextField has itself as delegate.
@interface KITLinkedTextFieldDelegateHelper : NSObject <UITextFieldDelegate>

@end

@interface KITLinkedTextField ()

@property (strong, nonatomic) KITLinkedTextFieldDelegateHelper *delegateHelper;

@end

@implementation KITLinkedTextFieldDelegateHelper

- (BOOL) textFieldShouldReturn:(UITextField *) textField
{
    
    BOOL didResign = [textField resignFirstResponder];
    if (!didResign) return NO;
    
    UIView *next =[(KITLinkedTextField *)textField nextView];
    
    if ([next isKindOfClass:[UIButton class]])
    {
        dispatch_async(dispatch_get_current_queue(), ^
        {
            UIButton *button = (UIButton*)next;
            [button sendActionsForControlEvents: UIControlEventTouchUpInside];
        });
    }
    else
    {
        dispatch_async(dispatch_get_current_queue(),
                       ^ {[next becomeFirstResponder]; });
    }
    
    
    return YES;
}

@end

@implementation KITLinkedTextField

@synthesize nextView;

- (void)commonInit
{
    self.delegateHelper = [KITLinkedTextFieldDelegateHelper new];
    self.delegate = self.delegateHelper;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self commonInit];
    }
    
    return self;
}

- (BOOL)becomeFirstResponder
{
    if ([self.nextView isKindOfClass:[KITLinkedTextField class]])
    {
        self.returnKeyType = UIReturnKeyNext;
    }
    else if ([self.nextView isKindOfClass:[UIButton class]])
    {
        self.returnKeyType = UIReturnKeyDone;
    }
    
    return [super becomeFirstResponder];
}



@end
