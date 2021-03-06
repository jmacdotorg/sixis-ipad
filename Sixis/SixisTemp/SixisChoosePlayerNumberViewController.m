//
//  SixisChoosePlayerNumberViewController.m
//  SixisTemp
//
//  Created by Jason McIntosh on 6/20/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisChoosePlayerNumberViewController.h"
#import "SixisTwoPlayers.h"
#import "SixisThreePlayers.h"
#import "SixisFourPlayers.h"
#import "SixisPlayerSetupViewController.h"
#import "SixisGameLengthViewController.h"
#import "SixisTeamOrNotViewController.h"
#import "SixisMainMenuViewController.h"

@interface SixisChoosePlayerNumberViewController ()

@end

@implementation SixisChoosePlayerNumberViewController

@synthesize gameInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {


        
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated {
    [(SixisMainMenuViewController *)self.view.window.rootViewController hideSeatingArrangement];
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
	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    }
    else {
        return NO;
    }
}


- (IBAction)twoPlayerButtonTapped:(id)sender {
    [gameInfo setPlayersType:[[SixisTwoPlayers alloc] init]];
    [gameInfo setGameHasTeams:NO];
    [gameInfo setNumberOfPlayers:2];

    SixisGameLengthViewController *controller = [[SixisGameLengthViewController alloc] init];
    [controller setGameInfo:gameInfo];
    [self.navigationController pushViewController:controller animated:NO];
    [(SixisMainMenuViewController *)self.view.window.rootViewController displaySeatingArrangementWithGameInfo:gameInfo];

}

- (IBAction)threePlayerButtonTapped:(id)sender {
    [gameInfo setPlayersType:[[SixisThreePlayers alloc] init]];
    [gameInfo setGameHasTeams:NO];
    [gameInfo setNumberOfPlayers:3];
    
    SixisGameLengthViewController *controller = [[SixisGameLengthViewController alloc] init];
    [controller setGameInfo:gameInfo];
    [self.navigationController pushViewController:controller animated:NO];
    [(SixisMainMenuViewController *)self.view.window.rootViewController displaySeatingArrangementWithGameInfo:gameInfo];

}

- (IBAction)fourPlayerButtonTapped:(id)sender {
    [gameInfo setPlayersType:[[SixisFourPlayers alloc] init]];
    [gameInfo setNumberOfPlayers:4];
    SixisTeamOrNotViewController *controller = [[SixisTeamOrNotViewController alloc] init];
    [controller setGameInfo:gameInfo];
    [self.navigationController pushViewController:controller animated:NO];
    [(SixisMainMenuViewController *)self.view.window.rootViewController displaySeatingArrangementWithGameInfo:gameInfo];
}

@end
