#import "ClientExecutor.h"
#import "ClientResponse.h"
#import "ClientRequest.h"
#import "RestCategory.h"
#import "WebUtil.h"
#import "NSDictionary+Merge.h"
#import "Error.h"

@implementation ClientExecutor {
}

- (ClientResponse *)execute:(ClientRequest *)request
{
    //KITAssertIsNotOnMainQueue();
    NSDictionary *defaultHeaders = @{@"Accept":@"application/json", @"Accept-Encoding":@"gzip"};
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:request.url];
    [urlRequest setAllHTTPHeaderFields:[defaultHeaders dictionaryByMergingWith:request.headers]];
    [urlRequest setHTTPMethod:request.method];
    [urlRequest setHTTPBody:request.body];

//    DLog(@"request: %@", request);
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error];
    if (error != nil)
    {
//        DLog(@"error: %@", error);
    }
   
    ClientResponse *response = [[ClientResponse alloc] initWithData:data response:urlResponse error:error];
//    DLog(@"response: %@", response);
    return response;
}

- (id)readType:(Class)clazz fromResponse:(ClientResponse *)response error:(NSError **)error
{
    if (response.data.length == 0)
    {
        return nil;
    }
    
    if ([[response.headers objectForKeyPath:@"Content-Type"] hasPrefix:@"application/json"])
    {
        if ([clazz conformsToProtocol:@protocol(JSONSerializable)])
        {
            id data = [NSJSONSerialization JSONObjectWithData:response.data options:kNilOptions error:error];
            BOOL success = (!error || (error && *error == nil));
            if ([data isKindOfClass:[NSDictionary class]] && success)
            {
                NSDictionary *dict = [data objectForKey:[clazz root]];
                BOOL validDict = [dict isKindOfClass:[NSDictionary class]];
                
                if (!validDict && error)
                {
                    *error = [NSError errorWithDomain:kVimondErrorDomain
                                                 code:ErrorJSONResponseIncomplete
                                             userInfo:nil];
                }
                
                return validDict ? [[clazz alloc] initWithJSONObject:dict] : nil;
            }
        }
    }
    @throw [NSException exceptionWithName:@"Deserialize error"
                                   reason:[NSString stringWithFormat:@"Could not read '%@' from '%@'", clazz, response]
                                 userInfo:nil];
}

@end