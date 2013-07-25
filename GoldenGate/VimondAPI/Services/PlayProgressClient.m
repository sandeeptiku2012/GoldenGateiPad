//
//  Created by Andreas Petrov on 12/5/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import "PlayProgressClient.h"
#import "RestPlayProgress.h"
#import "RestPlatform.h"
#import "ClientArguments.h"
#import "ClientMethod.h"

static NSString *kPlayProgressTemplate = @"/{platform}/asset/{assetId}/playProgress";

@implementation PlayProgressClient
{

}
- (RestPlayProgress *)playProgressForAssetId:(NSNumber *)assetId
                                    platform:(RestPlatform *)platform
                                       error:(NSError **)error
{
    ClientMethod *method = [[[[self createMethod] GET] path:kPlayProgressTemplate] returns:[RestPlayProgress class]];
    ClientArguments *arguments = [ClientArguments new];
    [arguments setObject:platform forKey:@"platform"];
    [arguments setObject:assetId forKey:@"assetId"];

    return [self execute:method arguments:arguments error:error];
}

- (void)putProgressForAssetId:(NSNumber *)assetId
                offsetSeconds:(NSNumber *)offsetSeconds
                     platform:(RestPlatform *)platform
                        error:(NSError **)error
{
    RestPlayProgress *playProgress = [RestPlayProgress new];
    playProgress.offsetSeconds = offsetSeconds;

    ClientMethod *method = [[[[self createMethod] PUT] path:kPlayProgressTemplate] withBody:playProgress];
    [method setObject:platform forPathParameter:@"platform"];
    [method setObject:assetId forPathParameter:@"assetId"];

    [self execute:[method request]];
}


@end