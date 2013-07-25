#import "JSONSerializable.h"
#import "RestCategory.h"
#import "RestSearchCategory.h"
#import "Entity.h"
#import "Channel.h"
#import "RestMetadata.h"
#import "Show.h"

@implementation RestSearchCategory {
}

- (id)initWithJSONObject:(id)data
{
    if (self = [super initWithJSONObject:data])
    {
        if (self.parentId == nil)
        {
            NSString *categoryPath = [[data objectForKey:@"categoryPath"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSArray *categories = [categoryPath componentsSeparatedByString:@" "];
            if ([categories count] >= 2)
            {
                NSString *parentCategoryString = [categories objectAtIndex:[categories count] - 2];
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                self.parentId = [formatter numberFromString:parentCategoryString];
            }
        }
    }
    return self;
}

- (id)JSONObject
{
    return nil;
}

-(id)entityObject
{
    Entity* entity = nil;
    if ([self.level isEqualToString:LEVEL_SHOW]) {
        entity = [self showsObject];
    }else if([self.level isEqualToString:LEVEL_CHANNEL])
    {
        entity = [self channelObject];
    }
    
    return entity;
}

- (id)channelObject
{
    Channel *channel = nil;
    if ([self.level isEqualToString:LEVEL_CHANNEL]) {
        channel = [[Channel alloc] init];
        channel.identifier  = [self.identifier intValue];
        channel.parentId    = [self.parentId intValue];
        channel.title       = [self.metadata objectForKey:@"title"];
        channel.summary     = [self.metadata objectForKey:@"description-short"];
        
        channel.publisher 	= [self.metadata objectForKey:@"publisher"];
        channel.pgRating 	= PgRatingStringToEnum([self.metadata objectForKey:@"parental-guidance"]);
        channel.likeCount 	= [self.voteCount integerValue];;
        channel.imagePack   = [self.metadata objectForKey:@"image-pack"];
        channel.strGenre    = [self.metadata objectForKey:@"genre"];//Get genre info for channel.
    }
    

    


    return channel;
}



-(id)showsObject
{
    Show* show  = nil;
    if ([self.level isEqualToString:LEVEL_SHOW]) {
        show       = [Show new];
        show.parentId    = [self.parentId intValue];
        show.identifier  = [self.identifier intValue];
        show.title       = self.title;
        show.summary     = [self.metadata objectForKey:@"description-short"];
        
        show.publisher 	= [self.metadata objectForKey:@"publisher"];
        show.pgRating 	= PgRatingStringToEnum([self.metadata objectForKey:@"parental-guidance"]);
        show.likeCount 	= [self.voteCount integerValue];;
        show.imagePack   = [self.metadata objectForKey:@"image-pack"];
        show.strGenre    = [self.metadata objectForKey:@"genre"];
    }

    

    
    return show;    
}

@end