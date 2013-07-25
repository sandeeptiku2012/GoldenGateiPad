//
//  Error.h
//  GoldenGate
//
//  Created by Erik Engheim on 20.08.12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *kVimondErrorDomain;

typedef enum VimondErroCodes {
    ErrorUnableToGetFrontPageChannels = 1,
    ErrorJSONParsingContentPanel,
    ErrorUnableToGetChannel,
    ErrorUnableToGetVideoCount,
    ErrorUnableToGetCategory,
    ErrorUnableToGetPlaybackInfo,
    ErrorLoginFailed,
    ErrorLogoutFailed,
    ErrorJSONLoginResponse,           // failed to parse login response
    ErrorJSONParsingCategory,
    ErrorJSONParsingChannel,
    ErrorUnableToGetVideo,
    ErrorJSONParsingVideo,
    ErrorJSONParsingPlaybackInfo,
    ErrorWrongKeyPath,
    ErrorObjectDoesNotExist,
    ErrorJSONResponseIncomplete,
    ErrorNo
} VimondErroCodes;