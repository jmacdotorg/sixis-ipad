//
//  SixisMainMenuViewController.m
//  Sixis
//
//  Created by Jason McIntosh on 8/15/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisMainMenuViewController.h"
#import "SixisFirstActionsViewController.h"
#import "SixisNewGameInfo.h"
#import "SixisRoundsGame.h"
#import "SixisTabletopViewController.h"
#import "SixisPlayerTableInfo.h"


@interface SixisMainMenuViewController ()

@end

@implementation SixisMainMenuViewController
@synthesize controlsView, tabletopController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        seatLabels = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        
    SixisFirstActionsViewController *numberController = [[SixisFirstActionsViewController alloc] init];
    
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

// Given a gameInfo object, draw "PlayerN sits here!" labels along the "wooden" edges of the tabletop, as appropriate.
-(void)displaySeatingArrangementWithGameInfo:(SixisNewGameInfo *)gameInfo {
    for (int i = 1; i <= gameInfo.numberOfPlayers; i++ ) {
        SixisPlayerTableInfo *tableInfo = [[SixisPlayerTableInfo alloc] init];
        tableInfo.playerCount = gameInfo.numberOfPlayers;
        tableInfo.playerNumber = i;
        UILabel *seatlabel = [[[NSBundle mainBundle] loadNibNamed:@"SixisSitsHereLabel" owner:self options:nil] objectAtIndex:0];
        [[self view] addSubview:seatlabel];
        seatlabel.frame = [tableInfo statusFrame];
        seatlabel.transform = CGAffineTransformMakeRotation([tableInfo rotation]);
        seatlabel.text = [NSString stringWithFormat:@"Player %d sits here!", i];
        [seatLabels addObject:seatlabel];
    }
}

-(void)hideSeatingArrangement {
    for (UILabel *seatlabel in seatLabels) {
        [seatlabel removeFromSuperview];
    }
    seatLabels = [[NSMutableArray alloc] init];
}

@end
