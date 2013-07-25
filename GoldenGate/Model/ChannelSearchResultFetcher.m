#import "ChannelSearchResultFetcher.h"
#import "SearchResult.h"
#import "VimondStore.h"

@implementation ChannelSearchResultFetcher {
}
- (SearchResult *)executeSearchWithSearchString:(NSString *)string
                                pageNumber:(NSUInteger)pageNumber
                             objectsPrPage:(NSUInteger)objectsPrPage
                                     error:(NSError**)error

{
    return [[VimondStore searchExecutor] findChannelsWithSearchString:string
                                                           pageNumber:pageNumber
                                                        objectsPrPage:objectsPrPage error:error];
}

@end