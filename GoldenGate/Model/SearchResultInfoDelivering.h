//
//  SearchResultInfoDelivering.h
//  GoldenGate
//
//  Created by Andreas Petrov on 10/4/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 @abstract
 Have classes implement this so that they can be presented in the table for quick view of search results.
 */
@protocol SearchResultInfoDelivering <NSObject>

- (NSString*)searchResultTitleText;
- (NSString*)searchResultDetailText;
- (NSString*)searchResultImageURLWithSize:(CGSize)size;

@end
