//
//  SixisPlayerSetupViewController.m
//  SixisTemp
//
//  Created by Jason McIntosh on 6/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisPlayerSetupViewController.h"
#import "SixisTabletopViewController.h"
#import "SixisNewGameInfo.h"
#import "SixisPlayerSetupCell.h"
#import "SixisGame.h"
#import "SixisSmartbot.h"
#import "SixisHuman.h"
#import "SixisMainMenuViewController.h"
#import "SixisDie.h"
#import "SixisDieView.h"

@interface SixisPlayerSetupViewController ()

@end

@implementation SixisPlayerSetupViewController

@synthesize gameInfo;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Load the NIB file for the player-setup table cells
    UINib *nib = [UINib nibWithNibName:@"SixisPlayerSetupCell" bundle:nil];
    
    // Register it
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"SixisPlayerSetupCell"];
        
    [self tableView].rowHeight = 127;
    
    // Messing around with transparency.
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.opaque = NO;
    self.tableView.backgroundView = nil;
    self.tableView.separatorColor = [UIColor clearColor];
    
    // All the nascent players get random die colors.
    gameInfo.playerColors = [[NSMutableArray alloc] init];
    for (int i = 1; i <= gameInfo.numberOfPlayers; i++) {
        [gameInfo.playerColors addObject:[NSNull null]];
    }
    self.unusedColors = [[NSMutableSet alloc] initWithArray:@[[UIColor whiteColor], [UIColor blackColor], [UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor purpleColor]]];
    for (int i = 1; i <= gameInfo.numberOfPlayers; i++) {
        [self assignAnyUnusedColorToPlayerNumber:i];
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewDidAppear:(BOOL)animated {
    [(SixisMainMenuViewController *)self.view.window.rootViewController startButton].hidden = NO;
}

-(void)viewDidDisappear:(BOOL)animated {

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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [gameInfo numberOfPlayers];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SixisPlayerSetupCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    SixisPlayerSetupCell *playerCell = (SixisPlayerSetupCell *)cell;
    playerCell.nameField.text = [NSString stringWithFormat:@"Player %i", ( indexPath.section * 2 ) + indexPath.row + 1];
    
    // Set the die image.
    /*
    NSString *dieImageName = [NSString stringWithFormat:@"DieBlue%d", indexPath.row + 1];
    UIImage *dieImage = [UIImage imageNamed:dieImageName];
    playerCell.dieImage.image = dieImage;
    */
    SixisDieView *dieButton = playerCell.dieButton;
    SixisDie *die = [[SixisDie alloc] init];
    die.color = [gameInfo.playerColors objectAtIndex:indexPath.row];
    die.value = indexPath.row + 1;
    dieButton.die = die;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    playerCell.playerNumber = indexPath.row + 1;
    playerCell.parent = self;
    
    playerCell.backgroundColor = [UIColor clearColor];
    
    return cell;
}


#pragma mark - Table view delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

//-(IBAction)doneTapped:(id)sender {
-(void)doneTapped:(id)sender {
    // Create the game! But at this point we have nowhere to put it...
    
    NSMutableArray *players = [[NSMutableArray alloc] init];
    for (int i = 0; i < gameInfo.numberOfPlayers; i++ ) {
        int section = 0;
        int row = i;

        NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
        UITableViewCell *rawCell = [[self tableView] cellForRowAtIndexPath:path];
        
        SixisPlayerSetupCell *cell = (SixisPlayerSetupCell *)rawCell;
        
        if ( cell.humanOrBotControl.selectedSegmentIndex == 0 ) {
            [players addObject:[[SixisHuman alloc] initWithName:cell.nameField.text dieColor:[gameInfo.playerColors objectAtIndex:i]]];
        }
        else {
            [players addObject:[[SixisSmartbot alloc] initWithName:cell.nameField.text dieColor:[gameInfo.playerColors objectAtIndex:i]]];
        }
        
    }
    
    SixisGame *game = [[SixisGame alloc] initWithGameType:gameInfo.gameType PlayersType:gameInfo.playersType Players:[NSArray arrayWithArray:players]];
    if ([gameInfo gameHasTeams]) {
        game.hasTeams = YES;
    }
    else {
        game.hasTeams = NO;
    }
    
    SixisTabletopViewController *tabletop = gameInfo.tabletopController;
    tabletop.game = game;
    [(SixisMainMenuViewController *)self.view.window.rootViewController resetHelperViews];

    self.view.window.rootViewController = tabletop;
    [game startGame];
    
}

-(void)assignAnyUnusedColorToPlayerNumber:(int)playerNumber {
    UIColor *newColor = [self.unusedColors anyObject];
    [self assignColor:newColor toPlayerNumber:playerNumber];
}

-(void)assignColor:(UIColor *)newColor toPlayerNumber:(int)playerNumber {
    // First make sure that nobody else has this color.
    for ( int i = 1; i <= gameInfo.numberOfPlayers; i++ ) {
        if ( i != playerNumber ) {
            if ( [[gameInfo.playerColors objectAtIndex:i - 1] isEqual:newColor] ) {
                [self assignAnyUnusedColorToPlayerNumber:i];
                NSIndexPath *path = [NSIndexPath indexPathForRow:i-1 inSection:0];
                SixisPlayerSetupCell *cell = [self.tableView cellForRowAtIndexPath:path];
                SixisDie *die = [[SixisDie alloc] init];
                die.color = [gameInfo.playerColors objectAtIndex:i - 1];
                die.value = i;
                cell.dieButton.die = die;
            }
        }
    }
    UIColor *oldColor = (UIColor *)[gameInfo.playerColors objectAtIndex:playerNumber - 1];
    if ( ! [oldColor isEqual:[NSNull null]] ) {
        [self.unusedColors addObject:oldColor];
    }
    [self.unusedColors removeObject:newColor];
    [gameInfo.playerColors replaceObjectAtIndex:playerNumber - 1 withObject:newColor];
}

@end
