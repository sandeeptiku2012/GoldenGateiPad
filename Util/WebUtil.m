//
//  WebUtil.m
//  Systemspill
//
//  Created by Erik Engheim on 23.07.12.
//  Copyright (c) 2012 Reaktor. All rights reserved.
//

#import "WebUtil.h"

@implementation NSDictionary (WebUtil)
+ (NSDictionary *)dictionaryFromJSON:(NSData *)data error:(NSError **)err
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:0
                                                          error:err];
    
    return dict;
}

static id objectsAtKey(id object, NSString *key)
{
    if ([object isKindOfClass:[NSArray class]]) {
        NSArray *array = object;
        NSMutableArray *newarray = [NSMutableArray arrayWithCapacity:array.count];
        for (id child in object) {
            id obj = objectsAtKey(child, key);
            if (obj)
                [newarray addObject: obj];
        }
        object = newarray;
    }
    else
        object = [object objectForKey:key];
    
    return object;
}

/*!
   More generic than valueForKeyPath because the name of the
   elements do not need to be valid property names. Just valid
   dictionary key names.
 
   Does not work if keys in the path contain "." in the name.
   Be carefull with paths that leads to arrays. It might not work
   exactly as expected.
 
   It can potentially return nested arrays. E.g. let us assume that
   there are multiple channels, each with multiple videos. The videos
   have a title attributes. "channel.video.title" will then return a 
   nested array: [["Jaws", "E.T"], ["The Matrix", "Max Payne", "Con Air"]].
   The outer array represents the channels. So there are two channels. The
   first channel has 2 videos and the second one has 3.
 
   Returns nil if any of the keys in the key path does not exist.
*/
- (id)objectForKeyPath:(NSString *)path
{
    id object = self;
    
    NSArray *keys = [path componentsSeparatedByString:@"."];
    for (NSString *key in keys) {
        object = objectsAtKey(object, key);
        
        if (!object)
            return nil;
    }
    
    return object;
}

/*!
  Allows us to access elements in a deeply nested JSON generated
  dictionary. We could write 
  [dict objectForKeyList: @"top", @"middle", @"bottom", nil];
 
   Does not work if there are arrays in the keypath.
 
  Returns nil if any of the keys in the key path does not exist.
*/
- (id)objectForKeyList:(id)key, ...
{
    id object = self;
    
    va_list ap;
    va_start(ap, key);
    for ( ; key; key = va_arg(ap, id)) {
        object = [object objectForKey:key];
        if (!object)
            return nil;
    }
    va_end(ap);
    return object;
}

/*!
 We need to use this instead of using 
 "stringByAddingPercentEscapesUsingEncoding:", because the latter does
 not work. See http://simonwoodside.com/weblog/2009/4/22/how_to_really_url_encode/
 
*/
static NSString *urlEncode(NSString *unencodedString)
{
    NSString * encodedString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
       NULL,
       (__bridge CFStringRef)unencodedString,
       NULL,
       (CFStringRef)@"!*'();:@&=+$,/?%#[]",
       kCFStringEncodingUTF8 );
    return encodedString;
}

/*!
 This is a very simple implementation.
 
 To have a more sofisticated version, look at: http://stackoverflow.com/questions/3997976/parse-nsurl-query-property
*/
- (NSString *) queryString
{
    NSMutableArray *pairs = [NSMutableArray arrayWithCapacity:4];
    
    [self enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        NSString *percentKey = urlEncode(key);
        NSString *percentObj = urlEncode(obj);
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", percentKey, percentObj]];
    }];
    
    return [pairs componentsJoinedByString:@"&"];
}

@end

