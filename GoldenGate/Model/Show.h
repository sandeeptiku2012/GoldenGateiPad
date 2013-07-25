//
//  Shows.h
//  GoldenGate
//
//  Created by Satish Basavaraj on 24/05/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import "DisplayEntity.h"
#import "Constants.h"
#import "SearchResultInfoDelivering.h"

// Model for Shows

@interface Show : DisplayEntity<SearchResultInfoDelivering>

- (NSString *)logoURLStringForSize:(CGSize)size;

@end
