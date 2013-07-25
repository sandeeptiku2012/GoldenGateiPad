//
//  EmergencyAlertProvider.m
// PlayerPlatform
//
//  Created by Bryan Pauk on 1/29/13.
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation..
//

#import "EmergencyAlertProvider.h"
#import <PlayerPlatformUtil/SMXMLDocument.h>
#import "EasCompletedData.h"
#import "PlayerPlatformVideoEvent.h"
#import "EasFailureData.h"
#import <PlayerPlatformUtil/Base64Util.h>
#import <PlayerPlatformUtil/ConfigurationManager.h>
#import <PlayerPlatformUtil/AFHTTPRequestOperation.h>
@interface EmergencyAlertProvider ()
{
    NSString *_tokenToFipsUrl;
    NSString *_alertServiceUrl;
    NSString *_token;
    NSString *_fipsCode;
    PlayerPlatformAPI *_playerPlatform;
    NSInteger _updateInterval;
    NSInteger _alertPercentFromBottom;
    NSInteger _alertRepeat;
    NSTimer *_pollingTimer;
    NSMutableDictionary *_oldAlertIdentifiers;
    NSMutableArray *_activeAlerts;
    Asset *_savedAsset;
    CMTime _savedAssetPosition;
    bool _savedAutoPlay;
    bool _savedAssetIsLive;
    NSInteger _retryAttempt;
    NSInteger _retryInterval;
    Alert *_currentAlert;
    //todo alertText and Animate objects
    UILabel *_easTextLabel;
    UIScrollView *_easScrollView;
    NSTimer *_animationTimer;
    int count;
    bool isScrolling;
    UIFont *_alertFont;
    UIColor *_alertBackgroundColor;
    UIColor *_alertTextColor;
    NSOperationQueue *easQueue;
    dispatch_queue_t parseQueue;


}
@end

@implementation EmergencyAlertProvider

+ (id)sharedInstance {
    static EmergencyAlertProvider *sharedSingleton;

    @synchronized(self)
    {
        if (!sharedSingleton)
        {
            sharedSingleton = [[EmergencyAlertProvider alloc] init];

        }
        
        return sharedSingleton;
    }
}

