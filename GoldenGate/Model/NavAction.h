//
//  NavAction.h
//  GoldenGate
//
//  Created by Andreas Petrov on 9/11/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NavAction : NSObject

- (id)initWithName:(NSString *)name;

/*!
 @abstract
 Recurses through parentAction until the root action is found
 */
- (NavAction*)rootAction;

/*!
 @abstract 
 The name of the action as it will appear in the NavigationTableViewController or in the filter segment controller.
 */
@property (copy, nonatomic) NSString *name;

/*!
 @abstract
 The image to be used for portraying this NavAction in the NavigationTableViewController
 */
@property (copy, nonatomic) NSString *iconName;


/*!
 @abstract
 The parent action of this action.
 @note
 Don't change the parentAction parameter explicitly outside of factory methods.
 */
@property (strong, nonatomic) NavAction *parentAction;

@end
