//
//  SixisTeamOrNotViewController.m
//  SixisTemp
//
//  Created by Jason McIntosh on 6/22/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisTeamOrNotViewController.h"
#import "SixisPlayerSetupViewController.h"
#import "SixisGameLengthViewController.h"
#import "SixisNewGameInfo.h"
#import "SixisMainMenuViewController.h"

@interface SixisTeamOrNotViewController ()

@end

@implementation SixisTeamOrNotViewController

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

-(void)viewDidAppear:(BOOL)animated {
    [(SixisMainMenuViewController *)self.view.window.rootViewController hidePartnerArrangement];
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

- (IBAction)yesButtonTapped:(id)sender {
    // Tell the main controller to display the "Foo is your partner" labels.
    [(SixisMainMenuViewController *)self.view.window.rootViewController displayPartnerArangementWithGameInfo:gameInfo];

    // Now update the gameInfo object, and continue.
    [gameInfo setGameHasTeams:YES];    
    SixisGameLengthViewController *controller = [[SixisGameLengthViewController alloc] init];
    [controller setGameInfo:gameInfo];
    [self.navigationController pushViewController:controller animated:NO];
}

- (IBAction)noButtonTapped:(id)sender {
    [gameInfo setGameHasTeams:NO];
    SixisGameLengthViewController *controller = [[SixisGameLengthViewController alloc] init];
    [controller setGameInfo:gameInfo];
    [self.navigationController pushViewController:controller animated:NO];}
@end
