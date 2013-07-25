//
//  BundleModalViewControllerHelper.h
//  GoldenGate
//
//  Created by Satish Basavaraj on 19/06/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "EntityModalViewControllerHelper.h"
#import "LoadingView.h"
#import "ElementsView.h"


@interface BundleModalViewControllerHelper : EntityModalViewControllerHelper<UITableViewDataSource, UITableViewDelegate, LoadingViewDelegate, ElementsViewDelegate,EntityModalViewControllerHelperDelegate>


//@property (weak, nonatomic) DisplayEntity* subDispEntityShown;

@end
