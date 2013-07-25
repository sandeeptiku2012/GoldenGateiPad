//
//  EntityModalViewSubElementsView.h
//  GoldenGate
//
//  Created by Satish Basavaraj on 12/06/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"

@interface EntityModalViewSubElementsView : UIView

@property (weak, nonatomic) IBOutlet UINavigationBar    *navBar;
@property (weak, nonatomic) IBOutlet UILabel *navBarTitle;
@property (weak, nonatomic) IBOutlet UITableView      *elementsTableView;
@property (weak, nonatomic) IBOutlet LoadingView      *loadingView;

-(void)addBackButtonWithText:(NSString*)strBackString;

@end
