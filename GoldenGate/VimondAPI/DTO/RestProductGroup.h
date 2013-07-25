//
//  RestProductGroup.h
//  GoldenGate
//
//  Created by Satish Basavaraj on 19/06/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "RestObject.h"

@class RestMetadata;
@class Bundle;

@interface RestProductGroup : RestObject

@property NSNumber *identifier;
@property NSNumber *parentId;
@property NSString *title;
@property NSString *summary;
@property NSString *accessType;
@property NSString *salesStatus;
@property RestMetadata *metadata;

- (id)initWithJSONObject:(id)data;
- (Bundle*)bundleObject;

@end
