#import <Foundation/Foundation.h>
#import "FeaturedContent.h"

@class RestSearchCategory, RestMetadata, RestAsset;

@interface RestContentPanelElement : RestObject

@property(nonatomic) NSString *title;
@property(nonatomic) NSString *text;
@property(nonatomic) NSString *imagePack;
@property(nonatomic) NSString *imageURL;
@property(nonatomic) NSNumber *contentKey;
@property(nonatomic) NSString *contentType;
@property(nonatomic) RestSearchCategory *category;
@property(nonatomic) RestAsset* asset;
@property(nonatomic) RestMetadata *metadata;

@end