-(id)init
{
    self = [super init];
    if(self)
    {
        easQueue = [[NSOperationQueue alloc] init];
        easQueue.name = @"PlayerPlatformEasQueue";
        parseQueue = dispatch_queue_create("com.comcast.playerplatform.eas", DISPATCH_QUEUE_SERIAL);
        easQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

-(void)configureAlertProvider:(NSString*) tokenToFipsUrl alertServiceUrl:(NSString*)alertServiceUrl token:(NSString*)token settings:(EmergencyAlertSettings *)settings
{
    _tokenToFipsUrl = tokenToFipsUrl;
    _alertServiceUrl = alertServiceUrl;
    _fipsCode = nil;
    _token = token;
    
    _activeAlerts = [[NSMutableArray alloc] init];
    _oldAlertIdentifiers = [[NSMutableDictionary alloc] init];
    
    [self setAlertSettings : settings];
    isScrolling = false;
    
    [self getFipsCode];
}

-(void)setPlayerPlatform:(PlayerPlatformAPI*) playerPlatform
{
    _playerPlatform = playerPlatform;
}

-(void)setAlertSettings:(EmergencyAlertSettings*) settings
{
    if (settings.pollingInterval != nil)
    {
        _updateInterval = [settings.pollingInterval integerValue];
    }
    else
    {
        _updateInterval = [[[ConfigurationManager sharedInstance] getConfigValue:EAS_UPDATE_INTERVAL] integerValue];
    }
    
    if (settings.alertRepeatCount != nil)
    {
        _alertRepeat = [settings.alertRepeatCount integerValue];
    }
    else
    {
        _alertRepeat = [[[ConfigurationManager sharedInstance] getConfigValue:EAS_ALERT_REPEAT] integerValue];
    }
    
    if (settings.font != nil)
    {
        _alertFont = settings.font;
    }
    else
    {
        _alertFont = [UIFont fontWithName:[[ConfigurationManager sharedInstance] getConfigValue:EAS_ALERT_FONT] size:[[[ConfigurationManager sharedInstance] getConfigValue:EAS_ALERT_FONT_SIZE] floatValue]];
    }
    
    if (settings.backgroundColor != nil)
    {
        _alertBackgroundColor = settings.backgroundColor;
    }
    else
    {
        _alertBackgroundColor = [UIColor clearColor];
    }
    
    if (settings.textColor != nil)
    {
        _alertTextColor = settings.textColor;
    }
    else
    {
        _alertTextColor = [UIColor whiteColor];
    }
    
}

-(void)getFipsCode
{
    NSError *xmlError;
    NSString *zipString;
    NSData *zipCode = [Base64Util decodeBase64WithString:_token];

    SMXMLDocument *doc = [SMXMLDocument documentWithData:zipCode error:&xmlError];
    if(xmlError)
    {
        EasFailureData *data = [[EasFailureData alloc] init];
        data.errorCode = [NSNumber numberWithInt:9000];
        data.description = @"Unable to Parse XsctToken";
        [[NSNotificationCenter defaultCenter] postNotificationName:EAS_FAILURE object:self userInfo:[data toDictionary]];
    }
    else
    {
        for (SMXMLElement *attribs in [doc.root childrenNamed:@"attribute"])
        {
            NSString *valueOfAttrib = [attribs attributeNamed:@"key"];
            if ( [valueOfAttrib isEqualToString:@"device:xcal:locationHomeZip"])
            {
                zipString = [attribs value];
            }
        }
        _tokenToFipsUrl = [_tokenToFipsUrl stringByAppendingString:zipString];
        
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:_tokenToFipsUrl]];
        AFHTTPRequestOperation *tokenToFipsUrl = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [tokenToFipsUrl setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation,id responseObject)
         {
             dispatch_sync(parseQueue, ^{
                 [self parseResponseWithData:responseObject];
                 if([self alertNeedsPlaying])
                 {
                     [self displayNextAlert];
                 }
             });
         }failure:^(AFHTTPRequestOperation *operation,NSError *error)
         {
             NSLog(@"Fail");
         }];
        
        [easQueue addOperation:tokenToFipsUrl];
       
    }
}

-(void)displayNextAlert
{
    isScrolling = true;
    _currentAlert = [_activeAlerts objectAtIndex:0];
    [_activeAlerts removeObjectAtIndex:0];

    if([_currentAlert hasMediaUrl])
    {
        [self savePlayerState];
        [self replaceContent];
    }
    else
    {
        [self setAlertText];
        [self startAnimation];
    }
    
    
}

-(void) savePlayerState
{
    _savedAsset = [_playerPlatform getCurrentAsset];
    _savedAssetPosition = [_playerPlatform getCurrentPosition];
    _savedAutoPlay = [_playerPlatform getAutoPlay];
    
    if ([_savedAsset.manifestUrl rangeOfString:@"?faxs=1"].location != NSNotFound) {
        _savedAsset.manifestUrl = [_savedAsset.manifestUrl stringByReplacingOccurrencesOfString:@"?faxs=1" withString:[[NSString alloc] init]];
    }
}

