//
//  Bundle.h
//  GoldenGate
//
//  Created by Satish Basavaraj on 18/06/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "Entity.h"
#import "Constants.h"
#import "SearchResultInfoDelivering.h"

@interface Bundle : Entity<SearchResultInfoDelivering>

@property BOOL isPaid;
@property BOOL isSaleEnabled;
@property NSUInteger publisherID;
@property (copy, nonatomic) NSString *imagePack;
@property (copy, nonatomic) NSString *publisher;

- (NSString *)logoURLStringForSize:(CGSize)size;


@end
