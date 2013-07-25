#import "VideoStore.h"
#import "Video.h"
#import "RestPlatform.h"
#import "AssetClient.h"
#import "RestAssetRating.h"
#import "User.h"
#import "SearchClient.h"
#import "Channel.h"
#import "Show.h"
#import "SearchResult.h"
#import "RestSearchAssetList.h"
#import "RestSearchAsset.h"
#import "ContentCategory.h"
#import "DisplayEntity.h"

@interface VideoStore () {
    RestPlatform *_platform;
    AssetClient *_assetClient;
    SearchClient *_searchClient;
}

@end

@implementation VideoStore

- (id)initWithBaseURL:(NSString *)baseURL platformName:(NSString *)platformName
{
    if (self = [super init])
    {
        _platform = [RestPlatform platformWithName:platformName];
        _assetClient = [[AssetClient alloc] initWithBaseURL:baseURL];
        _searchClient = [[SearchClient alloc] initWithBaseURL:baseURL];
    }
    return self;
}

- (BOOL)isLiked:(Video *)video user:(User *)user error:(NSError **)error
{
    NSNumber *assetId = [NSNumber numberWithLongLong:video.identifier];
    NSNumber *userId = user.identifier;
    RestAssetRating *r = [_assetClient getRatingForUser:_platform assetId:assetId userId:userId error:error];
    return [r.rating isEqualToString:@"RATING_5"];
}

- (void)like:(Video *)video user:(User *)user error:(NSError **)error
{
    NSNumber *assetId = [NSNumber numberWithLongLong:video.identifier];
    NSNumber *userId = user.identifier;
    RestAssetRating *rating = [[RestAssetRating alloc] init];
    rating.rating = @"RATING_5";
    rating.crumb = [userId stringValue];
    rating.userId = [userId stringValue];
    [_assetClient postAssetRating:rating platform:_platform assetId:assetId error:error];
}

- (void)unlike:(Video *)video user:(User *)user error:(NSError **)error
{
    NSNumber *assetId = [NSNumber numberWithLongLong:video.identifier];
    NSNumber *userId = user.identifier;
    RestAssetRating *rating = [_assetClient getRatingForUser:_platform assetId:assetId userId:userId error:error];
    [_assetClient deleteAssetRating:_platform assetId:assetId ratingId:rating.identifier error:error];
}

- (SearchResult *)videosForChannel:(Channel *)channel pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize sortBy:(ProgramSortBy)sortBy error:(NSError **)error
{
    NSString *category = [NSString stringWithFormat:@"%d", channel.identifier];
    NSNumber *start = [NSNumber numberWithLongLong:pageIndex];
    NSNumber *size = [NSNumber numberWithLongLong:pageSize];
    RestProgramSortBy *sort = sortBy != ProgramSortByDefault ? [[RestProgramSortBy alloc] initWithEnum:sortBy] : nil;

    return [self videosForCategory:category query:nil text:nil start:start size:size sort:sort error:error];
}

- (SearchResult *)videosForEntity:(DisplayEntity *)dispEntity pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize sortBy:(ProgramSortBy)sortBy error:(NSError **)error
{
    NSString *category = [NSString stringWithFormat:@"%d", dispEntity.identifier];
    NSNumber *start = [NSNumber numberWithLongLong:pageIndex];
    NSNumber *size = [NSNumber numberWithLongLong:pageSize];
    RestProgramSortBy *sort = sortBy != ProgramSortByDefault ? [[RestProgramSortBy alloc] initWithEnum:sortBy] : nil;
    
    return [self videosForCategory:category query:nil text:nil start:start size:size sort:sort error:error];
}


//Using similar function as of videosForChannel. This is because the call to get videos is same for both - depends
//only on category id
- (SearchResult *)videosForShow:(Show *)show pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize sortBy:(ProgramSortBy)sortBy error:(NSError **)error
{
    NSString *category = [NSString stringWithFormat:@"%d", show.identifier];
    NSNumber *start = [NSNumber numberWithLongLong:pageIndex];
    NSNumber *size = [NSNumber numberWithLongLong:pageSize];
    RestProgramSortBy *sort = sortBy != ProgramSortByDefault ? [[RestProgramSortBy alloc] initWithEnum:sortBy] : nil;
    
    return [self videosForCategory:category query:nil text:nil start:start size:size sort:sort error:error];
}

- (SearchResult *)videosForCategory:(NSString *)categoryId query:(NSString *)query text:(NSString *)text start:(NSNumber *)start size:(NSNumber *)size sort:(RestProgramSortBy *)sort error:(NSError **)error
{
    RestSearchAssetList *searchAssetList = [_searchClient getAssetsForPlatform:_platform subCategory:categoryId query:query sort:sort start:start size:size text:text error:error];

    NSMutableArray *videos = [NSMutableArray array];
    for (RestSearchAsset *asset in searchAssetList.assets)
    {
        [videos addObject:[asset videoObject]];
    }

    SearchResult *searchResult = [[SearchResult alloc] init];
    searchResult.totalCount = [searchAssetList.numberOfHits unsignedIntegerValue];
    searchResult.items = videos;

    return searchResult;
}

- (SearchResult *)newVideosForCategory:(ContentCategory *)category pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize error:(NSError **)error
{
    NSString *categoryId = [NSString stringWithFormat:@"%d", category.identifier];
    NSString *query = @"publish:[NOW-7DAYS TO NOW]";
    return [self videosForCategory:categoryId
                             query:query
                              text:nil start:@(pageIndex)
                              size:@(pageSize)
                              sort:[RestProgramSortBy createProgramWithEnum:ProgramSortByPublishedDateDesc]
                             error:error];
}

- (SearchResult *)popularVideosForCategory:(ContentCategory *)category pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize sortBy:(ProgramSortBy)sortBy error:(NSError **)error
{
    NSString *categoryId = [NSString stringWithFormat:@"%d", category.identifier];
    return [self videosForCategory:categoryId
                             query:nil
                              text:nil
                             start:@(pageIndex)
                              size:@(pageSize)
                              sort:[RestProgramSortBy createProgramWithEnum:sortBy]
                             error:error];
}

- (Video *)videoWithId:(int)videoID error:(NSError **)error
{
    NSNumber *assetId = [NSNumber numberWithInt:videoID];
    RestAsset *asset = [_assetClient getAsset:assetId platform:_platform expand:@"metadata" error:error];
    return [asset videoObject];
}

@end