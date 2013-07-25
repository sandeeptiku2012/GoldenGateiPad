#import "JSONSerializable.h"
#import "RestAsset.h"
#import "RestMetadata.h"
#import "DateConverter.h"

@implementation RestAsset {
}

+ (NSString *)root
{
    return @"asset";
}

- (NSDictionary *)readMetaData:(NSDictionary *)data
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (NSString *key in [data allKeys])
    {
        id object = [data objectForKey:key];
        if ([object isKindOfClass:[NSDictionary class]])
        {
            object = [object objectForKey:@"$"];
        } 
        
        if (object)
        {
            [result setObject:object forKey:key];
        }
    }
    return result;
}

- (id)initWithJSONObject:(id)data
{
    if (self = [super init])
    {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        self.identifier     = [formatter numberFromString:[data objectForKey:@"@id"]];
        self.title          = [data objectForKey:@"title"];
        self.duration       = [data objectForKey:@"duration"];
        self.metadata       = [[RestMetadata alloc] initWithJSONObject:[data objectForKey:@"metadata"]];
        self.categoryID     = [formatter numberFromString: [data objectForKey: @"@categoryId"]];
        self.voteCount      = [data objectForKey:@"voteCount"];

        DateConverter *dateConverter = [DateConverter new];
        self.publishedDate = [dateConverter dateFromString:[data objectForKey:@"publish"]];
    }
    return self;
}

- (id)JSONObject
{
    return nil;
}

- (NSString*)stringFromMetaDataObjectForKey:(id)key
{
    NSString *string = nil;
    id object = [_metadata objectForKey:key];
    if ([object isKindOfClass:[NSArray class]])
    {
        // TODO: Might want to fetch the string with the correct language in the future.
        string = [[object objectAtIndex:0]objectForKey:@"$"];
    }
    else
    {
        string = object;
    }
    
    return string;
}

- (Video *)videoObject
{
    Video *video        = [[Video alloc] init];
    video.identifier    = [self.identifier longValue];
    video.channelID     = [self.categoryID intValue];
    video.likeCount     = [self.voteCount integerValue];
    video.duration      = [self.duration longValue];
    video.publishedDate = self.publishedDate;
    
    video.title         = [self.metadata objectForKey:@"title"] ? : self.title;
    video.summary       = [self.metadata objectForKey:@"description-short"];
    video.previewAssetId= [[_metadata objectForKey:@"preview-asset-id"] intValue];
    video.imagePack     = [_metadata objectForKey:@"image-pack"];
    
    return video;
}

@end