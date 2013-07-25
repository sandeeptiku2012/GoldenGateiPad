//
//  ChannelModalViewControllerHelperViewController.h
//  GoldenGate
//
//  Created by Satish Basavaraj on 11/06/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "EntityModalViewControllerHelper.h"
#import "LoadingView.h"
#import "ElementsView.h"
#import "ModalEntityRelatedViewController.h"


@interface ChannelModalViewControllerHelper: EntityModalViewControllerHelper<UITableViewDataSource, UITableViewDelegate, LoadingViewDelegate, ElementsViewDelegate, EntityModalViewControllerHelperDelegate, ModalEntityRelatedViewControllerDelegate>

//@property (weak, nonatomic) DisplayEntity* subDispEntityShown;

@end
