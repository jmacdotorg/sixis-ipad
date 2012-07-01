//
//  SixisTeamOrNotViewController.m
//  SixisTemp
//
//  Created by Jason McIntosh on 6/22/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisTeamOrNotViewController.h"
#import "SixisPlayerSetupViewController.h"
#import "SixisNewGameInfo.h"

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
    [gameInfo setGameHasTeams:YES];    
    SixisPlayerSetupViewController *controller = [[SixisPlayerSetupViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [controller setGameInfo:gameInfo];
    [self.navigationController pushViewController:controller animated:YES];    
}

- (IBAction)noButtonTapped:(id)sender {
    [gameInfo setGameHasTeams:NO];
    SixisPlayerSetupViewController *controller = [[SixisPlayerSetupViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [controller setGameInfo:gameInfo];
    [self.navigationController pushViewController:controller animated:YES];}
@end
