//
//  NewVideosForUserViewController.m
//  GoldenGate
//
//  Created by Andreas Petrov on 9/23/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "NewVideosForUserViewController.h"

#import "NewVideosForUserDataFetcher.h"
#import "VideoCellView.h"
#import "FavoriteVideoCellViewFactory.h"

@interface NewVideosForUserViewController ()

@end

@implementation NewVideosForUserViewController

- (id)initWithNavAction:(NavAction *)navAction
{
    if ((self = [super initWithNavAction:navAction]))
    {
        [self registerName:NSLocalizedString(@"NewVideosForSubscribtionsLKey", @"")
                dataSource:[PrefetchingDataSource createWithDataFetcher:[NewVideosForUserDataFetcher new]]
           cellViewFactory:[[FavoriteVideoCellViewFactory alloc] initWithWantedCellSize:CellSizeLarge cellViewClass:[VideoCellView class]]
         enableEditing:NO];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView*)createNoContentWarningView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"NoNewVideosView" owner:nil options:nil]objectAtIndex:0];
}

@end
