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
#import "SixisPlayer.h"
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
        // This card is getting picked up!
        
        // Remove the card image from the original (and permanent) card view.
        [self setImage:nil forState:UIControlStateNormal];
        
        SixisPlayerTableInfo *info = [[SixisPlayerTableInfo alloc] init];
        info.playerCount = oldCard.game.players.count;
        info.playerNumber = oldCard.game.currentPlayer.number;
        
        // Make a copy of this card's view, sitting on top of the card.
        SixisCardView *copy = [[SixisCardView alloc] initWithFrame:self.frame];
        [copy setCard:oldCard];
        [copy setTransform:self.transform];
        [self.superview addSubview:copy];
        
        // Animate the copy flying towards the player who picked it up. Then throw it out.
        CGPoint destPoint = [info cardFlingCenter];
        
        [UIView animateWithDuration:1
                         animations:^{
                             copy.center = destPoint;
                         }
                         completion:^(BOOL finished){
                             [copy removeFromSuperview];
                         }];
        
        self.enabled = NO;
    }
    else {
        // We've set a new card object for this view. Set its image to the image whose filename
        // matches the card's classname (minus the "SixisCard" prefix).
        NSString *cardClass = [NSStringFromClass([newCard class]) substringFromIndex:9];
        UIImage *image = [UIImage imageNamed:cardClass];
        
        NSString *highlightedFile = [NSString stringWithFormat:@"%@Highlight2", cardClass];
        UIImage *highlightedImage2 = [UIImage imageNamed:highlightedFile];
        UIImage *highlightedImage1 = [UIImage imageNamed:[NSString stringWithFormat:@"%@Highlight1", cardClass]];
        UIImage *highlightedImage3 = [UIImage imageNamed:[NSString stringWithFormat:@"%@Highlight3", cardClass]];
        UIImage *animatedImage = [UIImage animatedImageWithImages:@[ highlightedImage1, highlightedImage2, highlightedImage3, highlightedImage2, highlightedImage1, image, image, image, image, image] duration:1];

        [UIView transitionWithView:self
                          duration:1
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{ 
                            [self setImage:animatedImage forState:UIControlStateSelected];
                            [self setImage:image forState:UIControlStateNormal];
                        }
                        completion:NULL];
        
    }
}

@end
