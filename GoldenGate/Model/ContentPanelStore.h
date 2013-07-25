#import <Foundation/Foundation.h>

typedef enum {
    ContentPanelTypeNoteworthy,
    ContentPanelTypePopularChannels,
    ContentPanelTypePopularShows,
    ContentPanelTypeFeatured
} ContentPanelType;

@class ContentCategory;

@interface ContentPanelStore : NSObject

- (id)initWithBaseURL:(NSString *)baseURL platformName:(NSString *)platformName;

// strLevel parameter to choose channels, shows or both
- (NSArray *)contentPanel:(ContentPanelType)type forCategory:(ContentCategory *)category error:(NSError **)error; 
- (NSArray *)featuredContentPanelForCategory:(ContentCategory *)category error:(NSError **)error;

@end