//
//  MainCategoryViewController.h
//  GoldenGate
//
//  Created by Andreas Petrov on 8/20/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "BaseNavViewController.h"
#import "GridViewController.h"
#import "TitleWithGridViewCell.h"
#import "CollectionViewController.h"
#import "TitleWithCollectionViewCell.h"
#import "ContentPanelStore.h"
#import "FeaturedContent.h"


@class ContentCategory;

typedef enum _STORE_SCREEN_INDEX_ENUM {
    kSSFeaturedIndex = 0,
    kSSPopularChannelsIndex,
    kSSA2ZChannelsIndex,
    kSSTotalScreens
}STORE_SCREEN_INDEX_ENUM;

/*!
 @abstract This view controller is used to display featured content for a main category.
 */
@interface MainCategoryViewController : BaseNavViewController <UITableViewDataSource, UITableViewDelegate, GridViewControllerDelegate, TitleWithGridViewCellDelegate, TitleWithCollectionViewCellDelegate,CollectionViewControllerDelegate>


@end
