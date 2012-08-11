//
//  SixisCardPopoverViewController.m
//  Sixis
//
//  Created by Jason McIntosh on 8/3/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisCardPopoverViewController.h"
#import "SixisTabletopViewController.h"
#import "SixisPlayerTableInfo.h"
#import "SixisPlayer.h"
#import "SixisCard.h"

@interface SixisCardPopoverViewController ()

@end

@implementation SixisCardPopoverViewController

@synthesize player, card, rotation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.contentSizeForViewInPopover = CGSizeMake(166, 122);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(void)setRotation:(CGFloat)newRotation {
    rotation = newRotation;
    self.view.transform = CGAffineTransformMakeRotation( rotation );
    
    // If the rotation is 90 degrees, swap the height & width of this popover.
    // Comparison is weird becaue I dunno how to use the == operator with the M_PI constants?
    NSLog(@"Rotation is %f. M_PI_2 is %f.", rotation, M_PI_2 + M_PI);
    if ( ( rotation > 1.5 && rotation < 1.6 ) || ( rotation > 4.7 && rotation < 4.8 ) ) {
        NSLog(@"Yeps.");
        self.contentSizeForViewInPopover = CGSizeMake(122, 166);
    }
}

- (IBAction)handleTakeCardTap:(id)sender {
    [self.parent handleTakeCardTap:card];
}

- (IBAction)handleFlipCardTap:(id)sender {
    [self.parent handleFlipCardTap:self.card];
}
@end
