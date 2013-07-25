//
//  KIFTestScenario+EXAdditions.m
//  Testable
//
//  Created by Eric Firestone on 6/12/11.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "KIFTestScenario+EXAdditions.h"
#import "KIFTestStep.h"
#import "KIFTestStep+EXAdditions.h"


#if TARGET_IPHONE_SIMULATOR
NSString * const DeviceMode = @"Simulator";
#else
NSString * const DeviceMode = @"Device";
#endif

#define kUserName @"test_151"
#define kPassword @"Demo1111"

@implementation KIFTestScenario (EXAdditions)

/* ------------------------------ Test Cases ------------------------------ */



#pragma mark - StartTestCase 05/07/13
#pragma mark User Authentication
+ (id)scenarioToCommonLoginCredential:(NSString *)userName Password:(NSString *)password{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"User Authentication"];
    //Username
    [scenario addStep:[KIFTestStep stepToEnterText:userName intoViewWithAccessibilityLabel:@"username"]];
    //Password
    [scenario addStep:[KIFTestStep stepToEnterText:password intoViewWithAccessibilityLabel:@"password"]];
    
    [self scenarioToSignInButtonClick:scenario];
    
    [self scenarioToWaitingTime:3 common:scenario];

    return scenario;
}
#pragma mark -
#pragma mark ToSignInButton

+ (id)scenarioToWaitingTime:(int)time common:(KIFTestScenario *)scenario {
    
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:time description:@"An arbitrary wait just to demonstrate adding an additional step"]];
    
    return scenario;
}

+ (id)scenarioToSignInButtonClick:(KIFTestScenario *)scenario{
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"signin"]];
    
    return scenario;
}
#pragma mark -
#pragma mark ToinValidLoginPopup
+ (id)scenarioToinValidLogin{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Unable to sign in"];
    
    [scenario addStep:[KIFTestStep stepToDismissAlertWithLabel:@"Unable to sign in"]];
    
    return scenario;
}
#pragma mark -
#pragma mark ToClearTextField
+ (id)scenarioToClearTextField{
     KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Clear TextField Text"];

    [scenario addStep:[KIFTestStep stepToEnterText:@"" intoViewWithAccessibilityLabel:@"username"]];

    [scenario addStep:[KIFTestStep stepToEnterText:@"" intoViewWithAccessibilityLabel:@"password"]];
    return scenario;
}

#pragma mark -
#pragma mark Featured LeftScroll
+ (id)scenarioToFeaturedLeftScroll{
     KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Featured LeftScroll"];
    
    for (int i=0; i<4; i++) {
        //swape the feature grid left
        [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"Featured" inDirection:KIFSwipeDirectionLeft]];
        [self scenarioToWaitingTime:2 common:scenario];
    }
   
    
    return scenario;
}
#pragma mark -
#pragma mark Featured RightScroll
+ (id)scenarioToFeaturedRightScroll{
     KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"FeaturedRightScroll"];
    
    for (int i=0; i<4; i++) {
        //swape the feature grid right
        [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"Featured" inDirection:KIFSwipeDirectionRight]];
        [self scenarioToWaitingTime:2 common:scenario];
        
    }
       
    
    return scenario;
}
#pragma mark -
#pragma mark Featured Click
+ (id)scenarioToFeaturedTapped{
     KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Featured Click"];
    
     [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Featured"]];
    
    [self scenarioToWaitingTime:5 common:scenario];
    
    return scenario;
}
#pragma mark -
+ (id)scenarioToPopularLeftScroll{
     KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"PopularLeftScroll"];
    
    for (int i=0; i<2; i++) {
        
        [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"PopularView" inDirection:KIFSwipeDirectionLeft]];
        
        [self scenarioToWaitingTime:2 common:scenario];
    }
   
     return scenario;
}
#pragma mark -
+ (id)scenarioToPopularRightScroll{
     KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"PopularRightScroll"];
    
    for (int i=0; i<2; i++) {
        [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"PopularView" inDirection:KIFSwipeDirectionRight]];
        [self scenarioToWaitingTime:2 common:scenario];
    }
   
     return scenario;
}
#pragma mark -
#pragma mark  PopularSelection
+(id)scenarioToPopularSelection{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Scrolling  Popular"];
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"PopularVideo"]];
   
    return scenario;
}

