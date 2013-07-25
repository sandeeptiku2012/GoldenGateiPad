#import "GoldenGateClientExecutor.h"
#import "ClientRequest.h"
#import "ClientResponse.h"
#import "NSDictionary+Merge.h"

@implementation GoldenGateClientExecutor

- (ClientResponse *)execute:(ClientRequest *)request
{
    NSDictionary *defaultHeaders = @{@"Accept":@"application/json", @"Accept-Encoding":@"gzip"};
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:request.url];
    [urlRequest setAllHTTPHeaderFields:[defaultHeaders dictionaryByMergingWith:request.headers]];

    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error];
    DLog(@"error: %@", error);
    DLog(@"urlResponse: %@", urlResponse );
    DLog(@"urlResponse.statusCode: %d", urlResponse.statusCode)
    DLog(@"urlResponse.headers: %@", urlResponse.allHeaderFields);
    NSString *body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    DLog(@"data: %@", body);
    return [[ClientResponse alloc] initWithData:data response:urlResponse error:error];
}

@end