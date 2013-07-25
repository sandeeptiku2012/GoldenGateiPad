//
//  GGBarButtonItem.m
//  GoldenGate
//
//  Created by Andreas Petrov on 9/21/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "GGBarButtonItem.h"
#import "GGBarButton.h"

#define kMinimumButtonWidth 80

@interface GGBarButtonItem()

@property (strong, nonatomic) UIButton *button;

@end

@implementation GGBarButtonItem

- (id)initWithTitle:(NSString *)title image:(UIImage*)image target:(id)target action:(SEL)action
{
    GGBarButton *innerButton = [[GGBarButton alloc] initWithFrame:CGRectNull];
    [innerButton setTitle:title forState:UIControlStateNormal];
    [innerButton setAccessibilityLabel:@"Close"];
    [innerButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [innerButton setImage:image forState:UIControlStateNormal];
    
    if ((self = [super initWithCustomView:innerButton]))
    {
        [innerButton.titleLabel sizeToFit];
        CGSize buttonSize = [title sizeWithFont:innerButton.titleLabel.font];
        buttonSize.width += [GGBarButton buttonMargins] * 2; // Add a margin on both sides of the text

        if (innerButton.imageView)
        {
            buttonSize.width += ([GGBarButton imagePadding] * 2) + innerButton.imageView.bounds.size.width; // Account for there being an image in the button.
            buttonSize.width += [GGBarButton buttonMargins]; // Add some extra space
        }
        
        // Ensure button is wider or equal to kMinimumButtonWidth
        buttonSize.width = MAX(kMinimumButtonWidth, buttonSize.width);
        
        innerButton.frame = CGRectMake(0, 0, buttonSize.width, [innerButton backgroundImageForState:UIControlStateNormal].size.height);
    }

    return self;
}

-(void)setNewTitle:(NSString*)strTitle
{
    GGBarButton* innerButton = (GGBarButton*)self.customView;
    NSAssert([innerButton isKindOfClass:[GGBarButton class]], @"Custom view should be a GGBarButton");
    [innerButton setTitle:strTitle forState:UIControlStateNormal];
    
    [innerButton.titleLabel sizeToFit];
    CGSize buttonSize = [strTitle sizeWithFont:innerButton.titleLabel.font];
    buttonSize.width += [GGBarButton buttonMargins] * 2; // Add a margin on both sides of the text
    
    if (innerButton.imageView)
    {
        buttonSize.width += ([GGBarButton imagePadding] * 2) + innerButton.imageView.bounds.size.width; // Account for there being an image in the button.
        buttonSize.width += [GGBarButton buttonMargins]; // Add some extra space
    }
    
    // Ensure button is wider or equal to kMinimumButtonWidth
    buttonSize.width = MAX(kMinimumButtonWidth, buttonSize.width);
    
    CGRect frameButton = innerButton.frame;
    frameButton.size = CGSizeMake(buttonSize.width, [innerButton backgroundImageForState:UIControlStateNormal].size.height);
    
    innerButton.frame = frameButton;

    
}





@end



