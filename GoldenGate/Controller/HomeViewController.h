//
//  HomeViewController.h
//  GoldenGate
//
//  Created by Satish Basavaraj on 04/06/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "BaseNavViewController.h"
#import "LoadingView.h"
#import "GridViewController.h"
#import "TitleWithGridViewCell.h"
#import "CollectionViewController.h"
#import "TitleWithCollectionViewCell.h"
#import "ContentPanelStore.h"
#import "FeaturedContent.h"

@class ContentCategory;

typedef enum _HOME_SCREEN_INDEX_ENUM {
    kUPNextIndex = 0,
    kFeaturedIndex,
    kPopularIndex,
    kPopularChannelsIndex,
    kTotalScreens
}HOME_SCREEN_INDEX_ENUM;

@interface HomeViewController : BaseNavViewController<UITableViewDataSource, UITableViewDelegate, GridViewControllerDelegate, TitleWithGridViewCellDelegate, TitleWithCollectionViewCellDelegate,CollectionViewControllerDelegate>


@end
