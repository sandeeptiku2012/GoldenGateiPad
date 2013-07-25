//
//  GGSearchDisplayController.h
//  GoldenGate
//
//  Created by Andreas Petrov on 10/4/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGSearchDisplayController : UISearchDisplayController <UISearchDisplayDelegate, UISearchBarDelegate>

@property (assign, nonatomic) BOOL activeSearchDisplayController;

@end
