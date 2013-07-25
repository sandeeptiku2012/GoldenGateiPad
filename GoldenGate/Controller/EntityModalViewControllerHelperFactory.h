//
//  EntityModalViewControllerHelperFactory.h
//  GoldenGate
//
//  Created by Satish Basavaraj on 11/06/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EntityModalViewControllerHelper.h"

@interface EntityModalViewControllerHelperFactory : NSObject


+(EntityModalViewControllerHelper*)createModalViewControllerHelperForEntity:(Entity*)entity withNavController:(UINavigationController*)navController;
@end
