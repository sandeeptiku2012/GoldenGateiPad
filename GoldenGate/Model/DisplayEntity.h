//
//  DisplayEntity.h
//  GoldenGate
//
//  Created by Satish Basavaraj on 10/06/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import "Entity.h"
#import "PGRatingView.h"

typedef enum {
    DisplayEntityAll,
    DisplayEntityShows,
    DisplayEntityChannels
} DisplayEntityType;

@interface DisplayEntity : Entity

@property (copy, nonatomic) NSString *publisher;
@property (copy, nonatomic) NSString *imagePack;
@property (copy, nonatomic) NSString *strGenre; //Genre for channel
@property (assign, nonatomic) PGRating pgRating;
@property (assign, nonatomic) int likeCount;


+(DisplayEntityType)getDisplayEntityFromString:(NSString*)strEntity;
- (id)initWithId:(int)identifier;
- (NSString *)logoURLStringForSize:(CGSize)size;

@end
