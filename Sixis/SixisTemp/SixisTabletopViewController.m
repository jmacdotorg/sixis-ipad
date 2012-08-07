//
//  SixisTabletopViewController.m
//  Sixis
//
//  Created by Jason McIntosh on 7/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisTabletopViewController.h"
#import "SixisCardPopoverViewController.h"
#import "SixisGame.h"
#import "SixisCardView.h"
#import "SixisPlayer.h"
#import "SixisHuman.h"
#import "SixisDieView.h"
#import "SixisCard.h"
#import "SixisDie.h"
#import "SixisPlayerTableInfo.h"
#import "SixisPlayersType.h"

@interface SixisTabletopViewController ()

@end

@implementation SixisTabletopViewController
@synthesize endRoundButton;
@synthesize winMessage;
@synthesize rollAllDiceButton;
@synthesize rollUnlockedDiceButton;
@synthesize endTurnButton;
@synthesize diceView;

@synthesize game, currentPlayer;

#define NAME_LABEL_TAG 1
#define SCORE_LABEL_TAG 2
#define DICE_BANK_TAG 3

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        cards = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Register for various notifications.
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(handleNewTurn:) name:@"SixisNewTurn" object:nil];
    [nc addObserver:self selector:@selector(handleCardPickup:) name:@"SixisPlayerTookCard" object:nil];
    [nc addObserver:self selector:@selector(handleCardFlip:) name:@"SixisPlayerFlippedCard" object:nil];
    [nc addObserver:self selector:@selector(handleDiceLock:) name:@"SixisPlayerLockedDice" object:nil];
    [nc addObserver:self selector:@selector(handleDiceRoll:) name:@"SixisPlayerRolledDice" object:nil];
    [nc addObserver:self selector:@selector(handleWinning:) name:@"SixisPlayersWon" object:nil];
    [nc addObserver:self selector:@selector(handleDealtCard:) name:@"SixisCardDealt" object:nil];
    
    // Load the player-controls view from its XIB.
    playerControls = [[[NSBundle mainBundle] loadNibNamed:@"SixisPlayerControls" owner:self options:nil] objectAtIndex:0];
    [[self view] addSubview:playerControls];

}

