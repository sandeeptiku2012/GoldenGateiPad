//
//  Created by Andreas Petrov on 12/11/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface UsageEventTemplate : NSObject

@property (copy, readonly, nonatomic) NSNumber *eventId;
@property (copy, readonly, nonatomic) NSString *categoryName;
@property (copy, readonly, nonatomic) NSString *actionName;
@property (copy, readonly, nonatomic) NSString *labelKey;
@property (copy, readonly, nonatomic) NSString *valueKey;


/*!
 @abstract
 Creates a UsageEventTemplate object
 @param eventId the number identying an event. Usually a boxed representation of an Enum.
 @param categoryName the category to group any event using this template.
 @param actionName the name of the tracking action.
 @param labelKey the key that is to be used to extract a label value from the eventData object sent by the tracking system.
 @param valueKey the key that is to be used to extract a value from the eventData object sent by the tracking system.
 */
+ (id)createUsageEventTemplateWithEventId:(NSNumber *)eventId
                             categoryName:(NSString *)categoryName
                               actionName:(NSString *)actionName
                                 labelKey:(NSString *)labelKey
                                 valueKey:(NSString *)valueKey;

@end