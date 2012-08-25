//
//  SixisMainMenuViewController.m
//  Sixis
//
//  Created by Jason McIntosh on 8/15/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisMainMenuViewController.h"
#import "SixisChoosePlayerNumberViewController.h"
#import "SixisNewGameInfo.h"
#import "SixisRoundsGame.h"
#import "SixisTabletopViewController.h"


@interface SixisMainMenuViewController ()

@end

@implementation SixisMainMenuViewController
@synthesize controlsView, tabletopController;

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
        
    SixisChoosePlayerNumberViewController *numberController = [[SixisChoosePlayerNumberViewController alloc] init];
    
    SixisNewGameInfo *gameInfo = [[SixisNewGameInfo alloc] init];
    [numberController setGameInfo:gameInfo];
    
    // Create the tabletop view controller. This is destined to get passed around for the rest of the app's lifetime.
    tabletopController = [[SixisTabletopViewController alloc] init];
    [tabletopController setMainMenuController:self];
    [gameInfo setTabletopController:tabletopController];
    
    navController = [[UINavigationController alloc] initWithRootViewController:numberController];
    
    [[navController view] setFrame:[controlsView frame]];
    [self.view addSubview:navController.view];
    [self addChildViewController:navController];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [navController popToRootViewControllerAnimated:NO];
    
    if ( tabletopController.game != nil ) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc removeObserver:tabletopController.game];
        for (SixisPlayer *player in tabletopController.game.players) {
            [nc removeObserver:player];
        }
    }
}

- (void)viewDidUnload
{
    [self setControlsView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft
        || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    }
    else {
        return NO;
    }
}

- (IBAction)handlePlayButton:(id)sender {
}
@end
