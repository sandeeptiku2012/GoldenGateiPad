//
//  SubscriptionsViewController.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 10/07/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "SubscriptionsViewController.h"
#import "CategoryAction.h"
#import "ContentCategory.h"
#import "GGSegmentedControl.h"

#import "RowsSubscriptionViewController.h"
#import "ChannelsSubscriptionViewController.h"
#import "ShowsSubscriptionsViewController.h"

#define SEGMENT_INDEX_ROWS 0
#define SEGMENT_INDEX_SHOWS 1
#define SEGMENT_INDEX_CHANNELS 2

@interface SubscriptionsViewController ()

@property (weak, nonatomic) IBOutlet GGSegmentedControl* segmentedControl;
@property (weak, nonatomic) IBOutlet UIView* viewContents;
@property (strong, nonatomic) ContentCategory *category;

@property (strong, nonatomic) RowsSubscriptionViewController* rowsController;
@property (strong, nonatomic) ChannelsSubscriptionViewController* channelsController;
@property (strong, nonatomic) ShowsSubscriptionsViewController* showsController;
@property (weak, nonatomic) BaseNavViewController* currentController;

-(IBAction)valueChangedForSegmentControl:(id)sender;

@end

@implementation SubscriptionsViewController

- (id)initWithNavAction:(NavAction *)navAction
{
    if ((self = [super initWithNavAction:navAction]))
    {
        CategoryAction *categoryAction = (CategoryAction *)navAction.parentAction;
        self.category = categoryAction.category;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]]];
    [self setUpSegmentedControl];
    [self setUpControllers];
    [self addViewFromController:self.rowsController];
    
    NSArray *subViews = [self.segmentedControl subviews];
    NSLog(@"SegmentController subViews = %@", [subViews description]);
    for (int i=0; i<[self.segmentedControl numberOfSegments]; i++) {
        NSString *title = [self.segmentedControl titleForSegmentAtIndex:i];
        if ([title isEqualToString:@"Channels"]) {
            ((UIImageView *)[[self.segmentedControl subviews] objectAtIndex:0]).accessibilityLabel = @"Channels Btn";
        }else  if ([title isEqualToString:@"Shows"]) {
            ((UIImageView *)[[self.segmentedControl subviews] objectAtIndex:1]).accessibilityLabel = @"Shows Btn";
        }else  if ([title isEqualToString:@"Rows"]) {
            ((UIImageView *)[[self.segmentedControl subviews] objectAtIndex:2]).accessibilityLabel = @"Rows Btn";
        }
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpControllers
{
    if (nil==self.rowsController) {
        self.rowsController = [[RowsSubscriptionViewController alloc]initWithCategory:self.category];
        self.rowsController.custParentNavigationController = self.navigationController;
    }
    if (nil==self.showsController) {
        self.showsController = [[ShowsSubscriptionsViewController alloc]initWithCategory:self.category];
        self.showsController.custParentNavigationController = self.navigationController;
    }
    if (nil==self.channelsController) {
        self.channelsController = [[ChannelsSubscriptionViewController alloc]initWithCategory:self.category];
        self.channelsController.custParentNavigationController = self.navigationController;
    }
    
}

- (void) setUpSegmentedControl
{
    [self.segmentedControl setTitle:NSLocalizedString(@"RowsLKey", @"") forSegmentAtIndex:SEGMENT_INDEX_ROWS];
    [self.segmentedControl setTitle:NSLocalizedString(@"ShowsLKey", @"") forSegmentAtIndex:SEGMENT_INDEX_SHOWS];
    [self.segmentedControl setTitle:NSLocalizedString(@"ChannelsLKey", @"") forSegmentAtIndex:SEGMENT_INDEX_CHANNELS];
}


-(void)addViewFromController:(BaseNavViewController*)navController
{
    if (navController != self.currentController) {
        [self.currentController.view removeFromSuperview];
        [self.viewContents addSubview:navController.view];
        self.currentController = navController;
    }
}

-(IBAction)valueChangedForSegmentControl:(id)sender
{
    NSLog(@"Did select segment at index %d", self.segmentedControl.selectedSegmentIndex);
    int indexTapped = self.segmentedControl.selectedSegmentIndex;
    BaseNavViewController* nextNavController = nil;
    switch (indexTapped) {
        case SEGMENT_INDEX_ROWS:
            nextNavController = self.rowsController;
            break;
        case SEGMENT_INDEX_SHOWS:
            nextNavController = self.showsController;
            break;
        case SEGMENT_INDEX_CHANNELS:
            nextNavController = self.channelsController;
            break;
            
        default:
            break;
    }
    
    [self addViewFromController:nextNavController];
}

@end
