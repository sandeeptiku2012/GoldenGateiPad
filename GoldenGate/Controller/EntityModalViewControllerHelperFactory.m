//
//  EntityModalViewControllerHelperFactory.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 11/06/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "EntityModalViewControllerHelperFactory.h"
#import "Channel.h"
#import "Show.h"
#import "Bundle.h"
#import "ChannelModalViewControllerHelper.h"
#import "ShowModalViewControllerHelper.h"
#import "BundleModalViewControllerHelper.h"


@implementation EntityModalViewControllerHelperFactory


+(EntityModalViewControllerHelper*)createModalViewControllerHelperForEntity:(Entity*)entity withNavController:(UINavigationController*)navController
{
    EntityModalViewControllerHelper* modalViewControllerHelper = nil;
    
    if ([entity isKindOfClass:[Channel class]]) {
        
        modalViewControllerHelper = [[ChannelModalViewControllerHelper alloc]initWithEntity:entity navController:navController];
    }else if([entity isKindOfClass:[Show class]])
    {
        modalViewControllerHelper = [[ShowModalViewControllerHelper alloc]initWithEntity:entity navController:navController];
    }else if([entity isKindOfClass:[Bundle class]])
    {
        modalViewControllerHelper = [[BundleModalViewControllerHelper alloc]initWithEntity:entity navController:navController];
    }
    
    return modalViewControllerHelper;
}

@end
