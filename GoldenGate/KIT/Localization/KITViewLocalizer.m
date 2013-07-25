//
//  Created by Andreas Petrov on 5/31/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import "KITViewLocalizer.h"
#import "KITLocalizer.h"

@interface KITViewLocalizer()

@property (strong, nonatomic) NSMutableDictionary *viewToLocalizationKeyMap;
@property (strong, nonatomic) NSMutableSet *localizedViews;

@end

@implementation KITViewLocalizer

@synthesize localizer;
@synthesize localizedTextSuffix;
@synthesize viewToLocalizationKeyMap;
@synthesize localizedViews;


- (id)initWithLocalizer:(KITLocalizer *)aLocalizer
{
    if ((self = [super init]))
    {
        self.localizer = aLocalizer;
        self.localizedTextSuffix = kDefaultlocalizedTextSuffix;
        self.viewToLocalizationKeyMap = [[NSMutableDictionary alloc]init];
        self.localizedViews = [[NSMutableSet alloc]init];
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self 
                                                selector:@selector(languageChanged)
                                                    name:KITLocalizerLanguageChangedNotification 
                                                  object:nil];
    }

    return self;
}

- (id)init 
{
    if ((self = [self initWithLocalizer:[KITLocalizer sharedInstance]])) 
    {
        
    }
    
    return self;
}

- (void)dealloc 
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - Public methods

- (void)localizeView:(UIView *)view
{
    [self.localizedViews addObject:view];
    
    [self traverseView:view];
}


#pragma mark - Private methods

- (void)traverseView:(UIView *)view
{
    BOOL isLocalizableViewCandidate = view.subviews.count == 0 || [view isKindOfClass:[UIButton class]];
    
    if (isLocalizableViewCandidate) 
    {
        NSString *lookupKeyForView = [self tryGettingLookupKeyForView:view];

        BOOL textShouldBeLocalized = [lookupKeyForView hasSuffix:self.localizedTextSuffix];
        if (textShouldBeLocalized) 
        {
            [self localizeView:view usingLookupKey:lookupKeyForView];
        }
    }

    for (UIView *subview in view.subviews)
    {
        [self traverseView:subview];
    }
}

/*!
 * Helper for getting a string representation of an object´s hash value.
 */
- (NSString*)stringFromObjectHash:(NSObject*)object
{
    return [NSString stringWithFormat:@"%d",object.hash];
}

/*!
 * Constructs a string with object hash and appends an index number after it. 
 * Used to map UI objects that have multiple text labels
 */
- (NSString*)stringFromObjectHash:(NSObject*)object withIndex:(NSInteger)index
{
    return [NSString stringWithFormat:@"%d_%d",object.hash, index];
}

- (NSString *)tryGettingLookupKeyForView:(UIView *)view
{
    NSString *objectHash = [self stringFromObjectHash:view];
    NSString *lookupKey = [self.viewToLocalizationKeyMap objectForKey:objectHash];
    BOOL lookupKeyAlreadyRegistered = lookupKey != nil;
        
    if (!lookupKeyAlreadyRegistered) 
    {
        BOOL hasTextProperty = [view respondsToSelector:@selector(text)];
        if (hasTextProperty) 
        {
            lookupKey = [view performSelector:@selector(text)];
        }
        else if ([view respondsToSelector:@selector(setTitle:forState:)]) 
        {
//            NSValue *value = NSValue valueWith
            lookupKey = [view performSelector:@selector(titleForState:) withObject:@(UIControlStateNormal)];
        }
        
        if (lookupKey) 
        {
            // Map the object hash to the lookup key
            [self.viewToLocalizationKeyMap setObject:lookupKey forKey:objectHash];
        }
    }

    return lookupKey;
}

- (void)localizeView:(UIView *)view usingLookupKey:(NSString *)lookupKey
{
    NSString *textValue = [self.localizer localizedStringForKey:lookupKey comment:@""];
    
    BOOL hasTextMutator = [view respondsToSelector:@selector(setText:)];
    if (hasTextMutator) 
    {
        [view performSelector:@selector(setText:) withObject:textValue];
    }
    else if ([view respondsToSelector:@selector(setTitle:forState:)])
    {
        // The setTitle:forState: selector is not possible to use with performSelector:withObject:withObject
        // because the boxed enum UIControlStateNormal doesn´t get transferred correctly to its argument.
        NSMethodSignature *m = [view methodSignatureForSelector:@selector(setTitle:forState:)];
        NSInvocation *inv = [NSInvocation invocationWithMethodSignature:m ];
        inv.target = view;
        inv.selector = @selector(setTitle:forState:);
        
        UIControlState state = UIControlStateNormal;
        [inv setArgument:&textValue atIndex:2];
        [inv setArgument:&state atIndex:3];
        [inv retainArguments];
        [inv invoke];
    }
}

- (void)relocalizeViews
{
    for (UIView *view in self.localizedViews) 
    {
        [self localizeView:view];
    }
}

- (void)languageChanged
{
    [self relocalizeViews];
}


@end