//
//  KITLocalizationURLDataSource.m
//  KIT
//
//  Created by Andreas Petrov on 4/29/12.
//  Copyright (c) 2012 Reaktor. All rights reserved.
//

#import "KITLocalizationURLDataSource.h"
#import "KITLanguage.h"
#import "KITUnixDateFormatter.h"

#define kCacheFileExtension @".json"
#define kCacheFileDefaultPrefix @"LocalizableStringCache"

@interface KITLocalizationURLDataSource() 

@property (strong, nonatomic) NSMutableDictionary *languageIsoCodeToURLDict;

// Contains dictionaries within the dictionary. One dictionary pr. language.
@property (strong, nonatomic) NSMutableDictionary *languageIsoCodeToStringsDict;

// The dictionary of the currently used language.
@property (strong, nonatomic) NSDictionary *currentStringDict;

@property (strong, nonatomic) KITUnixDateFormatter *unixDateFormatter;

@end

@implementation KITLocalizationURLDataSource

@synthesize languageIsoCodeToURLDict;
@synthesize languageIsoCodeToStringsDict;
@synthesize format;
@synthesize currentStringDict;
@synthesize useAsynchronousURLConnection;
@synthesize cacheFileNamePrefix;
@synthesize useIfModifiedSince;
@synthesize unixDateFormatter;

- (id)initWithFormat:(URLDataSourceFormat)aFormat
{
    if ((self = [super init])) 
    {
        unixDateFormatter = [[KITUnixDateFormatter alloc]init];
        languageIsoCodeToURLDict = [[NSMutableDictionary alloc]init];
        languageIsoCodeToStringsDict = [[NSMutableDictionary alloc]init];
        format = aFormat;
        cacheFileNamePrefix = kCacheFileDefaultPrefix;
        useAsynchronousURLConnection = YES;
        useIfModifiedSince = YES;
    }
    
    return self;
}

#pragma mark - Public methods

- (void)addURL:(NSURL*)url forLanguage:(KITLanguage*)language
{
    [languageIsoCodeToURLDict setValue:url forKey:language.isoCode];
}

- (NSURLRequest*)requestForStringWithLanguage:(KITLanguage*)language
{
    NSURL *url = [self urlForLanguage:language];
    
    NSMutableURLRequest *request = nil;
    if (url != nil)
    {
        request = [NSMutableURLRequest requestWithURL:url];
        
        
        if (self.useIfModifiedSince) 
        {
            NSDate *dateLangCacheLastUpdated = [self dateLanguageWasLastUpdated:language];
            if (dateLangCacheLastUpdated) 
            {
                NSString* time = [self.unixDateFormatter stringFromDate:dateLangCacheLastUpdated];
                [request setValue:time forHTTPHeaderField:@"If-modified-since"];
            }
        }
    }
    
    return request;
}

#pragma mark - KITLocalizationDataSource

-(NSString*)lookupStringForKey:(NSString*)key
{
    return [self.currentStringDict valueForKey:key];
}

- (void)languageDidChange:(KITLanguage *)newLanguage
{
    // This will trigger lazy reload of language strings on next string lookup
    self.currentStringDict = nil;
}

#pragma mark - Utils

- (NSDictionary*)parseDataAsXML:(NSData*)data error:(NSError**)error
{
    return nil;
}

- (NSDictionary*)parseDataAsJSON:(NSData*)data error:(NSError**)error
{
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:error];
}

- (void)handleURLConnectionResponse:(NSURLResponse*)response data:(NSData*)data error:(NSError*)error language:(KITLanguage*)language
{
    NSDictionary *strings = nil;
    switch (self.format) {
        case URLDataSourceFormatXML:
            strings = [self parseDataAsXML:data error:&error];
            break;
        case URLDataSourceFormatJSON:
            strings = [self parseDataAsJSON:data error:&error];
        default:
            break;
    }
    
    if (error) 
    {
        NSLog(@"%@", error);
    }
    
    [self.languageIsoCodeToStringsDict setValue:strings forKey:language.isoCode];
    
    [self serializeToJSONFile:strings forLanguage:language];
}

