#import "RestObject.h"
#import "RestMetadata.h"
#import "WebUtil.h"

@implementation RestMetadata {
    NSDictionary *_metadata;
}

+ (NSString *)root
{
    return @"metadata";
}

- (id)initWithJSONObject:(id)data
{
    if (self = [super initWithJSONObject:data])
    {
        if ([data isKindOfClass:[NSDictionary class]])
        {
            _metadata = data;
        }
    }
    return self;
}

- (id)valueForCurrentLanguage:(NSArray*)valueDictArray
{
    id value = nil;
    static NSString *wantedLanguage = @"*";// TODO: Must be fixed to support multiple languages in the future.
    for (NSDictionary *valueDict in valueDictArray)
    {
        NSString *language = [valueDict objectForKey:@"@xml:lang"];
        
        if ([language isEqualToString:wantedLanguage])
        {
            value = [valueDict objectForKey:@"$"];
            break;
        }
    }
    
    return value;
}

- (id)objectForKey:(NSString *)key
{
    id temp = [_metadata objectForKey:key];
    if (temp == nil || temp == [NSNull null])
    {
        return nil;
    }

    if ([temp isKindOfClass:[NSString class]])
    {
        return temp;
    }

    if ([temp isKindOfClass:[NSNumber class]])
    {
        return temp;
    }

    if ([temp isKindOfClass:[NSDictionary class]])
    {
        if ([temp objectForKey:@"$"] != nil)
        {
            return [temp objectForKey:@"$"];
        }
    }
    
    if ([temp isKindOfClass:[NSArray class]])
    {
        return [self valueForCurrentLanguage:temp];
    }

    return [temp description];
}

- (id)objectForKeyPath:(NSString *)key
{
    return [_metadata objectForKeyPath:key];
}

@end