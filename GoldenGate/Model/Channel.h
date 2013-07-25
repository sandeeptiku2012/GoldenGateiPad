//
//  Channel.h
//  GoldenGate
//
//  Created by Andreas Petrov on 8/13/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DisplayEntity.h"
#import "Constants.h"
#import "SearchResultInfoDelivering.h"

@interface Channel : DisplayEntity <SearchResultInfoDelivering>

//@property (copy, nonatomic) NSString *publisher;
//@property (copy, nonatomic) NSString *imagePack;
//@property (copy, nonatomic) NSString *strGenre; //Genre for channel
//@property (assign, nonatomic) PGRating pgRating;
//@property (assign, nonatomic) int likeCount;
//
//- (id)initWithId:(int)identifier;
//- (NSString *)logoURLStringForSize:(CGSize)size;

@end
