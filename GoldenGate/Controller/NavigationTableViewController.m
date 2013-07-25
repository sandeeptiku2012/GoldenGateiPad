//
//  NavigationTableViewController.m
//  GoldenGate
//
//  Created by Andreas Petrov on 9/12/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "NavigationTableViewController.h"
#import "KITTileImageView.h"
#import "CategoryAction.h"
#import "GGBackgroundOperationQueue.h"
#import "CategoryNavigator.h"
#import "Entity.h"
#import "ContentCategory.h"
#import "BaseNavViewController.h"
#import "NavActionExecutor.h"
#import "Constants.h"
#import "ChannelsAToZViewController.h"

#define kLoadingTableCellId @"LoadingTableCell"

@interface NavigationTableViewController ()

// Names of the section
@property(strong, nonatomic) NSArray *sectionNames;

// 2D array with one array for each section
@property(strong, nonatomic) NSArray *navActionsForSections;


@property(weak, nonatomic) BaseNavViewController *mainViewController;

@property(strong, nonatomic) ChannelsAToZViewController *channelsAToZViewController;

@property (strong, nonatomic) NSOperation *loadDataOperation;


@end

@implementation NavigationTableViewController


- (id)initWithMainViewController:(BaseNavViewController *)viewController
{
    if ((self = [super initWithStyle:UITableViewStyleGrouped]))
    {
        _mainViewController = viewController;
    }

    return self;
}

- (void)loadData
{
    // Cancel any old operation
    [self.loadDataOperation cancel];
    
    self.loadDataOperation = [NSBlockOperation blockOperationWithBlock:^
    {
        [self.navAction loadSubActionsIfNeeded];
        [self rebuildTableData];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^
        {
            [self.tableView reloadData];
        }];
    }];
    
    [[GGBackgroundOperationQueue sharedInstance]addOperation:self.loadDataOperation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.backgroundView = [[KITTileImageView alloc] initWithImage:[UIImage imageNamed:@"LightGrayNoiseBg.png"]];
    [self.tableView registerNib:[UINib nibWithNibName:kLoadingTableCellId bundle:nil] forCellReuseIdentifier:kLoadingTableCellId];

    self.title = self.navAction.name;
    
    
    [self loadData];
     self.tableView.accessibilityLabel = @"Channels Table";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.loadDataOperation cancel];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *navActionArrayForIndex = [self.navActionsForSections objectAtIndex:section];
    return navActionArrayForIndex.count;
}


- (NavAction *)navActionAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *navActionArrayForIndex = [self.navActionsForSections objectAtIndex:(NSUInteger) indexPath.section];
    return [navActionArrayForIndex objectAtIndex:(NSUInteger) indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessibilityLabel = [NSString stringWithFormat:@"ChannelsTable Cell With Section(%d) & Row(%d)", indexPath.section, indexPath.row];
    }

    NavAction *navAction = [self navActionAtIndexPath:indexPath];

    cell.accessoryView = nil;
    if ([navAction isKindOfClass:[CategoryAction class]])
    {
        CategoryAction *categoryAction = (CategoryAction *) navAction;

        if (categoryAction.category.categoryLevel == ContentCategoryLevelMain && categoryAction != self.navAction)
        {
            cell.accessoryView = [self createDisclosureButton];
        }
    }

    if (cell.accessoryView == nil)
    {
        
        CategoryAction *currentCategoryAction = (CategoryAction *) self.mainViewController.navAction;
        cell.accessoryType = currentCategoryAction == navAction ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
     
    }
    
    cell.textLabel.text = [self rowNameForAction:navAction];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    BOOL shouldShowRowImage = indexPath.section == 1;
    cell.imageView.image = shouldShowRowImage ? [UIImage imageNamed:navAction.iconName] : nil;

    return cell;
}

- (NSString *)rowNameForAction:(NavAction *)action
{
    NSString *name = @"";
    if (self.navAction != action)
    {
        name = action.name;
    }
    else
    {
        name = [NSString stringWithFormat:NSLocalizedString(@"AllOfCategoryLKey", @""), action.name];
    }

    return name;
}

