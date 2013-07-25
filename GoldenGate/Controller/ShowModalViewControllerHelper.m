//
//  ShowModalViewControllerHelper.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 11/06/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "ShowModalViewControllerHelper.h"
#import "EpisodesForShowDataFetcher.h"
#import "VideoTableCell.h"
#import "PrefetchingDataSource.h"
#import "Video.h"
#import "EntityVideoPlayBackViewController.h"
#import "ShowsForCategoryDataFetcher.h"
#import "ShowsFromPublisherDataFetcher.h"
#import "Show.h"


@implementation ShowModalViewControllerHelper


-(ObjectAsSourceDataFetcher*)getDataFetcherForEntityofCategory
{
    // return data fetcher to get shows of same category
    return [ShowsForCategoryDataFetcher new];
}


-(ObjectAsSourceDataFetcher*)getDataFetcherForEntityofPublisher
{
    // return data fetcher to fetch shows of same publisher
    return [ShowsFromPublisherDataFetcher new];
}

-(ObjectAsSourceDataFetcher*)getDataFetcher
{
    // obtain data fetcher to get episodes for a show
    EpisodesForShowDataFetcher* fetcher = [EpisodesForShowDataFetcher new];
    return fetcher;
}

-(id)initWithEntity:(Entity*)displEntity navController:(UINavigationController*)navtnController
{
    
    NSAssert([displEntity isKindOfClass:[Show class]], @"displEntity should of type show");
    self = [super initWithEntity:displEntity navController:navtnController];
    return self;
}

-(int)getEntityLikeCount
{
    NSAssert([self.dispEntity isKindOfClass:[Show class]], @"Entity should be of type Show");
    return ((Show*)self.dispEntity).likeCount;
}

-(NSString*)getEntityTypeString
{
    return NSLocalizedString(@"ShowsLKey", @"");
}

-(NSString*)getNoSubElementsString
{
    return NSLocalizedString(@"ShowHasNoEpisodesLKey", @"");
}

-(NSString*)getSubItemCountString:(NSUInteger)count
{
    return [NSString stringWithFormat:NSLocalizedString(@"NumberOfEpisodesLKey",@""), count];
}


-(NSString*)getSubItemNavigationBarTitle
{
    return NSLocalizedString(@"EpisodesLKey", @"");
}


-(UITableViewCell*)getTableCell:(NSString*)cellIdentifier
{
    UITableViewCell* cell = [[VideoTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    return cell;
    
}
-(void)setDataObjectForCell:(Entity*)entity cell:(UITableViewCell*)cellView
{
    NSAssert([cellView isKindOfClass:[VideoTableCell class]], @"Cell view should be of type VideoTableCell");
    NSAssert([entity isKindOfClass:[Video class]], @"Entity should be of type Video");
    
    VideoTableCell* cell = (VideoTableCell*)cellView;
    cell.video = (Video*)entity;
}

-(void)rowSelectdonSubElementsTable:(UIView*)contentView rectSubView:(CGRect)rectSubview dataSource:(PrefetchingDataSource*)dataSource cell:(UITableViewCell*)cellAtPath
{
    // when a sub view cell is clicked ie episode, video is played
    VideoTableCell* cell = (VideoTableCell*)cellAtPath;
    Video* showDetails = cell.video;
    [EntityVideoPlayBackViewController presentVideo:(Video *) showDetails
                                         fromEntity:(Show*)self.dispEntity
                           withNavigationController:self.navController];
}

-(NSString*)getImageURLForEntity:(CGSize)sizeImg
{
    Show* show = (Show*)self.dispEntity;
    return [show logoURLStringForSize:sizeImg];
}


-(BOOL)shouldDisplayParentalGuidance
{
    return YES;
}


-(PGRating)parentalGuidanceString
{
    return ((Show*)self.dispEntity).pgRating;
}

-(NSString*)publisherAsString
{
    return ((Show*)self.dispEntity).publisher;
}




@end
