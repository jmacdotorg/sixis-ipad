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
        // Initialization code
    }
    return self;
}

-(void)setDie:(SixisDie *)newDie {
    die = newDie;
    // Also set this object's image.
    if ( newDie == nil ) {
        // Oh, we've removed the die? Then we'll remove the image, too.
        [self setImage:nil forState:UIControlStateNormal];
    }
    else {
        // We've set a new die object for this view. Set its image appropriately.
        // This way of getting the color substring isn't awesome.
        NSString *colorName = [SixisDieView nameForColor:die.color];

        NSString *dieImage = [NSString stringWithFormat:@"Die%@%d", colorName, [die value]];
        NSString *selectedImage = [NSString stringWithFormat:@"Die%@Selected%d", colorName,[die value]];
        UIImage *image = [UIImage imageNamed:dieImage];
        [self setImage:image forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    }
}

+(NSString *)nameForColor:(UIColor *)color {
    NSString *colorName;
    if ( [color isEqual:[UIColor whiteColor]] ) {
        colorName = @"White";
    }
    else if ( [color isEqual:[UIColor blackColor]] ) {
        colorName = @"Black";
    }
    else if ( [color isEqual:[UIColor greenColor]] ) {
        colorName = @"Green";
    }
    else if ( [color isEqual:[UIColor purpleColor]] ) {
        colorName = @"Purple";
    }
    else if ( [color isEqual:[UIColor redColor]] ) {
        colorName = @"Red";
    }
    else {
        colorName = @"Blue";
    }
    return colorName;
}


@end
