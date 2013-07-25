//
//  KITLocalizationURLDataSource.h
//  KIT
//
//  Created by Andreas Petrov on 4/29/12.
//  Copyright (c) 2012 Reaktor. All rights reserved.
//

#import "KITLocalizationDataSource.h"

@interface KITLocalizationURLDataSource : KITLocalizationDataSource

typedef enum {
    URLDataSourceFormatJSON,
    URLDataSourceFormatXML // NOT SUPPORTED YET
} URLDataSourceFormat;

- (id)initWithFormat:(URLDataSourceFormat)format;

/*!
 @abstract Define a URL to get data for the given language.
 */
- (void)addURL:(NSURL*)url forLanguage:(KITLanguage*)language;

/*!
 @abstract Returns the request used to fetch string data for a given language.
 @discussion
 Overload this method in subclasses to modify the url request you want to use for 
 a given language. Useful if your web server uses the Accept-Language HTTP header field to determine language
 instead of a unique URL.
 */
- (NSURLRequest*)requestForStringWithLanguage:(KITLanguage*)language;

/*!
 @abstract Defines the format we expect the data from the sourceURL to have.
 */
@property (assign, readonly, nonatomic) URLDataSourceFormat format;

/*!
 @abstract defines whether or not the fetching of the string data
 should be asynch or not. Default is YES.
 @discussion
 This is primarily made to have synchronous calls in unit tests
 */
@property (assign, nonatomic) BOOL useAsynchronousURLConnection;


/*
 @abstract defines whether or not the HTTP request used to fetch the 
 string data will use the If-Modified-Since HTTP header with 
 the date of the last saved cache file. Default is YES.
 */
@property (assign, nonatomic) BOOL useIfModifiedSince;

/*!
 @abstract Defines the first part of the cache file name to be used when 
 string data is cached to disk.
 */
@property (strong, nonatomic) NSString *cacheFileNamePrefix;

@end
