//
//  Created by Andreas Petrov on 10/24/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//




#import "CategoryAction.h"
#import "ContentCategory.h"
#import "CategoryActionFactory.h"

@interface CategoryAction()

@property (strong, readwrite, nonatomic) ContentCategory *category;

@end

@implementation CategoryAction
{
    NSArray * _subActions;
}

- (id)initWithCategory:(ContentCategory *)category
{
    NSAssert(category != nil, @"category must me not nil");
    if ((self = [super initWithName:category.title]))
    {
        _category = category;
        self.iconName = @"FeaturedIcon.png";
    }

    return self;
}

- (NSArray *)subActions
{
    NSAssert(_subActions != nil, @"Call loadSubActions before asking for subActions." );
    return _subActions ;
 }

- (void)loadSubActionsIfNeeded
{
    if (_subActions)
    {
        return;
    }

    _subActions = [[CategoryActionFactory sharedInstance]subcategoryActionsForCategory:self.category];

    for (NavAction *action in _subActions)
    {
        action.parentAction = self;
    }
}

- (NSString*)name
{
    BOOL isRootAction = self.parentAction == nil;
    if (isRootAction)
    {
        return NSLocalizedString(@"ChannelsLKey", @"");
    }
    
    return [super name];
}

- (NSUInteger)hash
{
    return (NSUInteger)self.category.identifier;
}

@end