-(void) replaceContent
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReplaceContentStarted:) name:MEDIA_OPENED object:_playerPlatform];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReplaceContentFailed:) name:MEDIA_FAILED object:_playerPlatform];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReplaceContentEnded:) name:MEDIA_ENDED object:_playerPlatform];
    [_playerPlatform setAutoPlay:true];
    if ([[_currentAlert contentReplaceUrl] rangeOfString:@".m3u8"].location == NSNotFound)
    {
        [_playerPlatform setContentURL:[[_currentAlert contentReplaceUrl] stringByAppendingString:@".m3u8"] withContentOptions:nil];
    }
    else
    {
        [_playerPlatform setContentURL:[_currentAlert contentReplaceUrl] withContentOptions:[[NSDictionary alloc]init]];
    }

}
- (void) onReplaceContentStarted:(NSNotification *)notification
{
    if ([[_playerPlatform getCurrentAsset].manifestUrl rangeOfString:_savedAsset.manifestUrl].location != NSNotFound)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MEDIA_OPENED object:_playerPlatform];
        [_playerPlatform setPosition:_savedAssetPosition];
    }    
}

- (void) onReplaceContentFailed:(NSNotification *)notification
{
    [self restorePlayerState];
}

-(void) onReplaceContentEnded:(NSNotification *)notification
{
    [self restorePlayerState];
}

-(void) restorePlayerState
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MEDIA_ENDED object:_playerPlatform];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MEDIA_FAILED object:_playerPlatform];
    [_playerPlatform setAutoPlay:_savedAutoPlay];
    [_playerPlatform setContentURL:_savedAsset.manifestUrl withContentOptions:_savedAsset.contentOptions];
}

-(void) setAlertText
{
    UIView *playerView = [_playerPlatform getView];
 
    CGSize labelSize = [[_currentAlert getAlertMessage] sizeWithFont:_alertFont];
    _easScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, playerView.frame.size.width, 30)];
    [_easScrollView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth)];
    _easTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelSize.width, 30)];
    _easTextLabel.font = _alertFont;
    _easTextLabel.text = [_currentAlert getAlertMessage];
    _easTextLabel.backgroundColor = _alertBackgroundColor;
    [_easTextLabel setTextColor:_alertTextColor];
    [_easScrollView setBackgroundColor:[UIColor clearColor]];
    [_easScrollView addSubview:_easTextLabel];
    [playerView addSubview:_easScrollView];
}

-(void) startAnimation
{
    UIView *playerView = [_playerPlatform getView];
    _easScrollView.contentOffset = CGPointMake(-(playerView.frame.size.width),0);
	    
	[UIView beginAnimations:@"startAnimation" context:nil];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:_easTextLabel.frame.size.width/(float)50];
	
    _easScrollView.contentOffset = CGPointMake(_easTextLabel.frame.size.width,0);
	
	[UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    isScrolling = false;    
    if ([finished intValue] == 0 && [[_playerPlatform getPlayerStatus] isEqualToString:@"Playing"])
    {
        isScrolling = true;
        [self startAnimation];
    }
    else if([finished intValue] == 0)
    {
        [_easTextLabel removeFromSuperview];
    }
    else
    {
        [_easTextLabel removeFromSuperview];
        EasCompletedData *eventData = [[EasCompletedData alloc] init];
        eventData.identifier = _currentAlert.identifier;
        [[NSNotificationCenter defaultCenter] postNotificationName:EAS_COMPLETE object:self userInfo:[eventData toDictionary]];
    }
}


-(void) initPolling
{
    _alertServiceUrl = [_alertServiceUrl stringByAppendingString:_fipsCode];
    //NSLog(@"Alert Service Url: %@",_alertServiceUrl);

    _pollingTimer = [NSTimer scheduledTimerWithTimeInterval:_updateInterval target:self selector:@selector(onPollingTimer) userInfo:nil repeats:YES];
}

-(void) deactivatePolling
{
    [_pollingTimer invalidate];
    _pollingTimer = nil;
}

-(void) onPollingTimer
{
    NSURLRequest *webRequest = [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:_alertServiceUrl]];
    AFHTTPRequestOperation *alertRequest = [[AFHTTPRequestOperation alloc] initWithRequest:webRequest];
    [alertRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation,id responseObject)
     {
         dispatch_sync(parseQueue, ^{
             [self parseResponseWithData:responseObject];
             if([self alertNeedsPlaying])
             {
                 [self displayNextAlert];
             }
         });
     }failure:^(AFHTTPRequestOperation *operation,NSError *error)
     {
         NSLog(@"Fail");
     }];
    
    [easQueue addOperation:alertRequest];
}

