//
//  GGBaseViewController.m
//  GoldenGate
//
//  Created by Andreas Petrov on 8/22/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "GGBaseViewController.h"

#import "KITImageProvider.h"
#import "KITImageProviderFactory.h"
#import "KITViewLocalizer.h"
#import "VimondStore.h"
#import "NavActionExecutor.h"
#import "GGUsageTracker.h"

@interface GGBaseViewController ()

@end

@implementation GGBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _viewControllerOperationQueue = [NSOperationQueue new];
    
    KITViewLocalizer *loc = [[KITViewLocalizer alloc]init]; // TODO: Make singleton.
    [loc localizeView:self.view];
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
    
    [_viewControllerOperationQueue cancelAllOperations];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

//    NSLog(@"",[self generateTrackingPath]);
    [[GGUsageTracker sharedInstance] trackView:[self generateTrackingPath]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [NavActionExecutor clearViewControllerCache];
    [[VimondStore sharedStore]clearCache];
    [KITImageProvider clearImageCache];
    [KITImageProviderFactory clearImageProviders];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)showError:(NSError *)error
{
    [self runOnUIThread:^
    {
         [[[UIAlertView alloc] initWithTitle:@"ERROR" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

#pragma mark - TrackingPathGenerating

- (NSString *)generateTrackingPath
{
    NSAssert(NO, @"Please override in subclasses");
    return nil;
}

#pragma mark - Threading

- (NSOperation*)runOnBackgroundThread:(void (^)())block
{
    NSOperation *op = [NSBlockOperation blockOperationWithBlock:block];
    [[self viewControllerOperationQueue] addOperation:op];
    return op;
}

- (NSOperation*)runOnUIThread:(void (^)())block
{
    NSOperation *op = [NSBlockOperation blockOperationWithBlock:block];
    [[NSOperationQueue mainQueue] addOperation:op];
    return op;
}

@end
