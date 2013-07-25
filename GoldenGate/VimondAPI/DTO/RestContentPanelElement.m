#import "RestObject.h"
#import "RestContentPanelElement.h"
#import "RestSearchCategory.h"
#import "RestMetadata.h"
#import "RestAsset.h"

static NSDictionary *gContentTypeKey;

@implementation RestContentPanelElement {
}
+ (NSString *)root
{
    return @"contentPanelElement";
}

+ (void)initialize
{
    if (gContentTypeKey == nil)
    {
        gContentTypeKey =
        @{
            @"category"         : @"category",
            @"main_category"    : @"category",
            @"content_category" : @"category",
            @"asset"            : @"asset"
            
        };
    }
}

- (id)initWithJSONObject:(id)data
{
    self = [super initWithJSONObject:data];
    if (self)
    {
        self.title          = [data objectForKey:@"title"];
        self.text           = [data objectForKey:@"text"];
        self.contentKey     = [data objectForKey:@"contentKey"];
        self.contentType    = [data objectForKey:@"contentType"];
        NSString*contentTypeKey = [gContentTypeKey objectForKey:self.contentType];
        NSDictionary *contentData = [data objectForKey:contentTypeKey];
        
        // handles categories and asset on content panel. Bundle implementation will be added if needed.
        if ([contentTypeKey isEqualToString:@"category"]) {
            self.category       = [[RestSearchCategory alloc] initWithJSONObject:contentData];
            
        }else if([contentTypeKey isEqualToString:@"asset"])
        {
            self.asset = [[RestAsset alloc]initWithJSONObject:contentData];
        }
        
        self.metadata       = [[RestMetadata alloc]initWithJSONObject:[contentData objectForKey:@"metadata"]];
        self.imagePack      = [data objectForKey:@"imagePackId"];
        
        
        // Sometimes the content panel doesn't have metadata. In this case use fallbacks.
        BOOL useFallBack = self.imagePack == nil;
        if (useFallBack)
        {
            NSString *imageURLString = [data objectForKey:@"imageUrl"];
            // First try to get the image pack from the imageURL.
            self.imagePack = [self extractImagePackFromImageURL:imageURLString];
            
            
            if (self.imagePack == nil)
            {
                self.imageURL = imageURLString;
            }
        }
    }
    
    return self;
}

- (NSString *)extractImagePackFromImageURL:(NSString *)imageURL
{
    // Just check if it's a valid URL before moving on.
    NSURL *url = [NSURL URLWithString:imageURL];
    if (!url) {
        return nil;
    }
    
    // A hacky way to extract the imagePack ID from the imageURL.
    // Will probably not be needed once a proper imagePackID property is implemented
    // on the contentpanel objects.
    NSRange range = [imageURL rangeOfString:@"image/"];
    NSInteger startIndex = range.location + range.length;
    NSString *imagePack = nil;
    if (startIndex >=0 && range.location  != NSNotFound) {
        NSString *intermediateResult = [imageURL substringFromIndex:startIndex];
        NSRange logoRange = [intermediateResult rangeOfString:@"/"];
        if (logoRange.location != NSNotFound) {
            imagePack = [intermediateResult substringToIndex:logoRange.location];
        }
    }
    
    return imagePack;
}

- (id)JSONObject
{
    return [super JSONObject];
}

@end