#pragma mark -
+ (id)scenarioToAtoZrLeftScroll{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"AtoZLeftScroll"];
    
    for (int i=0; i<2; i++) {
        [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"AtoZ" inDirection:KIFSwipeDirectionLeft]];
        
        [self scenarioToWaitingTime:2 common:scenario];

    }
        
    
    return scenario;
}
#pragma mark -
+ (id)scenarioToAtoZRightScroll{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"AtoZRightScroll"];
    
    for (int i=0; i<2; i++) {
        [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"AtoZ" inDirection:KIFSwipeDirectionRight]];
        
        [self scenarioToWaitingTime:2 common:scenario];
    }
    
    
    return scenario;
}
#pragma mark -
#pragma mark  PopularVideoScrollUp
+(id)scenarioToPopularVideoScrollUp{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Scrolling  Popular"];
    
    //Swipe Entity Table DirectionUp
    [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"Entityvideo" inDirection:KIFSwipeDirectionUp]];
    
    [self scenarioToWaitingTime:2 common:scenario];
    
    return scenario;
}
#pragma mark -
#pragma mark  PopularVideoScrollDown
+(id)scenarioToPopularVideoScrollDown{
    //Swipe Entity Table DirectionDown
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Scrolling  Popular"];

    [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"Entityvideo" inDirection:KIFSwipeDirectionDown]];
    
    [self scenarioToWaitingTime:2 common:scenario];
    
    return scenario;
}
#pragma mark -
#pragma mark  ClickPopularVideo
+(id)scenarioToClickPopularVideo{
    //Swipe Entity Table videoPlay
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Scrolling  Popular"];

    //click on video
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"EntityModal"]];
    
    return scenario;
}
#pragma mark -
#pragma mark  ClickSubPopularVideo
+(id)scenarioToClickSubPopularVideo{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Scrolling  Popular"];

    //channel modal
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"ChannelModal"]];
    
    [self scenarioToWaitingTime:10 common:scenario];
    return scenario;
}
#pragma mark -
#pragma mark  ValidatingVideo
+(id)scenarioToValidatingVideo{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Popular video play"];
    return scenario;
}
#pragma mark -
#pragma mark Close
+(id)scenarioToClose{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Close Scenario"];
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Close"]];
    
    [self scenarioToWaitingTime:3 common:scenario];
    return scenario;
}
#pragma mark -
#pragma mark PlayerView
+(id)scenarioClickPlayerView{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Close Scenario"];
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"PlayerView"]];
    
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:5 description:@"An arbitrary wait just to demonstrate adding an additional step"]];

    
    return scenario;
    
}
+(id)scenarioClickPlayerView:(KIFTestScenario *)scenario{
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"PlayerView"]];
    
    [self scenarioToWaitingTime:5 common:scenario];
    
    return scenario;
    
}
#pragma mark -
#pragma mark PlayerViewSwipe
+(id)scenarioToClickPlayerViewSwipe:(NSString *)direction{
    
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"PlayerViewSwipe Scenario"];
    
    if([direction isEqualToString:@"Up"]){
        [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"PlayerView" inDirection:KIFSwipeDirectionUp]];
    }else if([direction isEqualToString:@"Down"]){
        [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"PlayerView" inDirection:KIFSwipeDirectionDown]];
    }else if([direction isEqualToString:@"Left"]){
        [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"PlayerView" inDirection:KIFSwipeDirectionLeft]];
    }else if([direction isEqualToString:@"Right"]){
        [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"PlayerView" inDirection:KIFSwipeDirectionRight]];
    }
    
    [self scenarioToWaitingTime:8 common:scenario];
    return scenario;
    
}


#pragma mark -
#pragma mark Waiting
+ (id)scenarioToWaitingTime:(int)time{
     KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"WaitingTime"];
    
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:time description:@"An arbitrary wait just to demonstrate adding an additional step"]];
    
    return scenario;
}
//Shows
#pragma mark -
#pragma mark Shows Tapped
+ (id)scenarioToShowsTapped{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Shows Tapped"];
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Shows"]];
    
    [self scenarioToWaitingTime:3 common:scenario];
    
    return scenario;
}
#pragma mark -
#pragma mark DismissPopOver
+ (id)scenarioTodismissPopOver{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Close Scenario"];
    
    [scenario addStep:[KIFTestStep stepToDismissPopover]];
    
    [self scenarioToWaitingTime:2 common:scenario];
    
    return scenario;
}