- (void)startLoadingStringsForLanguage:(KITLanguage*)language
{
    
    // Add a placeholder dictionary to the given language so that
    // another call to self.currentStringDict won´t start loading the data for the same language
    // over again.
    NSDictionary* placeholderDict = [[NSDictionary alloc]init];
    [self.languageIsoCodeToStringsDict setValue:placeholderDict forKey:language.isoCode];
    
    NSURLRequest *request = [self requestForStringWithLanguage:language];
    
    if (self.useAsynchronousURLConnection) 
    {
        [NSURLConnection sendAsynchronousRequest:request 
                                           queue:[NSOperationQueue currentQueue] 
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) 
         {
             [self handleURLConnectionResponse:response data:data error:error language:language];
         }];
    }
    else 
    {
        NSURLResponse *response;
        NSError *error;
        NSData *data =[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        [self handleURLConnectionResponse:response data:data error:error language:language];
    }
}

- (NSDictionary*)dictForLanguage:(KITLanguage*)language
{
    NSDictionary *dictForLanguage = [self.languageIsoCodeToStringsDict objectForKey:language.isoCode];
    
    BOOL needsToLoadLanguage = dictForLanguage == nil;
    if (needsToLoadLanguage)
    {
        dictForLanguage = [self loadStringsFromFileForLanguage:language];
        
        // after loading files from file start downloading new files from the web.
        [self startLoadingStringsForLanguage:language];
    }
    
    return dictForLanguage;
}

- (NSURL*)urlForLanguage:(KITLanguage*)language
{
    return [self.languageIsoCodeToURLDict objectForKey:language.isoCode];
}

- (NSString *)filePathForLanguage:(KITLanguage*)language
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [NSString stringWithFormat:@"%@/%@_%@%@", rootPath, kCacheFileDefaultPrefix, language.isoCode, kCacheFileExtension];
}

- (NSOutputStream *)createOutputStreamForLanguage:(KITLanguage*)language
{
    NSOutputStream* outputStream = [[NSOutputStream alloc]initToFileAtPath:[self filePathForLanguage:language] append:NO];
    return outputStream;
}

- (NSInputStream*)createInputStreamForLanguage:(KITLanguage*)language
{
    return [[NSInputStream alloc]initWithFileAtPath:[self filePathForLanguage:language]];
}

- (NSDate *)dateLanguageWasLastUpdated:(KITLanguage*)language
{
    NSFileManager *fm = [NSFileManager defaultManager];
    return [[fm attributesOfItemAtPath:[self filePathForLanguage:language] error:NULL] fileModificationDate];
}

- (void)serializeToJSONFile:(NSDictionary*)dict forLanguage:(KITLanguage*)language
{
    NSOutputStream *stream = [self createOutputStreamForLanguage:language];
    [stream open];
    if (stream.streamStatus == NSStreamStatusOpen)
    {
        NSError *error = nil;
        [NSJSONSerialization writeJSONObject:dict toStream:stream options:NSJSONWritingPrettyPrinted error:&error];
        if (error) 
        {
            NSLog(@"%@", error);
        }
        
        [stream close];
    }
}

- (NSDictionary *)loadStringsFromFileForLanguage:(KITLanguage*)language
{
    NSInputStream *inputStream = [self createInputStreamForLanguage:language];
    [inputStream open];
    
    NSDictionary *strings = nil;
    NSError * error = nil;
    if (inputStream.streamStatus == NSStreamStatusOpen)
    {
        strings = [NSJSONSerialization JSONObjectWithStream:inputStream options:kNilOptions error:&error];
    }
    
    if (error) 
    {
        NSLog(@"%@", error);
    }
    
    return strings;
}

#pragma mark - Properties

- (NSDictionary*)currentStringDict
{
    if (currentStringDict == nil) 
    {
        currentStringDict = [self dictForLanguage:self.language];
    }
    
    return currentStringDict;
}

@end