- (void)viewDidUnload
{
    [self setWinMessage:nil];
    [self setRollAllDiceButton:nil];
    [self setRollUnlockedDiceButton:nil];
    [self setEndTurnButton:nil];
    [self setDiceView:nil];
    [self setEndRoundButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(void)_addCardViewWithX:(int)x Y:(int)y rotation:(CGFloat)rotation {
    CGRect frame = CGRectMake(x, y, 118.75, 170.05);

    SixisCardView *cardView = [[SixisCardView alloc] initWithFrame:frame];
    [cards addObject:cardView];
    
    if ( rotation > 0 ) {
        CGAffineTransform xform = CGAffineTransformMakeRotation( rotation );
        cardView.transform = xform;
    }
    
    [cardView addTarget:self action:@selector(handleCardTap:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:cardView];
}

-(void)setGame:(SixisGame *)newGame {
    game = newGame;
    // Define all of this game's cardviews, then place them onto the tabletop view.
    if ( [game players].count == 2 ) {
        [self _addCardViewWithX:450 Y:282 rotation:M_PI_2];

        [self _addCardViewWithX:54 Y:442 rotation:0];
        [self _addCardViewWithX:186 Y:442 rotation:0];
        [self _addCardViewWithX:318 Y:442  rotation:0];
        [self _addCardViewWithX:450 Y:442  rotation:0];

        [self _addCardViewWithX:450 Y:125  rotation:0];
        [self _addCardViewWithX:582 Y:125  rotation:0];
        [self _addCardViewWithX:714 Y:125  rotation:0];
        [self _addCardViewWithX:846 Y:125  rotation:0];
    }
    else if ( [game players].count == 3 ) {
        [self _addCardViewWithX:450 Y:282 rotation:M_PI_2];
        
        [self _addCardViewWithX:53 Y:282 rotation:0];
        [self _addCardViewWithX:177 Y:282 rotation:0];
        [self _addCardViewWithX:301 Y:282  rotation:0];
        
        [self _addCardViewWithX:560 Y:167  rotation:M_PI_4 * 7];
        [self _addCardViewWithX:685 Y:117  rotation:M_PI_4 * 7];
        [self _addCardViewWithX:810 Y:67  rotation:M_PI_4 * 7];
        
        [self _addCardViewWithX:560 Y:400  rotation:M_PI_4];
        [self _addCardViewWithX:685 Y:450  rotation:M_PI_4];
        [self _addCardViewWithX:810 Y:505  rotation:M_PI_4];
    }
    else {
        [self _addCardViewWithX:450 Y:282 rotation:M_PI_2];
        
        [self _addCardViewWithX:93 Y:67 rotation:M_PI_4 + M_PI];
        [self _addCardViewWithX:217 Y:117 rotation:M_PI_4 + M_PI];
        [self _addCardViewWithX:341 Y:167  rotation:M_PI_4 + M_PI];
        
        [self _addCardViewWithX:560 Y:167  rotation:M_PI_4 * 7];
        [self _addCardViewWithX:685 Y:117  rotation:M_PI_4 * 7];
        [self _addCardViewWithX:810 Y:67  rotation:M_PI_4 * 7];
        
        [self _addCardViewWithX:560 Y:400  rotation:M_PI_4];
        [self _addCardViewWithX:685 Y:450  rotation:M_PI_4];
        [self _addCardViewWithX:810 Y:505  rotation:M_PI_4];
        
        [self _addCardViewWithX:93 Y:505 rotation:M_PI_4 + M_PI_2];
        [self _addCardViewWithX:217 Y:450 rotation:M_PI_4 + M_PI_2];
        [self _addCardViewWithX:341 Y:400  rotation:M_PI_4 + M_PI_2];
    }
    
    
    // Generate all the players' status bars, and store them in an instance variable.
    NSMutableArray *tableInfos = [[NSMutableArray alloc] init];
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    for (SixisPlayer *player in [game players] ) {
        UIView *statusBar = [[[NSBundle mainBundle] loadNibNamed:@"SixisPlayerStatus" owner:self options:nil] objectAtIndex:0];
        [[self view] addSubview:statusBar];
        
        // Initialize a table-info object for this player.
        SixisPlayerTableInfo *tableInfo = [[SixisPlayerTableInfo alloc] init];
        tableInfo.player = player;
        tableInfo.game = game;
        tableInfo.statusBar = statusBar;

        [tableInfos addObject:tableInfo];
        
        // Initialize the player's name and score.
        UILabel *nameLabel = (UILabel *)[statusBar viewWithTag:NAME_LABEL_TAG];
        [nameLabel setText:[player name]];
        UILabel *scoreLabel = (UILabel *)[statusBar viewWithTag:SCORE_LABEL_TAG];
        [scoreLabel setText:@"0"];
        [tempDict setObject:tableInfo forKey:player.name];
        
        // Set the status bar's frame and rotation.
        [statusBar setFrame:[tableInfo statusFrame]];
        [statusBar setTransform:CGAffineTransformMakeRotation(tableInfo.rotation)];
    }
    tableInfoForPlayer = [NSDictionary dictionaryWithDictionary:tempDict];
}

/****************
 Notification handlers!!
 ****************/

-(void)handleNewTurn:(NSNotification *)note {
    // Set the current player, based on the argument attached to this notification.
    SixisPlayer *player = [[note userInfo] valueForKey:@"player"];
    currentPlayer = player;
    
    // If the current player is a human, plop the control view on the screen, placed and rotated in a position appropriate to that player.
    if ( [currentPlayer isKindOfClass:[SixisHuman class]]) {
        SixisPlayerTableInfo *info = (SixisPlayerTableInfo *)[tableInfoForPlayer objectForKey:[currentPlayer name]];
        CGRect frame = info.controlsFrame;
        [playerControls setFrame:frame];
        [playerControls setTransform:CGAffineTransformMakeRotation(info.rotation)];
        playerControls.hidden = NO;
    
        // Show the dice-rolling buttons; hide the other controls.
        rollAllDiceButton.hidden = NO;
        rollUnlockedDiceButton.hidden = NO;
        
        diceView.hidden = YES;
        endTurnButton.hidden = YES;
        
        // If it's a 2P game and the player can call the round over, show that button.
        if ( [game roundMightEnd] ) {
            endRoundButton.hidden = NO;
        }
        else {
            endRoundButton.hidden = YES;
        }
    }
    else {
        // The player is a robot, so hide all the player controls.
        playerControls.hidden = YES;
    }
    
}

-(void)handleDiceRoll:(NSNotification *)note {
    // Set the dice of the given player's die-views.
    // (This assumes that the views are all clear to begin with...)
    NSSet *theDice = [[note userInfo] valueForKey:@"dice"];
    NSMutableSet *dice = [NSMutableSet setWithSet:theDice];
    
    // Sweep out the dice from the player's bank, and add em to the dice to display.
    [dice unionSet:[currentPlayer lockedDice]];
    SixisPlayerTableInfo *info = (SixisPlayerTableInfo *)[tableInfoForPlayer objectForKey:[currentPlayer name]];
    UIView *bank = [info.statusBar viewWithTag:DICE_BANK_TAG];
    NSArray *bankDieViews = [bank subviews];
    for (SixisDieView *dieView in bankDieViews) {
        [dieView setDie:nil];
    }
    
    // Update the dice imageviews.
    NSArray *dieViews = [diceView subviews];
    for (SixisDieView *dieView in dieViews) {
        if ( dice.count == 0 ) {
            break;
        }
        SixisDie *die = [dice anyObject];
        [dice removeObject:die];
        [dieView setDie:die];
    }
    
    // Too late to end the round now...
    endRoundButton.hidden = YES;
    
}

-(void)handleCardPickup:(NSNotification *)note {
    // Tell the card view at the given index that it should be empty now.
    int index = [[[note userInfo] valueForKey:@"index"] intValue];
    SixisCardView *cardView = [cards objectAtIndex:index];
    [cardView setCard:nil];
    
    // Increment this player's score.
    SixisPlayerTableInfo *info = (SixisPlayerTableInfo *)[tableInfoForPlayer objectForKey:[currentPlayer name]];
    UILabel *scoreLabel = (UILabel *)[info.statusBar viewWithTag:SCORE_LABEL_TAG];
    scoreLabel.text = [NSString stringWithFormat:@"%d", [currentPlayer score]];

    
}

-(void)handleDiceLock:(NSNotification *)note {
    // Sweep away all the current player's dice.

    int playerNumber = [[[self game] players] indexOfObject:currentPlayer] + 1;
    UIView *dieHolder = [[self view] viewWithTag:playerNumber];
    NSArray *dieViews = [dieHolder subviews];
    
    for (SixisDieView *dieView in dieViews) {
       [dieView setDie:nil];
    }
   
    NSMutableSet *dice = [NSMutableSet setWithSet:[[note userInfo] objectForKey:@"dice"]];
    
    SixisPlayerTableInfo *info = (SixisPlayerTableInfo *)[tableInfoForPlayer objectForKey:[currentPlayer name]];
    UIView *bank = [info.statusBar viewWithTag:DICE_BANK_TAG];
    NSArray *bankDieViews = [bank subviews];
    for (SixisDieView *dieView in bankDieViews) {
        if ( dice.count == 0 ) {
            break;
        }
        SixisDie *die = [dice anyObject];
        [dice removeObject:die];
        [dieView setDie:die];
    }

    
}

-(void)handleWinning:(NSNotification *)note {
    [winMessage setText:@"GAME OVER"];
    [winMessage setHidden:NO];
}

-(void)handleDealtCard:(NSNotification *)note {
    // Tell the card view at the given index that it's holding a new card.
    int index = [[[note userInfo] valueForKey:@"index"] intValue];
    SixisCard *card = [[note userInfo] valueForKey:@"card"];
    SixisCardView *cardView = [cards objectAtIndex:index];
    [cardView setCard:card];
}



-(void)handleCardFlip:(NSNotification *)note {
    // Tell the card view at the given index that it's holding a new card.
    int index = [[[note userInfo] valueForKey:@"index"] intValue];
    SixisCard *card = [[note userInfo] valueForKey:@"card"];
    SixisCardView *cardView = [cards objectAtIndex:index];
    [cardView setCard:[card flipSide]];
}

- (IBAction)handleRollAllDiceTap:(id)sender {
    [currentPlayer rollAllDice];
    [self _prepareForDiceInteraction];
}

- (IBAction)handleRollUnlockedDiceTap:(id)sender {
    [currentPlayer rollUnlockedDice];
    [self _prepareForDiceInteraction];
}

- (void) _prepareForDiceInteraction {
    
    // Hide the player's dice-rolling buttons.
    rollAllDiceButton.hidden = YES;
    rollUnlockedDiceButton.hidden = YES;
    
    // Highlight all the qualified cards
    [self _highlightQualifiedCards];
    
    // Display the player-action hint.
    
    // Display the end-turn hint and controls.
    diceView.hidden = NO;
    endTurnButton.hidden = NO;
}

- (IBAction)handleDieTap:(id)sender {
    SixisDieView *dieView = (SixisDieView *)sender;
    SixisDie *die = [dieView die];
    if ( [die isLocked] ) {
        [die unlock];
        dieView.selected = NO;
        NSLog(@"Unlocking.");
        dieView.tintColor = [UIColor redColor];
    }
    else {
        [die lock];
        dieView.selected = YES;
        NSLog(@"Locking.");
    }
}

- (IBAction)handleEndTurnTap:(id)sender {
    [game startTurn];
    [self _unhighlightAllCards];
}

-(void)handleCardTap:(id)sender {
    SixisCardPopoverViewController *content = [[SixisCardPopoverViewController alloc] init];
    content.parent = self;
    content.card = [(SixisCardView *)sender card];
    popover = [[UIPopoverController alloc] initWithContentViewController:content];
    
    SixisCardView *cardView = (SixisCardView *)sender;
    
    // Display the popover as eminating from the tapped card.
    [popover presentPopoverFromRect:[cardView frame] inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

    
}

- (void)handleTakeCardTap:(SixisCard *)card {
    [popover dismissPopoverAnimated:YES];
    [currentPlayer takeCard:card];
    [self _unhighlightAllCards];
}

- (void)handleFlipCardTap:(SixisCard *)card {
    [popover dismissPopoverAnimated:YES];
    [currentPlayer flipCard:card];
    [self _unhighlightAllCards];
}


- (void) _highlightQualifiedCards {
//    NSSet *availableCards = [game availableCards];
    NSSet *availableCardIndices = [game.playersType cardIndicesForPlayerAtIndex:[currentPlayer number] - 1];
//    for (int i = 0; i < [game availableCards].count; i++) {
    for (NSNumber *cardIndex in availableCardIndices) {
        SixisCardView *cardView = [cards objectAtIndex:[cardIndex integerValue]];
        if ( [[cardView card] isQualified] ) {
            cardView.selected = YES;
            cardView.enabled = YES;
        }
    }
}

-(void) _unhighlightAllCards {
    for (int i = 0; i < [game cardsInPlay].count; i++) {
        SixisCardView *cardView = [cards objectAtIndex:i];
        cardView.selected = NO;
        cardView.enabled = NO;
    }
}
- (IBAction)handleEndRoundButtonTap:(id)sender {
}
@end