#pragma mark -
#pragma mark HomeSegment
+ (id)scenarioToTapHomeSegment
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Home Segment Tapped"];
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Home Btn"]];
    
     [self scenarioToWaitingTime:1 common:scenario];
    return scenario;
}

+ (id)scenarioToScrollHomeTableDown
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Home Table Scrolled"];
    
    [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"Home Table" inDirection:KIFSwipeDirectionUp]];
     [self scenarioToWaitingTime:2 common:scenario];
    
    return scenario;
}

+ (id)scenarioToScrollHomeTableUp
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Home Table Scrolled"];
    
    [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"Home Table" inDirection:KIFSwipeDirectionDown]];
     [self scenarioToWaitingTime:2 common:scenario];
    
    return scenario;
}

+ (id)scenarioToScrollUpNextGridRight
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Up Next Grid Scrolled"];
    
    for (int i=0; i<2; i++) {
        [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabelOne:@"Up Next Grid" inDirection:KIFSwipeDirectionLeft]];
        
        [self scenarioToWaitingTime:2 common:scenario];
    }
  
    
    return scenario;
}

+ (id)scenarioToScrollUpNextGridLeft
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Up Next Grid Scrolled"];
    
    for (int i=0; i<2; i++) {
        [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabelOne:@"Up Next Grid" inDirection:KIFSwipeDirectionRight]];
        
        [self scenarioToWaitingTime:2 common:scenario];
    }
    
    
    return scenario;
}

+ (id)scenarioToScrollFeaturedGridRight
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Featured Grid Scrolled"];
    
    for (int i=0; i<2; i++) {
        [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabelOne:@"Featured Grid" inDirection:KIFSwipeDirectionLeft]];
        
        [self scenarioToWaitingTime:2 common:scenario];
    }
    
    
    return scenario;
}

+ (id)scenarioToScrollFeaturedGridLeft
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Featured Grid Scrolled"];
    
    for (int i=0; i<2; i++) {
        [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabelOne:@"Featured Grid" inDirection:KIFSwipeDirectionRight]];
        
        [self scenarioToWaitingTime:2 common:scenario];
    }
    
    
    return scenario;
}

+ (id)scenarioToScrollPopularShowsGridRight
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Popular Shows Grid Scrolled"];
    
    for (int i=0; i<2; i++) {
        [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabelOne:@"Popular Shows Grid" inDirection:KIFSwipeDirectionLeft]];
        
        [self scenarioToWaitingTime:2 common:scenario];
    }
    
    
    return scenario;
}

+ (id)scenarioToScrollPopularShowsGridLeft
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Popular Shows Grid Scrolled"];
    
    for (int i=0; i<2; i++) {
        [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabelOne:@"Popular Shows Grid" inDirection:KIFSwipeDirectionRight]];
        
        [self scenarioToWaitingTime:2 common:scenario];
    }
    
    return scenario;
}

+ (id)scenarioToScrollPopularChannelsGridRight
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Popular Channels Grid Scrolled"];
    
    for (int i=0; i<2; i++) {
        [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabelOne:@"Popular Channels Grid" inDirection:KIFSwipeDirectionLeft]];
        
        [self scenarioToWaitingTime:2 common:scenario];
    }
   
    return scenario;
}

+ (id)scenarioToScrollPopularChannelsGridLeft
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Popular Channels Grid Scrolled"];
    
    for (int i=0; i<2; i++) {
        [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabelOne:@"Popular Channels Grid" inDirection:KIFSwipeDirectionRight]];
        
        [self scenarioToWaitingTime:2 common:scenario];
    }
    
    
    return scenario;
}

+ (id)scenarioToScrollChannelsTableDown
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Channels Table Scrolled Up"];
    
    [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"Channels Table" inDirection:KIFSwipeDirectionUp]];
    
    return scenario;
}

