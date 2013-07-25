#import <Foundation/Foundation.h>
#import "RestClient.h"

@class RestContentPanel;
@class RestPlatform;

@interface ContentPanelClient : RestClient

- (RestContentPanel *)getContentPanelByName:(NSString *)name error:(NSError **)error;
- (RestContentPanel *)getExpandableContentPanelByName:(NSString *)name platform:(RestPlatform *)platform expand:(NSString *)expand error:(NSError **)error;

@end