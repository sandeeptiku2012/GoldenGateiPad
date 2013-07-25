//
//  KIFTestScenario+EXAdditions.h
//  Testable
//
//  Created by Eric Firestone on 6/12/11.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import <Foundation/Foundation.h>
#import "KIFTestScenario.h"

@interface KIFTestScenario (EXAdditions)


//Ankit Vyas
+ (id)scenarioToCommonLoginCredential:(NSString *)userName Password:(NSString *)password;
+ (id)scenarioToSignInButtonClick:(KIFTestScenario *)scenario;
+ (id)scenarioToWaitingTime:(int)time common:(KIFTestScenario *)scenario;
+ (id)scenarioToClearTextField;
+ (id)scenarioToSignInButtonClick;
+ (id)scenarioToinValidLogin;
+ (id)scenarioToFeaturedLeftScroll;
+ (id)scenarioToFeaturedRightScroll;
+ (id)scenarioToFeaturedTapped;
+ (id)scenarioToPopularLeftScroll;
+ (id)scenarioToPopularRightScroll;
+(id)scenarioToPopularSelection;
+(id)scenarioToPopularVideoScrollUp;
+(id)scenarioToPopularVideoScrollDown;
+(id)scenarioToClickSubPopularVideo;
+(id)scenarioToClickPopularVideo;
+(id)scenarioToValidatingVideo;
+(id)scenarioToClose;
+(id)scenarioClickPlayerView;
+(id)scenarioTodismissPopOver;
+ (id)scenarioToWaitingTime:(int)time;
+ (id)scenarioToShowsTapped;
+ (id)scenarioToClickPlayerViewSwipe:(NSString *)direction;
+ (id)scenarioToAtoZrLeftScroll;
+ (id)scenarioToAtoZRightScroll;
+ (id)scenarioToTapHomeSegment;
+ (id)scenarioToScrollHomeTableDown;
+ (id)scenarioToScrollHomeTableUp;
+ (id)scenarioToScrollUpNextGridRight;
+ (id)scenarioToScrollUpNextGridLeft;
+ (id)scenarioToScrollFeaturedGridRight;
+ (id)scenarioToScrollFeaturedGridLeft;
+ (id)scenarioToScrollPopularShowsGridRight;
+ (id)scenarioToScrollPopularShowsGridLeft;
+ (id)scenarioToScrollPopularChannelsGridRight;
+ (id)scenarioToScrollPopularChannelsGridLeft;
+ (id)scenarioToScrollChannelsTableDown;
+ (id)scenarioToScrollChannelsTableUp;
+ (id)scenarioToTapSubscriptions;
+ (id)scenarioToTapRows;
+ (id)scenarioToTapChannels;
+ (id)scenarioToTapShows;
+ (id)scenarioToTapStoreSegment;
+ (id)scenarioToTapCellOfChannelsTableWithCellIndex:(NSIndexPath *) index scenario:(KIFTestScenario *) scenario;
+(id)scenarioRelatedContent;
+(id)scenarioClickSamePublisher;
+(id)scenarioClickSameCategory;
+(id)scenarioToMoveVideoSlider;
+(id)scenarioToWatchNext;
+(id)scenarioToLeftScrollWatchNext;
+(id)scenarioToRightScrollWatchNext;
+(id)scenarioToPlayWatchNextVideo;
+ (id)scenarioToClickPopularVideo:(NSString *)title;
+(id)scenarioToMoveVolumeSlider;
+ (id)scenarioToPlay_Pause;
+(id)scenarioClickPlayerView:(KIFTestScenario *)scenario;
+ (id)scenarioChannelsTableLooping;
+ (id)scenarioToTapCloseButton:(KIFTestScenario *)scenario;
+ (id)scenarioToScrollChannelsTableDownWithScenario:(KIFTestScenario *)scenario;
+(id)scenarioToentersearchbar;
+(id)scenarioTochannelsbtn;
+(id)scenarioToshowsbtn;
+(id)scenarioTovideosbtn;
+(id)scenarioToShowResult;
+ (id)scenarioToScrollSearchTableUp;
+ (id)scenarioToScrollSearchTableDown;
+(id)scenarioToBack;
@end