+ (id)scenarioToScrollChannelsTableDownWithScenario:(KIFTestScenario *)scenario
{
    [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"Channels Table" inDirection:KIFSwipeDirectionUp]];
    
    return scenario;
}

+ (id)scenarioChannelsTableLooping
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Channels Table Looping"];
    
    for (int index=0; index<13; index++) {
//        if (index >= 11) {
//            [self scenarioToScrollChannelsTableDownWithScenario:scenario];
//            [self scenarioToWaitingTime:2];
//        }
        
        [self scenarioToTapCellOfChannelsTableWithCellIndex:[NSIndexPath indexPathForRow:index inSection:0] scenario:scenario];
//        if (index == 0)
//            continue;
        //Tap Channels Button
        [self scenarioToTapCloseButton:scenario];
        [self scenarioToWaitingTime:4];
    }
    
    return scenario;
}

+ (id)scenarioToTapCloseButton:(KIFTestScenario *)scenario
{
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Close"]];
    
    [self scenarioToWaitingTime:3 common:scenario];
    return scenario;
}

+ (id)scenarioToScrollChannelsTableUp
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Channels Table Scrolled"];
    
    [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"Channels Table" inDirection:KIFSwipeDirectionDown]];
    
    return scenario;
}

+ (id)scenarioToTapCellOfChannelsTableWithCellIndex:(NSIndexPath *) index scenario:(KIFTestScenario *) scenario
{
    [self scenarioWithDescription:[NSString stringWithFormat:@"ChannelsTable Cell With Section(%d) & Row(%d)", index.section, index.row]];
    
//    if (index.section == 0) {
//        [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:2 description:@"An arbitrary wait just to demonstrate adding an additional step"]];
//        return scenario;
//    }
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:[NSString stringWithFormat:@"ChannelsTable Cell With Section(%d) & Row(%d)", index.section, index.row]]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:3 description:@"An arbitrary wait just to demonstrate adding an additional step"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Back Button"]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:2 description:@"An arbitrary wait just to demonstrate adding an additional step"]];
    
    return scenario;
}
+ (id)scenarioToPlay_Pause
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Play Or Pause Video"];
    
    [self scenarioClickPlayerView:scenario];

    
    for (int i=0; i<2; i++) {
        
        [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Play&Pause"]];
        
        [self scenarioToWaitingTime:8 common:scenario];
    }
    
    
    return scenario;
}

+ (id)scenarioToTapStoreSegment
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Store Segment Tapped"];
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Store Btn"]];
    
    return scenario;
}

#pragma Subscription
+ (id)scenarioToTapSubscriptions
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Subscriptions Tapped"];
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Subscriptions Btn"]];
      [self scenarioToWaitingTime:2 common:scenario];
    return scenario;
}

#pragma Rows
+ (id)scenarioToTapRows
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Rows Tapped"];
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Rows Btn"]];
    [self scenarioToWaitingTime:4 common:scenario];
    return scenario;
}

#pragma Channels
+ (id)scenarioToTapChannels
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Channels Tapped"];
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Channels Btn"]];
    [self scenarioToWaitingTime:4 common:scenario];
    return scenario;
}

#pragma Shows
+ (id)scenarioToTapShows
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Shows Tapped"];
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Shows Btn"]];
    [self scenarioToWaitingTime:4 common:scenario];
    return scenario;
}

