//
//  Created by Andreas Petrov on 12/5/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "RestClient.h"

@class RestPlayProgress;
@class RestPlatform;


@interface PlayProgressClient : RestClient

- (RestPlayProgress *)playProgressForAssetId:(NSNumber *)assetId
                                    platform:(RestPlatform *)platform
                                       error:(NSError **)error;

- (void)putProgressForAssetId:(NSNumber *)assetId
                offsetSeconds:(NSNumber *)offsetSeconds
                     platform:(RestPlatform *)platform
                        error:(NSError **)error;


@end