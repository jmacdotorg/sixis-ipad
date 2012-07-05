//
//  SixisPlayerSetupViewController.m
//  SixisTemp
//
//  Created by Jason McIntosh on 6/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisPlayerSetupViewController.h"
#import "SixisNewGameInfo.h"
#import "SixisPlayerSetupCell.h"
#import "SixisGame.h"
#import "SixisRobot.h"
#import "SixisHuman.h"

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
        
    // Put a Done button on the nav bar.
    doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTapped:)];
    [[self navigationItem] setRightBarButtonItem:doneButton];
    
    [self tableView].rowHeight = 80;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ( [gameInfo gameHasTeams] ) {
        return 2;        
    }
    else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( [gameInfo gameHasTeams] ) {
        return 2;
    }
    else {
        return [gameInfo numberOfPlayers];
    }
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
    
    return cell;
}


#pragma mark - Table view delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ( [gameInfo gameHasTeams] ) {
        if ( section == 0 ) {
            return @"Team One";
        }
        else {
            return @"Team Two";
        }
    }
    else {
        return nil;
    }
}

// XXX Not sure this needs to be an IBAction...
-(IBAction)doneTapped:(id)sender {
    // Create the game! But at this point we have nowhere to put it...
    
    NSMutableArray *players = [[NSMutableArray alloc] init];
    for (int i = 0; i < gameInfo.numberOfPlayers; i++ ) {
        int section = 0;
        if ( gameInfo.gameHasTeams && i > 1 ) {
            section = 1;
        }
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:section];
        UITableViewCell *rawCell = [[self tableView] cellForRowAtIndexPath:path];
        
        SixisPlayerSetupCell *cell = (SixisPlayerSetupCell *)rawCell;
        
        if ( cell.humanOrBotControl.selectedSegmentIndex == 0 ) {
            [players addObject:[[SixisHuman alloc] initWithName:cell.nameField.text]];
        }
        else {
            [players addObject:[[SixisRobot alloc] initWithName:cell.nameField.text]];
        }
        
    }
    
    SixisGame *game = [[SixisGame alloc] initWithGameType:gameInfo.gameType PlayersType:gameInfo.playersType Players:[NSArray arrayWithArray:players]];
    
    NSLog(@"I have a game, hurray. %@", game);
    
}

@end
