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


@interface SixisMainMenuViewController ()

@end

@implementation SixisMainMenuViewController
@synthesize controlsView;

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
    
    // XXX Cheating! The player needs to pick this, of course...
    gameInfo.gameType = [[SixisRoundsGame alloc] initWithRounds:1];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:numberController];
    
//    navigationController.navigationBar.alpha = .1;
    
    [[navigationController view] setFrame:[controlsView frame]];
    [self.view addSubview:navigationController.view];
    [self addChildViewController:navigationController];
    
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
	return YES;
}

- (IBAction)handlePlayButton:(id)sender {
}
@end
