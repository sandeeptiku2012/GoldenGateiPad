#import "VideoSearchResultFetcher.h"
#import "VimondStore.h"
#import "SearchResult.h"

@implementation VideoSearchResultFetcher {
}
- (SearchResult *)executeSearchWithSearchString:(NSString *)string
                                pageNumber:(NSUInteger)pageNumber
                             objectsPrPage:(NSUInteger)objectsPrPage
                                     error:(NSError**)error
{
    return [[VimondStore searchExecutor] findVideosWithSearchString:string pageNumber:pageNumber objectsPrPage:objectsPrPage error:error];
}

@end