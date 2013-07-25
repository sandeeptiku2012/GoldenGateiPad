//
//  FavoritesViewController.m
//  GoldenGate
//
//  Created by Andreas Petrov on 9/13/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "FavoritesViewController.h"

#import "NavAction.h"
#import "VimondStore.h"

#import "FavoriteVideoCellViewFactory.h"
#import "VideoCellView.h"

#import "FavoriteVideosDataFetcher.h"
#import "GGBackgroundOperationQueue.h"


@implementation FavoritesViewController

- (id)initWithNavAction:(NavAction *)navAction
{
    if((self = [super initWithNavAction:navAction]))
    {
        self.showEditButton = YES;
        
        [self registerName:NSLocalizedString(@"FavoritesLKey", @"")
                dataSource:[PrefetchingDataSource createWithDataFetcher:[FavoriteVideosDataFetcher new]]
           cellViewFactory:[[FavoriteVideoCellViewFactory alloc] initWithWantedCellSize:CellSizeLarge cellViewClass:[VideoCellView class]]
             enableEditing:YES];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (UIView*)createNoContentWarningView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"NoFavoritesView" owner:nil options:nil]objectAtIndex:0];
}

- (void)gridViewController:(GridViewController *)gridViewController processDeletionOfObject:(NSObject *)object
{
    [super gridViewController:gridViewController processDeletionOfObject:object];
    
    Video *videoAtIndex = (Video*)object;
    if (videoAtIndex)
    {
        [[GGBackgroundOperationQueue sharedInstance]addOperationWithBlock:^
         {
             NSError*error;
             [[VimondStore favoriteStore] removeFromFavorites:videoAtIndex error:&error];
             self.dataSource.dataDirty = YES;
         }];
    }
}

@end
