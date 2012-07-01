//
//  SixisGameLengthViewController.m
//  SixisTemp
//
//  Created by Jason McIntosh on 6/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisGameLengthViewController.h"
#import "SixisNewGameInfo.h"
#import "SixisPointsGame.h"
#import "SixisRoundsGame.h"
#import "SixisChoosePlayerNumberViewController.h"

@interface SixisGameLengthViewController ()

@end

@implementation SixisGameLengthViewController

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
	return YES;
}

- (IBAction)oneRoundButtonTapped:(id)sender {
    [gameInfo setGameType:[[SixisRoundsGame alloc] initWithRounds:1]];
    SixisChoosePlayerNumberViewController *controller = [[SixisChoosePlayerNumberViewController alloc] init];
    [controller setGameInfo:gameInfo];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)threeRoundButtonTapped:(id)sender {
    [gameInfo setGameType:[[SixisRoundsGame alloc] initWithRounds:3]];
    SixisChoosePlayerNumberViewController *controller = [[SixisChoosePlayerNumberViewController alloc] init];   
    [controller setGameInfo:gameInfo];
    
    [self.navigationController pushViewController:controller animated:YES];

}

- (IBAction)fiveRoundButtonTapped:(id)sender {
    [gameInfo setGameType:[[SixisRoundsGame alloc] initWithRounds:5]];
    SixisChoosePlayerNumberViewController *controller = [[SixisChoosePlayerNumberViewController alloc] init]; 
    [controller setGameInfo:gameInfo];
    
    [self.navigationController pushViewController:controller animated:YES];

}

- (IBAction)pointButtonTapped:(id)sender {
    [gameInfo setGameType:[[SixisPointsGame alloc] initWithGoal:600]];
    SixisChoosePlayerNumberViewController *controller = [[SixisChoosePlayerNumberViewController alloc] init];
    [controller setGameInfo:gameInfo];
    
    [self.navigationController pushViewController:controller animated:YES];
}
@end
