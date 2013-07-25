//
//  CollectionViewController.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 03/07/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionCellWrapper.h"

static NSString *cellIDFeatured;

@interface CollectionViewController ()

@property(strong, nonatomic) NSArray* arrayData;

@end


@implementation CollectionViewController

-(id)initWithView:(UICollectionView*)collectionView
{
    self = [super init];
    if (self) {
        self.edgeInsetForCollectionView = UIEdgeInsetsMake(0, 12, 0, 12);
        cellIDFeatured = NSStringFromClass([CollectionCellWrapper class]);
        self.collectionView = collectionView;
        [self.collectionView registerClass:[CollectionCellWrapper class] forCellWithReuseIdentifier:cellIDFeatured];
    }
    
    return self;
}

-(void)reloadData:(NSArray *)arrayData
{
    self.arrayData = arrayData;
    [self.collectionView reloadData];
}

- (void)clearData
{
    [self reloadData:nil];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.arrayData count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {

    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    CollectionCellWrapper *collCellWrapper = (CollectionCellWrapper *) [cv dequeueReusableCellWithReuseIdentifier:cellIDFeatured forIndexPath:indexPath];
    collCellWrapper.cellView = [self.delegate cellForData:[self.arrayData objectAtIndex:indexPath.row]];
    
    collCellWrapper.collectionIndex = indexPath.row;
    collCellWrapper.dataObject = [self.arrayData objectAtIndex:indexPath.row];
    return collCellWrapper;
}



#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize sizeRet;
    if ([self.arrayData count] > indexPath.row) {
        sizeRet = [self.delegate cellSizeForData:[self.arrayData objectAtIndex:indexPath.row]];
    }
    return sizeRet;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return self.edgeInsetForCollectionView;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionCellWrapper* cellTapped = (CollectionCellWrapper*)[collectionView cellForItemAtIndexPath:indexPath];
    [self.delegate collectionView:collectionView didSelectCell:cellTapped];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionCellWrapper* cellUntapped = (CollectionCellWrapper*)[collectionView cellForItemAtIndexPath:indexPath];
    [self.delegate collectionView:collectionView didUnselectCell:cellUntapped];
}


#pragma mark - properties
- (void)setCollectionView:(UICollectionView *)collectionView
{
    collectionView.delegate = self;
    collectionView.dataSource = self;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [collectionView setCollectionViewLayout:flowLayout];
    
    _collectionView = collectionView;
}

@end
