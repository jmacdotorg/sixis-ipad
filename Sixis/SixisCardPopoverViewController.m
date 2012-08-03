//
//  SixisCardPopoverViewController.m
//  Sixis
//
//  Created by Jason McIntosh on 8/3/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisCardPopoverViewController.h"
#import "SixisTabletopViewController.h"
#import "SixisPlayer.h"
#import "SixisCard.h"

@interface SixisCardPopoverViewController ()

@end

@implementation SixisCardPopoverViewController

@synthesize player, card;

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
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)handleTakeCardTap:(id)sender {
    [self.parent handleTakeCardTap:card];
}

- (IBAction)handleFlipCardTap:(id)sender {
    [self.parent handleFlipCardTap:self.card];
}
@end
