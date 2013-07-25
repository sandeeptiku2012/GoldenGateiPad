//
//  PGRatingView.m
//  GoldenGate
//
//  Created by Andreas Petrov on 8/15/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "PGRatingView.h"

@interface PGRatingView()

@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingIconView;

@end


@implementation PGRatingView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        UIView *contentView = [[[NSBundle mainBundle]loadNibNamed:@"PGRatingView"
                                                            owner:self
                                                          options:nil]objectAtIndex:0];
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:contentView];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (NSString *)textForRating:(PGRating)rating
{
    NSString *ratingText = @"";
    switch (rating)
    {
        case PgRatingNotRated:
            break;
        case PgRatingChildren:
            ratingText = @"TV-Y";
            break;
        case PgRatingOlderChildren:
            ratingText = @"TV-Y7";
            break;
        case PgRatingGeneralAudience:
            ratingText = @"TV-G";
            break;
        case PgRatingParentalGuidance:
            ratingText = @"TV-PG";
            break;
        case PgRatingParentsStronglyCautioned:
            ratingText = @"TV-14";
            break;
        case PgRatingParentsMatureAudience:
            ratingText = @"TV-MA";
            break;
    }

    return ratingText;
}

- (UIImage *)imageForRating:(PGRating)rating
{
    return nil;
}

- (void)updateFromRating
{
    self.hidden = self.rating == PgRatingNotRated;
    
    self.ratingLabel.text       = [self textForRating:self.rating];
    self.ratingIconView.image   = [self imageForRating:self.rating];
}

- (void)setRating:(PGRating)rating
{
    _rating = rating;
    
    [self updateFromRating];
}

@end
