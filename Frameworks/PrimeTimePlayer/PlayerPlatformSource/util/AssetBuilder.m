//
//  AssetBuilder.m
// PlayerPlatform
//
//  Created by Cory Zachman on 11/29/12.
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation..
//

#import "AssetBuilder.h"
#import "Asset.h"

@implementation AssetBuilder

-(AbstractXuaAsset*)buildAsset:(Asset *)asset
{
    AbstractXuaAsset *xuaAsset = [[AbstractXuaAsset alloc] init];
    if(asset.recordingId != NULL)
    {
        MerlinAsset *merlinAsset = [[MerlinAsset alloc] init];
        merlinAsset.assetIds = [[XuaAssetIds alloc] init];
        merlinAsset.assetIds.RID = asset.recordingId;
        xuaAsset = merlinAsset;
    }
    if(asset.licenseId != NULL && asset.releaseId != NULL)
    {
        CRPIDAsset *crpidAsset = [[CRPIDAsset alloc] init];
        crpidAsset.assetIds = [[XuaAssetIds alloc] init];
        crpidAsset.assetIds.LID = asset.licenseId;
        crpidAsset.assetIds.RID = asset.releaseId;
        xuaAsset = crpidAsset;

    }
    if(asset.providerId != NULL && asset.assetId != NULL)
    {
        PAIDAsset *paidAsset = [[PAIDAsset alloc] init];
        paidAsset.assetIds = [[XuaAssetIds alloc] init];
        paidAsset.assetIds.XPI = asset.providerId;
        paidAsset.assetIds.XAI = asset.assetId;
        xuaAsset = paidAsset;


    }
    if(asset.mediaId != NULL  && asset.tpId != NULL)
    {
        AAEIDAsset *aaeidAsset = [[AAEIDAsset alloc] init];
        aaeidAsset.assetIds = [[XuaAssetIds alloc] init];
        aaeidAsset.assetIds.MID = asset.mediaId;
        aaeidAsset.assetIds.TID = asset.tpId;
        xuaAsset = aaeidAsset;

    }
    
    return xuaAsset;
    
}
@end
