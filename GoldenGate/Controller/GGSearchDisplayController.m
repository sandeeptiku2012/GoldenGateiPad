//
//  GGSearchDisplayController.m
//  GoldenGate
//
//  Created by Andreas Petrov on 10/4/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "GGSearchDisplayController.h"
#import "GGPopoverBackgroundView.h"
#import "SearchResultTableViewController.h"
#import "GlobalSearchModel.h"
#import "GGSegmentedControl.h"
#import "Constants.h"
#import "MainSearchResultViewController.h"
#import "SearchResultViewController.h"
#import "GGUsageTracker.h"

#define kMinimumCharactersForSearch 2
#define kSearchDelay 0.5
#define kFadeInTimeInterval 0.2
#define kPopoverSize CGSizeMake(320,310)

#define kSearchBarWidthExpanded 300
#define kSearchBarAnimationDuration 0.3

@interface GGSearchDisplayController()

@property (strong, nonatomic) UIPopoverController *searchResultPopover;
@property (strong, nonatomic) SearchResultTableViewController *searchResultTableViewController;
@property (strong, nonatomic) GGSegmentedControl *searchScopeSegmentedControl;
@property (strong, nonatomic) NSTimer *searchDelayTimer;
@property (strong, nonatomic) UIView *tapToDismissView;
@property (strong, nonatomic) NSOperation *fullSearchOperation;
@property (assign, nonatomic) CGFloat initalSearchBarWidth;

@end

@implementation GGSearchDisplayController

- (id)initWithSearchBar:(UISearchBar *)searchBar contentsController:(UIViewController *)viewController
{
    // assign last used search string to the search bar BEFORE calling super initWithSearchBar:contentsController
    // this will prevent the searchBar:textDidChange: method from firing.
    searchBar.text = [GlobalSearchModel sharedInstance].lastUsedSearchString;
   
    ;
    if ((self = [super initWithSearchBar:searchBar contentsController:viewController]))
    {
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(dismissPopover)
                                                    name:kNotificationDismissSearchPopover object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(executeFullSearch)
                                                    name:kNotificationShowAllSearchResults object:nil];

        self.initalSearchBarWidth = searchBar.frame.size.width;
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - UISearchDisplayDelegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{

}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{

}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{

}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{

}

- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView
{

}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{

}

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{

}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView
{

}

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView
{

}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    return NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    return NO;
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog( @"%@" , NSStringFromSelector(_cmd));
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self expandSearchBar];
    [self showTapToDismissView];
    [self scheduleNewSearch];
}


- (void)expandSearchBar
{
    [self animateSearchBarToWidth:kSearchBarWidthExpanded];
}

- (void)animateSearchBarToWidth:(CGFloat)width
{
    [UIView animateWithDuration:kSearchBarAnimationDuration
                     animations:^
    {
        CGRect frame = self.searchBar.frame;
        frame.size.width = width;
        self.searchBar.frame = frame;
        [self.searchBar layoutIfNeeded];
    }];
}

- (void)contractSearchBar
{
    [self animateSearchBarToWidth:self.initalSearchBarWidth];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self contractSearchBar];
    [self.searchResultPopover dismissPopoverAnimated:YES];
    [self hideTapToDismissView];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self scheduleNewSearch];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog( @"%@" , NSStringFromSelector(_cmd));
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self executeFullSearch];
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
    NSLog( @"%@" , NSStringFromSelector(_cmd));
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog( @"%@" , NSStringFromSelector(_cmd));
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar
{
    NSLog( @"%@" , NSStringFromSelector(_cmd));
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    NSLog( @"%@" , NSStringFromSelector(_cmd));
}

