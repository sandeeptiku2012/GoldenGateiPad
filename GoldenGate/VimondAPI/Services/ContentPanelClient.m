#import "ContentPanelClient.h"
#import "ClientMethod.h"
#import "RestContentPanel.h"
#import "ClientArguments.h"
#import "RestPlatform.h"

@implementation ContentPanelClient {
}

- (RestContentPanel *)getContentPanelByName:(NSString *)name error:(NSError **)error
{
    ClientMethod *method = [[[[self createMethod] GET] path:@"/contentpanel/{name}"] returns:[RestContentPanel class]];
    ClientArguments *arguments = [ClientArguments new];
    [arguments setObject:name forKey:@"name"];
    return [self execute:method arguments:arguments error:error];
}

- (RestContentPanel *)getExpandableContentPanelByName:(NSString *)name platform:(RestPlatform *)platform expand:(NSString *)expand error:(NSError **)error 
{
    ClientMethod *method = [[[[[self createMethod] GET] path:@"/{platform}/contentpanel/{name}"] parameters:@[@"expand"]] returns:[RestContentPanel class]];
    ClientArguments *arguments = [ClientArguments new];
    [arguments setObject:platform forKey:@"platform"];
    [arguments setObject:name forKey:@"name"];
    [arguments setObject:expand forKey:@"expand"];
    return [self execute:method arguments:arguments error:error];
}



@end