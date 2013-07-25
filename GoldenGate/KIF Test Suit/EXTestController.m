//
//  EXTestController.m
//  Testable
//
//  Created by Eric Firestone on 6/3/11.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "EXTestController.h"
#import "KIFTestScenario+EXAdditions.h"
#import "KIFTestStep.h"


@implementation EXTestController

- (void)initializeScenarios;
{
    // If your app is doing anything interesting with parameterized scenarios,
    // you'll want to override this method and add them manually.
//    [self addScenario:[KIFTestScenario scenarioToLogin]];
//    [self addScenario:[KIFTestScenario scenarioToSelectDifferentChannels]];
//    [self addScenario:[KIFTestScenario scenarioToSelectDifferentChannelsback]];
    
  

    /* -------------------------------- Test Case ------------------------*/
    
#pragma mark Test Cases Starts
  #pragma
#pragma mark - LoginTestCase 28/06/13
    NSDictionary *DForCredentials = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"KIFPropertyList" ofType:@"plist"]];

    
  /*  [self addScenario:[KIFTestScenario  scenarioToCommonLoginCredential:[DForCredentials valueForKey:@"Invaliduser"] Password:[DForCredentials valueForKey:@"Invalidpassword"]]];
    
    [self addScenario:[KIFTestScenario scenarioToSignInButtonClick]];
    [self addScenario:[KIFTestScenario scenarioToinValidLogin]];
    
    [self addScenario:[KIFTestScenario scenarioToClearTextField]];
    
    [self addScenario:[KIFTestScenario  scenarioToCommonLoginCredential:[DForCredentials valueForKey:@"Vusername"] Password:[DForCredentials valueForKey:@"Invalidpassword"]]];
    
    [self addScenario:[KIFTestScenario scenarioToSignInButtonClick]];
    [self addScenario:[KIFTestScenario scenarioToinValidLogin]];
    
    
    [self addScenario:[KIFTestScenario scenarioToClearTextField]];

    
    
    [self addScenario:[KIFTestScenario  scenarioToCommonLoginCredential:[DForCredentials valueForKey:@"Invaliduser"] Password:[DForCredentials valueForKey:@"Vpassword"]]];
    
    [self addScenario:[KIFTestScenario scenarioToSignInButtonClick]];
    [self addScenario:[KIFTestScenario scenarioToinValidLogin]];

    
    [self addScenario:[KIFTestScenario scenarioToClearTextField]];

    
    [self addScenario:[KIFTestScenario  scenarioToCommonLoginCredential:@"" Password:@""]];
    
    [self addScenario:[KIFTestScenario scenarioToSignInButtonClick]];
    [self addScenario:[KIFTestScenario scenarioToinValidLogin]];
    
    
    */

    [self addScenario:[KIFTestScenario  scenarioToCommonLoginCredential:[DForCredentials valueForKey:@"Vusername"] Password:[DForCredentials valueForKey:@"Vpassword"]]];    
    [self addScenario:[KIFTestScenario scenarioToentersearchbar]];
    
    //[self addScenario:[KIFTestScenario scenarioToshowsbtn]];
   // [self addScenario:[KIFTestScenario scenarioTovideosbtn]];
    //[self addScenario:[KIFTestScenario scenarioTochannelsbtn]];
     [self addScenario:[KIFTestScenario scenarioToShowResult]];
    
    //[self addScenario:[KIFTestScenario scenarioToScrollSearchTableDown]];
    //[self addScenario:[KIFTestScenario scenarioToScrollSearchTableUp]];
   [self addScenario:[KIFTestScenario scenarioToBack]];
      
    