-(void)parseResponseWithData:(NSData*)responseData
{
    NSError *xmlError;
    
    SMXMLDocument *doc = [SMXMLDocument documentWithData:responseData error:&xmlError];
    
    responseData = [[NSMutableData alloc] init];
    
    if(xmlError)
    {
        NSLog(@"Parse Response Failure");
        NSLog(@"String: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    }
    else
    {
        @try
        {
            SMXMLElement *root = doc.root;
            if([root.name isEqualToString:@"zips"])
            {
                SMXMLElement *child = [root childNamed:@"zip"];
                SMXMLElement *zip = [child childNamed:@"countyFips"];
                _fipsCode = zip.value;
                [self initPolling];
            }
            else if([root.name isEqualToString:@"alerts"])
            {
                for (SMXMLElement *alerts in [doc.root childrenNamed:@"alert"])
                {
                    SMXMLElement *identifier = [alerts childNamed:@"identifier"];
                    SMXMLElement *info = [alerts childNamed:@"info"];
                    
                    if([_oldAlertIdentifiers valueForKey:identifier.value] == nil)
                    {
                        Alert *alert;
                        alert = [[Alert alloc] initWithIdentifier:identifier.value];
                        
                        [_oldAlertIdentifiers setObject:@"1" forKey:identifier.value];
                        
                        SMXMLElement *description = [info childNamed:@"description"];
                        SMXMLElement *event = [info childNamed:@"event"];
                        SMXMLElement *effective = [info childNamed:@"effective"];
                        SMXMLElement *expires = [info childNamed:@"expires"];
                        SMXMLElement *instruction = [info childNamed:@"instruction"];
                        
                        if(instruction != nil)
                        {
                            alert.instruction = instruction.value;
                        }
                        
                        if(event != nil)
                        {
                            alert.event = event.value;
                        }
                        if(description != nil)
                        {
                            alert.description = description.value;
                        }
                        if(effective != nil)
                        {
                            alert.effective = effective.value;
                        }
                        if(expires != nil)
                        {
                            alert.expires = expires.value;
                        }
                        if(description != nil)
                        {
                            alert.description = description.value;
                        }
                        
                        
                        NSArray *parameters = [info childrenNamed:@"parameter"];
                        for(SMXMLElement *param in parameters)
                        {
                            if([param childNamed:@"valueName"] != nil)
                            {
                                if([[param childNamed:@"valueName"].value isEqualToString:@"EASText"])
                                {
                                    SMXMLElement *value = [param childNamed:@"value"];
                                    if (value != nil) {
                                        alert.easText = value.value;
                                        break;
                                    }
                                }
                            }
                        }
                        
                        SMXMLElement *resource = [info childNamed:@"resource"];
                        if(resource != nil)
                        {
                            SMXMLElement *uri = [resource childNamed:@"uri"];
                            if(uri != nil)
                            {
                                alert.contentReplaceUrl = uri.value;
                            }
                        }
                        
                        SMXMLElement *area = [info childNamed:@"area"];
                        if (area != nil) {
                            SMXMLElement *areaDesc = [area childNamed:@"areaDesc"];
                            if(areaDesc != nil)
                            {
                                alert.areaDesc = areaDesc.value;
                            }
                        }
                        
                        [_activeAlerts addObject:alert];
                    }
                }
            }
            else
            {
                //todo invalid xml response
            }
        }
        @catch (NSException* e)
        {
            NSLog(@"Exception Caught");
        }
    }
}

-(bool)alertNeedsPlaying
{
    return (_playerPlatform != nil && ([_activeAlerts count]>0) && !isScrolling);
}

@end
