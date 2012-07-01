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
#import "SixisTeamOrNotViewController.h"

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

- (IBAction)twoPlayerButtonTapped:(id)sender {
    [gameInfo setPlayersType:[[SixisTwoPlayers alloc] init]];
    [gameInfo setGameHasTeams:NO];
    [gameInfo setNumberOfPlayers:2];
    SixisPlayerSetupViewController *controller = [[SixisPlayerSetupViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [controller setGameInfo:gameInfo];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)threePlayerButtonTapped:(id)sender {
    [gameInfo setPlayersType:[[SixisThreePlayers alloc] init]];
    [gameInfo setGameHasTeams:NO];
    [gameInfo setNumberOfPlayers:3];
    SixisPlayerSetupViewController *controller = [[SixisPlayerSetupViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [controller setGameInfo:gameInfo];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)fourPlayerButtonTapped:(id)sender {
    [gameInfo setPlayersType:[[SixisFourPlayers alloc] init]];
    [gameInfo setNumberOfPlayers:4];
    SixisTeamOrNotViewController *controller = [[SixisTeamOrNotViewController alloc] init];
    [controller setGameInfo:gameInfo];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