/*
#pragma Featured
    [self addScenario:[KIFTestScenario scenarioToFeaturedLeftScroll]];
    
    
     [self addScenario:[KIFTestScenario scenarioToFeaturedRightScroll]];
    
#pragma popular
    [self addScenario:[KIFTestScenario scenarioToPopularLeftScroll]];
    
    [self addScenario:[KIFTestScenario scenarioToPopularRightScroll]];
    //MainView Table scroll Up
    [self addScenario:[KIFTestScenario scenarioToPopularVideoScrollUp]];

#pragma AtoZ
    //AtoZ
    [self addScenario:[KIFTestScenario scenarioToAtoZrLeftScroll]];
        
    [self addScenario:[KIFTestScenario scenarioToAtoZRightScroll]];
    //MainView Table scroll Down

    [self addScenario:[KIFTestScenario scenarioToPopularVideoScrollDown]];
    
#pragma HomeTab
    //Home Segment Tap
    [self addScenario:[KIFTestScenario scenarioToTapHomeSegment]];
    //Home Table Scroll
    [self addScenario:[KIFTestScenario scenarioToScrollHomeTableDown]];
    
    [self addScenario:[KIFTestScenario scenarioToScrollHomeTableUp]];
    
    //Up Next Grid
    [self addScenario:[KIFTestScenario scenarioToScrollUpNextGridRight]];
    
    
    [self addScenario:[KIFTestScenario scenarioToScrollUpNextGridLeft]];
    
    //Featured Grid
    [self addScenario:[KIFTestScenario scenarioToScrollFeaturedGridRight]];
    
    
    [self addScenario:[KIFTestScenario scenarioToScrollFeaturedGridLeft]];
    
    //Popular Shows
    [self addScenario:[KIFTestScenario scenarioToScrollPopularShowsGridRight]];
            
    [self addScenario:[KIFTestScenario scenarioToScrollPopularShowsGridLeft]];
    
    [self addScenario:[KIFTestScenario scenarioToScrollHomeTableDown]];
    
    //Popular Channels
    [self addScenario:[KIFTestScenario scenarioToScrollPopularChannelsGridRight]];
        
    [self addScenario:[KIFTestScenario scenarioToScrollPopularChannelsGridLeft]];
    
    [self addScenario:[KIFTestScenario scenarioToScrollHomeTableUp]];
    
#pragma Subscriptions
    //Home Segment Tap
    [self addScenario:[KIFTestScenario scenarioToTapSubscriptions]];
     [self addScenario:[KIFTestScenario scenarioToTapShows]];
    
    [self addScenario:[KIFTestScenario scenarioToTapChannels]];
    
    [self addScenario:[KIFTestScenario scenarioToTapRows]];
    
     [self addScenario:[KIFTestScenario scenarioToTapSubscriptions]];
    
    
#pragma mark FeaturedSelection
    [self addScenario:[KIFTestScenario scenarioToFeaturedTapped]];
        
    
   [self addScenario:[KIFTestScenario scenarioRelatedContent]];
    
    
    [self addScenario:[KIFTestScenario scenarioClickSamePublisher]];
    
    
    [self addScenario:[KIFTestScenario scenarioClickSameCategory]];
    
    [self addScenario:[KIFTestScenario scenarioToClose]];
    
    [self addScenario:[KIFTestScenario scenarioToPopularVideoScrollUp]];
    
    [self addScenario:[KIFTestScenario scenarioToPopularVideoScrollDown]];
    
    
    [self addScenario:[KIFTestScenario scenarioToClickPopularVideo:@"EntityModal"]];
    
    
    [self addScenario:[KIFTestScenario scenarioToClickSubPopularVideo]];
        
    //Volume Slider Start
    
    
    [self addScenario:[KIFTestScenario scenarioToMoveVolumeSlider]];
    
    //Volume Slider End
    
    // Video Slider Start

    [self addScenario:[KIFTestScenario scenarioToMoveVideoSlider]];
    
    [self addScenario:[KIFTestScenario scenarioToPlay_Pause]];
    
    [self addScenario:[KIFTestScenario scenarioToClickPlayerViewSwipe:@"Right"]];
    
    
     [self addScenario:[KIFTestScenario scenarioToClickPlayerViewSwipe:@"Right"]];
        
    
    
    // Video Watch Next
    
    
    [self addScenario:[KIFTestScenario scenarioClickPlayerView]];
    
    [self addScenario:[KIFTestScenario scenarioToWatchNext]];
    
    
    [self addScenario:[KIFTestScenario scenarioToRightScrollWatchNext]];
    
    
    [self addScenario:[KIFTestScenario scenarioToLeftScrollWatchNext]];
    
    
    //    Play WatchNext Video
  
    [self addScenario:[KIFTestScenario scenarioToPlayWatchNextVideo]];
    
    //close the watch next video    
    [self addScenario:[KIFTestScenario scenarioClickPlayerView]];
    
    
    [self addScenario:[KIFTestScenario scenarioToWatchNext]];
    
    [self addScenario:[KIFTestScenario scenarioToClickPlayerViewSwipe:@"Right"]];
  
    
   // [self addScenario:[KIFTestScenario scenarioToWaitingTime:15]];
    
    [self addScenario:[KIFTestScenario scenarioClickPlayerView]];
    
    
    
    [self addScenario:[KIFTestScenario scenarioToClickPlayerViewSwipe:@"Left"]];
    
   // [self addScenario:[KIFTestScenario scenarioToWaitingTime:15]];
    
    [self addScenario:[KIFTestScenario scenarioClickPlayerView]];
    
  //  [self addScenario:[KIFTestScenario scenarioToWaitingTime:5]];
    
    
    [self addScenario:[KIFTestScenario scenarioToClickPlayerViewSwipe:@"Right"]];
    
   // [self addScenario:[KIFTestScenario scenarioToWaitingTime:15]];
    
    [self addScenario:[KIFTestScenario scenarioClickPlayerView]];
    
    [self addScenario:[KIFTestScenario scenarioToClose]];
    
     [self addScenario:[KIFTestScenario scenarioToShowsTapped]];
    
    [self addScenario:[KIFTestScenario scenarioTodismissPopOver]]; */
 /**************************************************************/
 /*
     #pragma  Channels Table
    [self addScenario:[KIFTestScenario scenarioToWaitingTime:4]];
    //Tap Channels Button
    [self addScenario:[KIFTestScenario scenarioToClose]];
    [self addScenario:[KIFTestScenario scenarioToWaitingTime:2]];
    //Channels Table Scroll
    [self addScenario:[KIFTestScenario scenarioToScrollChannelsTableDown]];
    [self addScenario:[KIFTestScenario scenarioToWaitingTime:2]];
    [self addScenario:[KIFTestScenario scenarioToScrollChannelsTableUp]];
    [self addScenario:[KIFTestScenario scenarioToWaitingTime:3]]; */
    
    //[self addScenario:[KIFTestScenario scenarioChannelsTableLooping]];
//    for (int index=0; index<13; index++) {
//        if (index >= 11) {
//            [self addScenario:[KIFTestScenario scenarioToScrollChannelsTableDown]];
//            [self addScenario:[KIFTestScenario scenarioToWaitingTime:2]];
//        }
//        
//        [self addScenario:[KIFTestScenario scenarioToTapCellOfChannelsTableWithCellIndex:[NSIndexPath indexPathForRow:index inSection:1]]];
//        if (index == 0)
//            continue;
//        //Tap Channels Button
//        [self addScenario:[KIFTestScenario scenarioToClose]];
//        [self addScenario:[KIFTestScenario scenarioToWaitingTime:2]];
//    }
/******************************************************************/
    
}

@end