#pragma mark RelatedContent
+(id)scenarioRelatedContent{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"RelatedContent Scenario"];
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"RelatedContent"]];
    
    [self scenarioToWaitingTime:5 common:scenario];
    
    return scenario;
}
#pragma mark SamePublisher
+(id)scenarioClickSamePublisher{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"SamePublisher Scenario"];
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Publisher"]];
    
    [self scenarioToWaitingTime:5 common:scenario];
    
    return scenario;
    
}
#pragma mark SameCategory
+(id)scenarioClickSameCategory{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"SameCategory Scenario"];
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"category"]];
    
    [self scenarioToWaitingTime:5 common:scenario];
    
    return scenario;
    
}
#pragma mark -
#pragma mark  ClickPopularVideo
+ (id)scenarioToClickPopularVideo:(NSString *)title{
    //Swipe Entity Table videoPlay
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Scrolling  Popular"];
    
    //click on video
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:title]];
    
    [self scenarioToWaitingTime:2 common:scenario];
    //@"PopularEntityModal"
    return scenario;
}
#pragma mark -
#pragma mark  ClickSubPopularVideo
#pragma mark VolumeSlider
+(id)scenarioToMoveVolumeSlider{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"MoveVolumeSlider Scenario"];
    
    for (int i=0; i<3; i++) {
        
        [self scenarioClickPlayerView:scenario];
        
        [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"volumeSlider"]];
        
        [self scenarioToWaitingTime:8 common:scenario];
    }
    
    return scenario;
    
}
#pragma mark -
#pragma mark VideoSlider
+(id)scenarioToMoveVideoSlider{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"MoveVideoSlider Scenario"];
    
    
    for (int i=0; i<4; i++) {
        [self scenarioClickPlayerView:scenario];
        [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"videoSlider"]];
        [self scenarioToWaitingTime:8 common:scenario];
    }
    
    return scenario;
}
#pragma mark -
#pragma mark WatchNext
+(id)scenarioToWatchNext{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"WatchNext Scenario"];
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"watchnext"]];
    
    return scenario;
}
#pragma mark -
#pragma mark LeftScrollWatchNext
+(id)scenarioToLeftScrollWatchNext{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"LeftScrollWatchNext Scenario"];
    
    
    for (int i=0; i<2; i++) {
        
        [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"videoplayer" inDirection:KIFSwipeDirectionLeft]];
        
        [self scenarioToWaitingTime:3 common:scenario];
    }
    
    
    return scenario;
}
#pragma mark -
#pragma mark RightScrollWatchNext
+(id)scenarioToRightScrollWatchNext{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"RightScrollWatchNext Scenario"];
    
    for (int i=0; i<2; i++) {
        [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"videoplayer" inDirection:KIFSwipeDirectionRight]];
        
        [self scenarioToWaitingTime:3 common:scenario];
    }
    
    
    return scenario;
}
#pragma mark -
#pragma mark PlayWatchNextVideo
+(id)scenarioToPlayWatchNextVideo{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"PlayWatchNextVideo Scenario"];
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"scrollvideo"]];
    
    [self scenarioToWaitingTime:15 common:scenario];
    
    return scenario;
}


#pragma 
#pragma mark searchbar

+(id)scenarioToentersearchbar{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"PlayWatchNextVideo Scenario"];
    
    [scenario addStep:[KIFTestStep stepToEnterText:@"Life" intoViewWithAccessibilityLabel:@"searchbar"]];
    
    [self scenarioToWaitingTime:5 common:scenario];
    
    return scenario;
}

+(id)scenarioTochannelsbtn{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Channel Button Scenario"];
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Channels Btn"]];
    
    [self scenarioToWaitingTime:5 common:scenario];
    
       
    return scenario;
}

+(id)scenarioToshowsbtn{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Shows Button Scenario"];
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Shows Btn"]];
    
    [self scenarioToWaitingTime:5 common:scenario];
    
    return scenario;
}

+(id)scenarioTovideosbtn{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Videos Button Scenario"];
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Videos Btn"]];
    
    [self scenarioToWaitingTime:5 common:scenario];
    
    return scenario;
}

+(id)scenarioToShowResult{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Show Result Scenario"];
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Show Result"]];
    
    [self scenarioToWaitingTime:5 common:scenario];
    
    return scenario;
}

+ (id)scenarioToScrollSearchTableUp
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Search Table Table Scrolled"];
    
    [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"Search Table" inDirection:KIFSwipeDirectionDown]];
     [self scenarioToWaitingTime:3 common:scenario];
    
    return scenario;
}

+ (id)scenarioToScrollSearchTableDown
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Search Table Table Scrolled Up"];
    
    [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"Search Table" inDirection:KIFSwipeDirectionUp]];
     [self scenarioToWaitingTime:3 common:scenario];
    
    return scenario;
}

+(id)scenarioToBack{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Backt Scenario"];
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Backbtn"]];
    
    [scenario addStep:[KIFTestStep stepToTapScreenAtPoint:CGPointMake(10, 10)]];
    
    [self scenarioToWaitingTime:5 common:scenario];
    
    return scenario;
}



@end
