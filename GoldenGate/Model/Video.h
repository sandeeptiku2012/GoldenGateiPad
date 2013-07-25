//
//  Video.h
//  GoldenGate
//
//  Created by Andreas Petrov on 8/13/12.
//  Copyright (c) 2012 Andreas Petrov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"
#import "SearchResultInfoDelivering.h"

@class Channel;

@interface Video : Entity <SearchResultInfoDelivering>

@property (assign, nonatomic)   int likeCount;
@property (assign, nonatomic)   int previewAssetId;
@property (copy, nonatomic)     NSDate *publishedDate;
@property (assign, nonatomic)   NSTimeInterval duration;

//TBD: Rename channelID to categoryID as the new app has shows as well
@property (assign, nonatomic)   NSUInteger channelID;
@property (copy, nonatomic) NSString *imagePack;

- (id)initWithId:(int)identifier;
- (NSString *)thumbURLStringForSize:(CGSize)size;
- (Video *)previewVideo;

@end
