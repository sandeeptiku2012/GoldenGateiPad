//
//  ChannelsForGenreCell.h
//  GoldenGate
//
//  Created by Satish Basavaraj on 16/05/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import <UIKit/UIKit.h>

//TableviewCell to display channels for a Genre
//The cell adjusts height based on number channel cells

@interface ChannelsForGenreCell : UITableViewCell

@property (weak, nonatomic) NSArray *channels; //Channels for a genre
@property (weak, nonatomic) NSString *genre; //Genre name
@property (weak, nonatomic) UINavigationController *navController; //Associated navigation controller

-(float)getCellHeightForNumCells:(int)numCells; //Get cell height for n number of cells. The cell adjusts height based on number of cells

@end
