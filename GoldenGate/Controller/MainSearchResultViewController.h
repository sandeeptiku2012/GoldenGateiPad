//
//  MainSearchResultViewController.h
//  GoldenGate
//
//  Created by Satish Basavaraj on 24/06/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "BaseNavViewController.h"
#import "LoadingView.h"
#import "GridViewController.h"
#import "TitleWithGridViewCell.h"

@class ContentCategory;

// Enum to list the different kinds of panels to be displayed on search result screen
typedef enum _SEARCH_SCREEN_INDEX_ENUM {
    kChannelsIndex,
    kShowsIndex,
    kVideosIndex,
    kTotalScreens
}SEARCH_SCREEN_INDEX_ENUM;

@interface MainSearchResultViewController : BaseNavViewController<UITableViewDataSource, UITableViewDelegate, GridViewControllerDelegate, TitleWithGridViewCellDelegate>

// Function that can be called to search and display on UI
- (void)executeSearchWithSearchString:(NSString*)searchString;

@end
