//
//  Constants.m
//  GoldenGate
//
//  Created by Erik Engheim on 21.08.12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "Constants.h"


#define kVimondBaseProductionURL    @"http://api.stage2.xidio.com/api"
#define kVimondBaseImageServiceProductionURL  @"http://image.stage.xidio.com/api"


CGFloat kVertialTextOffset = 2; // The amount of pixels to offset labels using the xfinity font.
NSInteger kHorizontalGridSpacing = 20;
NSInteger kVerticalGridSpacing = 5;
CGFloat kDimmingViewAlpha = 0.4;

NSString *kVimondBaseURL = kVimondBaseProductionURL;
NSString *kVimondBaseImageServiceURL = kVimondBaseImageServiceProductionURL;
NSString *kVimondPlatform = @"iptv";

NSString *kNavigationPopoverDismiss = @"NavigationPopoverDismiss";
NSString *kNotificationDismissSearchPopover = @"NotificationDismissSearchPopover";
NSString *kNotificationShowAllSearchResults = @"NotificationShowAllSearchResults";

// TODO erik: This is quick and dirty, will not work for spanish. Got to figure out proper way
PGRating PgRatingStringToEnum(NSString *s)
{
    // A bit silly way of doing it but with so few elements
    // a linear lookup is just as fast as a dictionary lookup.
    static struct {
        PGRating rating;
        char *name; // ARC does not allow NSString in struct
    } mapping[] = {
        {PgRatingChildren, "V-Y"},
        {PgRatingOlderChildren,  "TV-Y7"},
        {PgRatingGeneralAudience,"TV-G"},
        {PgRatingParentalGuidance,"TV-PG"},
        {PgRatingParentsStronglyCautioned,"TV-14"},
        {PgRatingParentsMatureAudience   ,"TV-MA"},
        {PgRatingNotRated, 0},
    };
    
    int i = 0;
    while (mapping[i].rating != PgRatingNotRated) {
        NSString *key = [[NSString alloc] initWithUTF8String:mapping[i].name];
        if ([key isEqualToString:s]) {
            return mapping[i].rating;
        }
        ++i;
    }
    
    return PgRatingNotRated;
}