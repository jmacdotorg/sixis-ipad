//
//  SixisFirstActionsViewController.m
//  Sixis
//
//  Created by Jason McIntosh on 9/10/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisFirstActionsViewController.h"
#import "SixisMainMenuViewController.h"
#import "SixisChoosePlayerNumberViewController.h"

@interface SixisFirstActionsViewController ()

@end

@implementation SixisFirstActionsViewController

@synthesize gameInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        return YES;
    }
    else {
        return NO;
    }
}

- (IBAction)handlePlayButton:(id)sender {
    SixisChoosePlayerNumberViewController *controller = [[SixisChoosePlayerNumberViewController alloc] init];
    [controller setGameInfo:gameInfo];

    [(SixisMainMenuViewController *)self.view.window.rootViewController showRulesCard];
    [(SixisMainMenuViewController *)self.view.window.rootViewController backButton].hidden = NO;
    
    [self.navigationController pushViewController:controller animated:NO];
}

- (IBAction)handleAboutButton:(id)sender {
    [(SixisMainMenuViewController *)self.view.window.rootViewController showAboutCard];
}

-(void)viewDidAppear:(BOOL)animated {
    [(SixisMainMenuViewController *)self.view.window.rootViewController resetHelperViews];
}

@end
