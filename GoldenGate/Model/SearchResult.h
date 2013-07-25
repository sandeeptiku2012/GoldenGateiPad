#import <Foundation/Foundation.h>


/*!
 @abstract
 Wraps a result from a search query.
 @note
 The items.count might not correspond to totalCount
 This happens whenever there are more hits for a search than the 
 search has been asked to return.
 */
@interface SearchResult : NSObject

@property(assign) NSUInteger totalCount;
@property(strong) NSArray *items;

@end