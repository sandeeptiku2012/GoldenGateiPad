//
//  Created by Andreas Petrov on 12/11/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import "UsageEventTemplate.h"


@implementation UsageEventTemplate
{

}
- (id)initWithEventId:(NSNumber *)eventId
         categoryName:(NSString *)categoryName
           actionName:(NSString *)actionName
             labelKey:(NSString *)labelKey
             valueKey:(NSString *)valueKey
{
    if ((self = [super init]))
    {
        _eventId = eventId;
        _categoryName = categoryName;
        _actionName = actionName;
        _labelKey = labelKey;
        _valueKey = valueKey;
    }

    return self;
}

+ (id)createUsageEventTemplateWithEventId:(NSNumber *)eventId
                             categoryName:(NSString *)categoryName
                               actionName:(NSString *)actionName
                                 labelKey:(NSString *)labelKey
                                 valueKey:(NSString *)valueKey
{
    return [[UsageEventTemplate alloc] initWithEventId:eventId
                                          categoryName:categoryName
                                            actionName:actionName
                                              labelKey:labelKey
                                              valueKey:valueKey];
}


@end