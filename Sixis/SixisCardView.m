//
//  SixisCardView.m
//  Sixis
//
//  Created by Jason McIntosh on 7/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisCardView.h"
#import "SixisCard.h"
#import "SixisGame.h"
#import "SixisPlayerTableInfo.h"
#import "SixisTabletopViewController.h"

@implementation SixisCardView

@synthesize card;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.adjustsImageWhenDisabled = NO;
        self.enabled = NO;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void) setCard:(SixisCard *)newCard {
    SixisCard *oldCard = card;
    card = newCard;
    // Also set this object's image.
    if ( newCard == nil ) {
        // This card is getting picked up! Animate it flying towards its new owner.
        SixisPlayerTableInfo *info = [[SixisPlayerTableInfo alloc] init];
        info.game = oldCard.game;
        info.player = oldCard.game.currentPlayer;
        
        CGPoint origin = self.center;
        CGPoint destPoint = [info cardFlingCenter];
        
        SixisTabletopViewController *tabletop = (SixisTabletopViewController *)self.window.rootViewController;
        [UIView animateWithDuration:1
                         animations:^{
                             tabletop.aCardAnimationIsOccurring = YES;
                             self.center = destPoint;
                         }
                         completion:^(BOOL finished){
                             [self setImage:nil forState:UIControlStateNormal];
                             self.center = origin;
                             tabletop.aCardAnimationIsOccurring = NO;
                         }];
        
        self.enabled = NO;
    }
    else {
        // We've set a new card object for this view. Set its image to the image whose filename
        // matches the card's classname (minus the "SixisCard" prefix).
        NSString *cardClass = [NSStringFromClass([newCard class]) substringFromIndex:9];
        UIImage *image = [UIImage imageNamed:cardClass];
        [self setImage:image forState:UIControlStateNormal];
        
        NSString *highlightedFile = [NSString stringWithFormat:@"%@Highlight2", cardClass];
        UIImage *highlightedImage2 = [UIImage imageNamed:highlightedFile];
        UIImage *highlightedImage1 = [UIImage imageNamed:[NSString stringWithFormat:@"%@Highlight1", cardClass]];
        UIImage *highlightedImage3 = [UIImage imageNamed:[NSString stringWithFormat:@"%@Highlight3", cardClass]];
        UIImage *animatedImage = [UIImage animatedImageWithImages:@[ highlightedImage1, highlightedImage2, highlightedImage1, image, image, image, image, image, image] duration:1];
        
        [UIView transitionWithView:self
                          duration:1
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{ [self setImage:animatedImage forState:UIControlStateSelected]; }
                        completion:NULL];
        
//        [self setImage:animatedImage forState:UIControlStateSelected];

    }
}

@end
