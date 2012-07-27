//
//  SixisCardView.m
//  Sixis
//
//  Created by Jason McIntosh on 7/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisCardView.h"
#import "SixisCard.h"

@implementation SixisCardView

@synthesize card;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
    card = newCard;
    // Also set this object's image.
    if ( newCard == nil ) {
        // Oh, we've removed the card? Then we'll remove the image, too.
        [self setImage:nil];
    }
    else {
        // We've set a new card object for this view. Set its image to the image whose filename
        // matches the card's classname (minus the "SixisCard" prefix).
        NSString *cardClass = [NSStringFromClass([newCard class]) substringFromIndex:9];
        UIImage *image = [UIImage imageNamed:cardClass];
        [self setImage:image];
    }
}

@end
