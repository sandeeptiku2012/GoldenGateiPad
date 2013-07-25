#import "ChannelStore.h"
#import "SearchResult.h"
#import "ContentCategory.h"
#import "SearchClient.h"
#import "RestPlatform.h"
#import "RestSearchCategoryList.h"
#import "RestSearchCategory.h"
#import "Channel.h"
#import "Show.h"
#import "VimondStore.h"
#import "TreeNodeCache.h"

#define kNumberOfDaysThatCountAsNew 7
#define kNumberOfDaysForMostSubscribed 30

@interface ChannelStore ()
{
    RestPlatform *_platform;
    SearchClient *_searchClient;
}

@property (strong) TreeNodeCache *channelCache;



@end

@implementation ChannelStore

- (id)initWithBaseURL:(NSString *)baseURL platformName:(NSString *)platformName
{
    if (self = [super init])
    {
        _platform = [RestPlatform platformWithName:platformName];
        _searchClient = [[SearchClient alloc] initWithBaseURL:baseURL];
        _channelCache = [TreeNodeCache new];
        _channelCache.overrideOldNodes = YES;
        
    }

    return self;
}

- (void)clearCache
{
    [_channelCache clearCache];
}

- (void)storeChannelInCache:(Channel *)channel
{
    [self.channelCache storeNode:channel withKey:@(channel.identifier)];
}



- (void)invalidateCacheForChannel:(Channel *)channel
{
    [self.channelCache deleteNodeWithKey:@(channel.identifier)];
}



- (SearchResult *)channelsForCategory:(ContentCategory *)category
                            pageIndex:(NSUInteger)pageIndex
                             pageSize:(NSUInteger)pageSize
                               sortBy:(ProgramSortBy)sortBy
                                error:(NSError **)error
{
    NSString *categoryId = [NSString stringWithFormat:@"%d", category.identifier];
    RestProgramSortBy *sort = sortBy != ProgramSortByDefault ? [[RestProgramSortBy alloc] initWithEnum:sortBy] : nil;
    NSNumber *start = [NSNumber numberWithUnsignedInteger:pageIndex];
    NSNumber *size = [NSNumber numberWithUnsignedInteger:pageSize];

    SearchResult *channelResult = [self channelsForCategory:categoryId query:@"levelName:SHOW" sort:sort start:start size:size text:nil error:error];
    return channelResult;
}



- (SearchResult *)channelsForCategory:(NSString *)categoryId
                                query:(NSString *)query
                                 sort:(RestProgramSortBy *)sort
                                start:(NSNumber *)start
                                 size:(NSNumber *)size
                                 text:(NSString *)text
                                error:(NSError **)error
{
    RestSearchCategoryList *searchCategoryList = [_searchClient getCategoriesForPlatform:_platform
                                                                             subCategory:categoryId
                                                                                   query:query
                                                                                    sort:sort
                                                                                   start:start
                                                                                    size:size
                                                                                    text:text
                                                                                   error:error];
    NSMutableArray *channels = [NSMutableArray array];
    for (RestSearchCategory *searchCategory in searchCategoryList.categories)
    {
        // getting the channel object
        Channel* channel = [searchCategory channelObject];
        if (channel) {
            [channels addObject:channel];
        }
        
    }
    
    SearchResult *searchResult = [[SearchResult alloc] init];
    
    searchResult.totalCount = [searchCategoryList.numberOfHits unsignedIntegerValue];
    searchResult.items = channels;
    
    for (Channel *channel in channels)
    {
        [self storeChannelInCache:channel];
    }
    
    return searchResult;
}


- (SearchResult *)newChannelsForCategory:(ContentCategory *)category
                               pageIndex:(NSUInteger)pageIndex
                                pageSize:(NSUInteger)pageSize
                                   error:(NSError **)error
{
    NSString *categoryId = [NSString stringWithFormat:@"%d", category.identifier];
    NSString *query = [NSString stringWithFormat:@"latestPublishedAssetDate:[NOW-%dDAYS TO NOW]", kNumberOfDaysThatCountAsNew];
    return [self channelsForCategory:categoryId
                               query:query
                                sort:[RestProgramSortBy createProgramWithEnum:ProgramSortByChannelPublishedDate]
                               start:@(pageIndex)
                                size:@(pageSize)
                                text:nil error:error];
}

- (SearchResult *)mostSubscribedChannelsForCategory:(ContentCategory *)category
                                          pageIndex:(NSUInteger)pageIndex
                                           pageSize:(NSUInteger)pageSize
                                             sortBy:(ProgramSortBy)sortBy
                                              error:(NSError **)error
{
    NSString *categoryId = [NSString stringWithFormat:@"%d", category.identifier];
    return [self channelsForCategory:categoryId
                               query:nil
                                sort:[RestProgramSortBy createProgramWithEnum:sortBy]
                               start:@(pageIndex)
                                size:@(pageSize)
                                text:nil
                               error:error];
}

- (Channel *)channelWithId:(NSUInteger)channelId error:(NSError **)error
{
    Channel *foundChannel = [self.channelCache nodeWithKey:@(channelId)];

    if (foundChannel == nil)
    {
        NSString *query = [NSString stringWithFormat:@"categoryId:%d", channelId];
        NSString *categoryId = [[[VimondStore categoryStore] rootCategoryID:error] stringValue];
        SearchResult *result = [self channelsForCategory:categoryId query:query sort:nil start:@0 size:@1 text:nil error:error];
        if (result.totalCount > 0)
        {
            foundChannel = [result.items objectAtIndex:0];
        }
    }

    return foundChannel;
}

- (SearchResult *)channelsFromPublisher:(NSString *)publisher pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize sortBy:(ProgramSortBy)sort error:(NSError **)error
{
    NSString *rootCategoryId = [[[VimondStore categoryStore] rootCategoryID:error] stringValue];
    NSString *query = [NSString stringWithFormat:@"levelName:SHOW AND categoryMeta_publisher_text:\"%@\"", [publisher stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
    RestProgramSortBy *restProgramSortBy = sort != ProgramSortByDefault ? [[RestProgramSortBy alloc] initWithEnum:sort] : nil;
    return [self channelsForCategory:rootCategoryId
                               query:query
                                sort:restProgramSortBy
                               start:[NSNumber numberWithUnsignedInteger:pageIndex]
                                size:[NSNumber numberWithUnsignedInteger:pageSize]
                                text:nil error:error];
}





- (Channel *)editorsPickForCategory:(ContentCategory *)category error:(NSError **)error
{
    NSString *categoryId = [NSString stringWithFormat:@"%d", category.identifier];
    NSString *query = @"categoryMeta_editors-pick_text:true";
    RestSearchCategoryList *searchCategoryList = [_searchClient getCategoriesForPlatform:_platform
                                                                             subCategory:categoryId
                                                                                   query:query
                                                                                    sort:nil start:@0
                                                                                    size:@1
                                                                                    text:nil error:error];
    if ([searchCategoryList.categories count] > 0)
    {
        return [[searchCategoryList.categories lastObject] channelObject];
    }
    return nil;
}

- (NSUInteger)numberOfVideosInChannel:(Channel *)channel error:(NSError **)error
{
    NSString *categoryId = [NSString stringWithFormat:@"%d", channel.identifier];
    SearchResult *result = [self channelsForCategory:categoryId query:nil sort:nil start:@0 size:@0 text:nil error:error];
    return result.totalCount;
}


@end