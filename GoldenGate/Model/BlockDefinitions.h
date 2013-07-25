//
//  BlockDefinitions.h
//  GoldenGate
//
//  Created by Andreas Petrov on 9/28/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

typedef void (^VoidHandler)(void);
typedef void (^ChannelsHandler)(NSArray *channelArray, NSError *error);
typedef void (^PagedObjectHandler)(NSObject *dataObject);
typedef void (^PagedObjectsHandler)(NSArray *objectsOnPage, NSUInteger totalObjectCount);
typedef void (^ErrorHandler)(NSError *error);
typedef void (^IntHandler)(NSUInteger integer);


