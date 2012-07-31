//
//  SixisDieView.m
//  Sixis
//
//  Created by Jason McIntosh on 7/24/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisDieView.h"
#import "SixisDie.h"

@implementation SixisDieView

@synthesize die;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Cover myself with a button
    }
    return self;
}

-(void)setDie:(SixisDie *)newDie {
    die = newDie;
    // Also set this object's image.
    if ( newDie == nil ) {
        // Oh, we've removed the die? Then we'll remove the image, too.
        [self setImage:nil];
    }
    else {
        // We've set a new die object for this view. Set its image appropriately.
        // XXX Wer'e gonna wanna update this to get the right color.
        NSString *dieImage = [NSString stringWithFormat:@"DieBlue%d", [die value]];
        UIImage *image = [UIImage imageNamed:dieImage];
        [self setImage:image];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
