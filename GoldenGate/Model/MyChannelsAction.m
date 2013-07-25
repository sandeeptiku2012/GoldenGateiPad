//
//  Created by Andreas Petrov on 10/24/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import "MyChannelsAction.h"


@implementation MyChannelsAction
{

}

- (id)init
{
    if ((self = [super initWithName:NSLocalizedString(@"SubscriptionsLKey", @"")]))
    {
       self.iconName = @"MyChannelsIconGray.png";
    }
    
    return self;
}

- (NSUInteger)hash
{
    // By returning a fixed hash we can make sure that two MyChannelsActions will always be treated as equals
    return 1234567890 * 12;
}

@end