//
//  Constants.h
//  GoldenGate
//
//  Created by Erik Engheim on 21.08.12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Error.h"

extern CGFloat kVertialTextOffset;
extern NSInteger kHorizontalGridSpacing; // The grid spacing between grid elements in the application. Should be the same across the app.
extern NSInteger kVerticalGridSpacing;
extern CGFloat   kDimmingViewAlpha;

extern NSString *kVimondBaseURL;
extern NSString *kVimondBaseImageServiceURL;
extern NSString *kVimondPlatform;

extern NSString *kNavigationPopoverDismiss;
extern NSString *kNotificationDismissSearchPopover;
extern NSString *kNotificationShowAllSearchResults;

typedef enum
{
    PgRatingNotRated,
    PgRatingChildren,       // TV-Y
    PgRatingOlderChildren,  // TV-Y7
    PgRatingGeneralAudience,// TV-G
    PgRatingParentalGuidance,//TV-PG
    PgRatingParentsStronglyCautioned,//TV-14
    PgRatingParentsMatureAudience   ,//TV-MA
} PGRating;

PGRating PgRatingStringToEnum(NSString *s);



// Viper (Prime Time) player statuses
#define VIPERPL_COMPLETED @"Completed"
#define VIPERPL_CREATED @"Created"
#define VIPERPL_ERROR @"Error"
#define VIPERPL_INITIALIZED @"Initialized"
#define VIPERPL_INITIALIZING @"Initializing"
#define VIPERPL_PAUSED @"Paused"
#define VIPERPL_PLAYING @"Playing"
#define VIPERPL_READY @"Ready"


// Level to identify entities from server
#define LEVEL_SHOW @"SUB_SHOW"
#define LEVEL_CHANNEL @"SHOW"