- (UIView *)createDisclosureButton
{
    UIButton *disclosureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [UIImage imageNamed:@"DisclosureButton.png"];
    disclosureButton.frame = CGRectMake(0, 0, 44, 44);
    [disclosureButton setImage:buttonImage forState:UIControlStateNormal];
    [disclosureButton addTarget:self action:@selector(accessoryButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];

    return disclosureButton;
}

#pragma mark - Table view delegate

- (void)pushNavigationTableWithAction:(CategoryAction *)action animated:(BOOL)animated
{
    NavigationTableViewController *navTableViewController = [[NavigationTableViewController alloc] initWithMainViewController:self.mainViewController];
    navTableViewController.navAction = action;

    [self.navigationController pushViewController:navTableViewController animated:animated];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NavAction *action = [self navActionAtIndexPath:indexPath];
    if ([action isKindOfClass:[CategoryAction class]])
    {
        CategoryAction *catAction = (CategoryAction*) action;
        UIViewController* topController =  self.mainViewController.navigationController.topViewController;
        if(![topController isKindOfClass:[ChannelsAToZViewController class]])
        {
        
            [ChannelsAToZViewController presentChannelsAToZViewControllerwithNavAction:action fromController:self.mainViewController.navigationController];
    
        }else{
            
            ChannelsAToZViewController *channelAToZ = (ChannelsAToZViewController*) topController;
            [channelAToZ loadDataWithAction:catAction];
                    
        }
        
        
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:kNavigationPopoverDismiss object:nil];
    }
    
}



- (void)accessoryButtonTapped:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath != nil)
    {
        [self tableView:self.tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}



- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    CategoryAction *action = (CategoryAction *) [self navActionAtIndexPath:indexPath];
    NSAssert([action isKindOfClass:[CategoryAction class]], @"action must be CategoryAction");
    [self pushNavigationTableWithAction:action animated:YES];
}

#pragma mark - Properties

- (void)rebuildTableData
{
    // This method is a bit of a mess. Feel free to refactor if you know an
    // easier way to group and sort these elements

    // TODO: USE NSOrderedSet to do this easier.
    int sectionIndex = -1;
    NSMutableDictionary *sectionNameDict = [NSMutableDictionary new];
    NSMutableArray *navActionsForAllSections = [NSMutableArray new];

    // Look through all subActions to map out all existing section names
    for (NavAction *navAction in self.navAction.subActions)
    {
        // Up the section index once a nav-item with a new section name appears.
        NSString *sectionName = [self sectionNameForNavAction:navAction];

        NSString *alreadyRegisteredSectionName = [sectionNameDict objectForKey:sectionName];
        if (alreadyRegisteredSectionName == nil)
        {
            [navActionsForAllSections addObject:[NSMutableArray new]];
            sectionIndex++;
            [sectionNameDict setObject:@(sectionIndex) forKey:sectionName];
        }

        NSMutableArray *arrayToAddCurrentNavActionTo = [navActionsForAllSections objectAtIndex:sectionIndex];
        [arrayToAddCurrentNavActionTo addObject:navAction];
    }

    NSMutableArray *sortedSectionNames = [NSMutableArray new];
    for (int i = 0; i < sectionNameDict.count; ++i)
    {
        // Pad with empty strings in preparation for next loop.
        [sortedSectionNames addObject:@""];
    }

    for (NSString *sectionName in sectionNameDict.allKeys)
    {
        NSNumber *index = [sectionNameDict objectForKey:sectionName];
        [sortedSectionNames replaceObjectAtIndex:[index intValue] withObject:sectionName];
    }
    

    // Make self.navAction the first item in its respective section.
    NSString *sectionForSelfAction          = [self sectionNameForNavAction:self.navAction];
    NSInteger sectionIndexForSelfAction     = [sortedSectionNames indexOfObject:sectionForSelfAction];
    if (sectionIndexForSelfAction == NSNotFound)
    {
        // This means there were no subActions in this nav action.
        // Must add a section for the self.navAction
        [sortedSectionNames addObject:sectionForSelfAction];
        [navActionsForAllSections addObject:@[self.navAction]];
    }
    else
    {
        NSMutableArray *actionArrayForSection = [navActionsForAllSections objectAtIndex:sectionIndexForSelfAction];
        [actionArrayForSection insertObject:self.navAction atIndex:0];
    }
    
    self.navActionsForSections = navActionsForAllSections;
    self.sectionNames = sortedSectionNames;
}

- (NSString *)sectionNameForNavAction:(NavAction*)action
{
    NSString *sectionName = @"None";
    if ([action isKindOfClass:[CategoryAction class]])
    {
        sectionName = NSLocalizedString(@"CategoriesLKey", @"");
    }

    return sectionName;
}

- (void)updateFromNavAction:(NavAction *)action
{
    self.title = self.navAction.name;
    
    if (!self.isViewLoaded)
    {
        return;
    }
    
    [self loadData];
}

- (void)setNavAction:(CategoryAction *)navAction
{
    _navAction = navAction;
    
    [self updateFromNavAction:navAction];
}


@end
