//
//  ChannelsForGenreCell.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 16/05/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "ChannelsForGenreCell.h"
#import "KITGridLayoutView.h"
#import "Constants.h"
#import "Channel.h"
#import "ChannelCellView.h"
#import "EntityModalViewController.h"

@interface ChannelsForGenreCell ()

@property (weak, nonatomic) IBOutlet KITGridLayoutView *gridLayoutView; //Grid view to display different channels
@property (weak, nonatomic) IBOutlet UILabel* genreTitle; //Genre title

@property (strong, nonatomic) NSMutableArray* arrayChannelCells; //Array of channel cell views
@property CGRect gridLayoutOrigFrame; //Original frame of cell from nib. Relevant for resetting size of Cell
@property(strong, nonatomic) ChannelCellView *prototypeCell;; //Prototype of ChannelCellView. Used to avoid creating multiple times





@end

@implementation ChannelsForGenreCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.gridLayoutView.horizontalGridSpacing   = kHorizontalGridSpacing;
    self.gridLayoutView.verticalGridSpacing     = kVerticalGridSpacing;
    self.gridLayoutView.autoWrap = YES;
    self.gridLayoutView.autoResizeHorizontally = YES;
    self.gridLayoutOrigFrame = self.gridLayoutView.frame;
    
}

//Update UI from list of channels
- (void)updateFromChannels:(NSArray *)channelist
{
    [self removeAllChannelCells];
    
    for (Channel* channel in channelist) {
        ChannelCellView* channelCellView = [[ChannelCellView alloc]initWithCellSize:CellSizeSmall];
        channelCellView.channel = channel;
        [channelCellView addTarget:self action:@selector(didPressChannelCellView:) forControlEvents:UIControlEventTouchUpInside];
        [self.gridLayoutView addSubview:channelCellView];
        [self.arrayChannelCells addObject:channelCellView];
        
    }

}

//Remove all existing channel cells
-(void)removeAllChannelCells
{
    
    for (UIView* viewcell in self.arrayChannelCells) {
        [viewcell removeFromSuperview];
    }
    [self.arrayChannelCells removeAllObjects];
    [self.gridLayoutView setFrame:self.gridLayoutOrigFrame];
}

//Setter for channels
- (void)setChannels:(NSArray *)channelist
{
    _channels = channelist;
    
    //When the variable is set, the UI is updated
    [self updateFromChannels:channelist];
}

- (void)setGenre:(NSString *)genre
{
    _genre =genre;
    
    //When the variable is set, the UI is updated
    self.genreTitle.text = genre;
}

//Obtain height of Grid for number of cells
-(float)getGridLayoutHeight:(int)numCells
{
    
    float fHeightGrid = [self.gridLayoutView getGridHeightForEqualSizeCell:self.prototypeCell.frame.size numcells:numCells];
    return fHeightGrid;
}

//Get the total cell height for number of cells
-(float)getCellHeightForNumCells:(int)numCells
{

    float fHeightStart = [self.gridLayoutView frame].origin.y;
    float fHeightGrid = [self getGridLayoutHeight:numCells];
    return (fHeightGrid+fHeightStart);
    
}

//Selector called when a channel cell is tapped
- (void)didPressChannelCellView:(ChannelCellView*)channelCellView
{
    [EntityModalViewController showFromView:channelCellView withEntity:channelCellView.channel navController:self.navController];
}

#pragma - Properties

-(NSMutableArray*) arrayChannelCells
{
    if (nil== _arrayChannelCells) {
        _arrayChannelCells = [NSMutableArray new];
    }
    return _arrayChannelCells;
}

#pragma mark - Properties

- (ChannelCellView *)prototypeCell
{
    if (_prototypeCell == nil)
    {
        _prototypeCell = [[ChannelCellView alloc]initWithCellSize:CellSizeSmall];
    
    }
    
    return _prototypeCell;
}

@end