- (void)presentResultPopoverFromView:(UIView*)view
{
    if (view.window != nil)
    {
        [self.searchResultPopover presentPopoverFromRect:view.bounds inView:view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

// Used to delay search a bit so that a user can type comfortably without the search kicking in immediately.
- (void)scheduleNewSearch
{
    if (self.searchBar.text.length >= kMinimumCharactersForSearch)
    {
        [self.searchDelayTimer invalidate];
        
        self.searchDelayTimer = [NSTimer scheduledTimerWithTimeInterval:kSearchDelay
                                                                 target:self
                                                               selector:@selector(executeSearch)
                                                               userInfo:nil
                                                                repeats:NO];
    }
}

- (void)ensurePopoverVisible
{
    if (!self.searchResultPopover.isPopoverVisible)
    {
        [self presentResultPopoverFromView:self.searchBar];
    }
}

- (void)executeSearch
{
    
    [self ensurePopoverVisible];
    
    [self.searchResultTableViewController showLoadingIndicator];
    GlobalSearchModel *globalSearchModel = [GlobalSearchModel sharedInstance];
    [self updateNewSearchForGA:self.searchBar.text];
    [[GlobalSearchModel sharedInstance] executePreviewSearchWithString:self.searchBar.text
                                                        forSearchScope:globalSearchModel.currentSearchBarSearchScope
                                                        successHandler:^(NSUInteger totalObjectCount)
    {
        [self.searchResultTableViewController showSearchResults];
    }
    errorHandler:^(NSError *error)
    {
        [self.searchResultTableViewController showError];
    }];
}

- (void)showTapToDismissView
{
    [self.searchContentsController.view addSubview:self.tapToDismissView];
    [self.searchContentsController.view bringSubviewToFront:self.tapToDismissView];
    
    self.tapToDismissView.alpha = 0;
    
    [UIView animateWithDuration:kFadeInTimeInterval
                     animations:^
    {
        self.tapToDismissView.alpha = kDimmingViewAlpha;
    }];
}

- (void)hideTapToDismissView
{
    [UIView animateWithDuration:kFadeInTimeInterval
                     animations:^
     {
         self.tapToDismissView.alpha = 0;
     }
     completion:^(BOOL finished)
     {
         [_tapToDismissView removeFromSuperview];
     }];
}

#pragma mark - Properties

- (UIView*)tapToDismissView
{
    if (_tapToDismissView == nil)
    {
        _tapToDismissView = [[UIView alloc]initWithFrame:self.searchContentsController.view.bounds];
        _tapToDismissView.backgroundColor = [UIColor blackColor];
        _tapToDismissView.alpha = 0;
        
        UITapGestureRecognizer *tapGestureRecog = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToDismissViewTapped)];
        [_tapToDismissView addGestureRecognizer:tapGestureRecog];
    }
    
    return _tapToDismissView;
}

- (UIPopoverController*)searchResultPopover
{
    if (_searchResultPopover == nil)
    {
        self.searchResultTableViewController = [[SearchResultTableViewController alloc]initWithStyle:UITableViewStylePlain];
        self.searchResultTableViewController.mainNavigationController = self.searchContentsController.navigationController;
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:self.searchResultTableViewController];
        self.searchResultsDataSource = self.searchResultTableViewController;
        self.searchResultsDelegate = self.searchResultTableViewController;
        self.searchResultTableViewController.navigationItem.titleView = self.searchScopeSegmentedControl;
        
        
        
        _searchResultPopover = [[UIPopoverController alloc]initWithContentViewController:navController];
        _searchResultPopover.passthroughViews = @[self.searchBar, self.tapToDismissView];
        _searchResultPopover.popoverBackgroundViewClass = [GGPopoverBackgroundView class];
        _searchResultPopover.popoverContentSize = kPopoverSize;
        
    }
    
    return _searchResultPopover;
}

- (GGSegmentedControl*)searchScopeSegmentedControl
{
    if (_searchScopeSegmentedControl == nil)
    {
        _searchScopeSegmentedControl = [[GGSegmentedControl alloc]initWithItems:@[NSLocalizedString(@"ChannelsLKey",@"") ,NSLocalizedString(@"ShowsLKey", @""), NSLocalizedString(@"VideosLKey", @"")]];
        
       
        
        for (int i=0; i < [_searchScopeSegmentedControl numberOfSegments]; i++) {
            NSString *title=[_searchScopeSegmentedControl titleForSegmentAtIndex:i];
            if([title isEqualToString:@"Channels"]){
              ((UIImageView *)[[_searchScopeSegmentedControl subviews] objectAtIndex:0]).accessibilityLabel = @"Channels Btn";
            }else if([title isEqualToString:@"Shows"]){
                 ((UIImageView *)[[_searchScopeSegmentedControl subviews] objectAtIndex:1]).accessibilityLabel = @"Shows Btn";
            }else if([title isEqualToString:@"Videos"]){
                 ((UIImageView *)[[_searchScopeSegmentedControl subviews] objectAtIndex:2]).accessibilityLabel = @"Videos Btn";
            }
        }
        
        
        [_searchScopeSegmentedControl addTarget:self action:@selector(didSelectSegment) forControlEvents:UIControlEventValueChanged];
        _searchScopeSegmentedControl.selectedSegmentIndex = [GlobalSearchModel sharedInstance].currentSearchBarSearchScope;
    }
    
    return _searchScopeSegmentedControl;
}

#pragma mark - Event handlers

- (void)tapToDismissViewTapped
{
    [self hideTapToDismissView];
    [self.searchBar resignFirstResponder];
}

- (void)dismissPopover
{
    [self.searchBar resignFirstResponder];
    [_searchResultPopover dismissPopoverAnimated:YES];
}

- (void)didSelectSegment
{
    [GlobalSearchModel sharedInstance].currentSearchBarSearchScope = (SearchScope)self.searchScopeSegmentedControl.selectedSegmentIndex;
    [self executeSearch];
}

- (void)executeFullSearch
{
    if (!self.activeSearchDisplayController)
    {
        return;
    }
    
    [self dismissPopover];
    
    NSLog(@"executeFullSearch for: %p",self);
    
    // Cancel any old operation ongoing if called again.
    [self.fullSearchOperation cancel];
    
    self.fullSearchOperation = [NSBlockOperation blockOperationWithBlock:^
    {
        // search result view controller which searches and updates results
        MainSearchResultViewController *searchResultController =
        (MainSearchResultViewController *)self.searchContentsController.navigationController.topViewController;
        if ([searchResultController isKindOfClass:[MainSearchResultViewController class]])
        {
            [self dismissPopover];
            [self hideTapToDismissView];
        }
        else
        {
            searchResultController = [[MainSearchResultViewController alloc]init];
            [self.searchContentsController.navigationController pushViewController:searchResultController animated:YES];
        }
        
        [searchResultController executeSearchWithSearchString:self.searchBar.text];
    }];

    [[NSOperationQueue mainQueue]addOperation:self.fullSearchOperation];
}


#pragma mark - Google Analytics
- (void)updateNewSearchForGA:(NSString*)searchString
{
    if(searchString && (![searchString isEqualToString:@""]))
    {
        NSString* retStr = [NSString stringWithFormat:@"/search?query=%@",searchString];
        [[GGUsageTracker sharedInstance] trackView:retStr];
    }
}


@end
