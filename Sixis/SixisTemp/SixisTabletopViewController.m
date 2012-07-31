//
//  SixisTabletopViewController.m
//  Sixis
//
//  Created by Jason McIntosh on 7/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisTabletopViewController.h"
#import "SixisGame.h"
#import "SixisCardView.h"
#import "SixisPlayer.h"
#import "SixisHuman.h"
#import "SixisDieView.h"
#import "SixisCard.h"

@interface SixisTabletopViewController ()

@end

@implementation SixisTabletopViewController
@synthesize player1Score;
@synthesize player2Score;
@synthesize winMessage;
@synthesize rollAllDiceButton;
@synthesize rollUnlockedDiceButton;
@synthesize endTurnButton;
@synthesize diceView;

@synthesize game, currentPlayer;

#define DICE_TAG_BASE 0
#define BANK_TAG_BASE 4
#define SCORE_TAG_BASE 8

#define FIRST_ROLL_TEXT @"Roll!"
#define ROLL_ALL_DICE_TEXT @"Roll all dice"
#define ROLL_UNLOCKED_DICE_TEXT @"Roll unlocked dice"
#define ROLL_NOTHING_TEXT @"Keep all dice locked"

#define TWO_PLAYER_CARD_Y 200

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
    [self setPlayer1Score:nil];
    [self setPlayer2Score:nil];
    [self setWinMessage:nil];
    [self setRollAllDiceButton:nil];
    [self setRollUnlockedDiceButton:nil];
    [self setEndTurnButton:nil];
    [self setDiceView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(void)_addCardViewWithX:(int)x Y:(int)y width:(int)width rotation:(int)rotation {
    // Figure out this view's height based on the given width, and the cards' fixed dimentions
    // The raw card graphics are 750 x 1050 pixels.
    CGFloat height = 1050.0 * ( width / 750.0 );
    CGRect frame = CGRectMake(x, y, width, height);

    SixisCardView *cardView = [[SixisCardView alloc] initWithFrame:frame];
    [cards addObject:cardView];
    
    [[self view] addSubview:cardView];
}

-(void)setGame:(SixisGame *)newGame {
    game = newGame;
    // Define all of this game's cardviews, then place them onto the tabletop view.
    if ( [game players].count == 2 ) {
        [self _addCardViewWithX:400 Y:TWO_PLAYER_CARD_Y width:100 rotation:0];

        [self _addCardViewWithX:0 Y:TWO_PLAYER_CARD_Y width:100 rotation:0];
        [self _addCardViewWithX:100 Y:TWO_PLAYER_CARD_Y width:100 rotation:0];
        [self _addCardViewWithX:200 Y:TWO_PLAYER_CARD_Y width:100 rotation:0];
        [self _addCardViewWithX:300 Y:TWO_PLAYER_CARD_Y width:100 rotation:0];

        [self _addCardViewWithX:500 Y:TWO_PLAYER_CARD_Y width:100 rotation:0];
        [self _addCardViewWithX:600 Y:TWO_PLAYER_CARD_Y width:100 rotation:0];
        [self _addCardViewWithX:700 Y:TWO_PLAYER_CARD_Y width:100 rotation:0];
        [self _addCardViewWithX:800 Y:TWO_PLAYER_CARD_Y width:100 rotation:0];
    }
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
        CGRect frame = CGRectMake(100, TWO_PLAYER_CARD_Y + 200, 256, 256);
        [playerControls setFrame:frame];
    }
    
    // Show the dice-rolling buttons; hide the other controls.
    rollAllDiceButton.hidden = NO;
    rollUnlockedDiceButton.hidden = NO;
    
    diceView.hidden = YES;
    
    endTurnButton.hidden = YES;
}

-(void)handleDiceRoll:(NSNotification *)note {
    // Set the dice of the given player's die-views.
    // (This assumes that the views are all clear to begin with...)
    NSSet *theDice = [[note userInfo] valueForKey:@"dice"];
    NSMutableSet *dice = [NSMutableSet setWithSet:theDice];
    
    // Sweep out the dice from the player's bank, and add em to the dice to display.
    [dice unionSet:[currentPlayer lockedDice]];
    int playerNumber = [[[self game] players] indexOfObject:currentPlayer] + 1;
    UIView *bank = [[self view] viewWithTag:playerNumber + BANK_TAG_BASE];
    NSArray *bankDieViews = [bank subviews];
    for (SixisDieView *dieView in bankDieViews) {
        [dieView setDie:nil];
    }
    
    // Update the dice imageviews.
    NSArray *dieViews = [diceView subviews];
    for (SixisDieView *dieView in dieViews) {
        // I am not thrilled by having to add this test, a consequence of my jamming invisible buttons over the uiimageview subclasses that make up the dice. But StackOverflow seems to think this is a more practical solution that setting up full touch-response on the imageviews.
        if ( [dieView isKindOfClass:[UIImageView class]] ) {
            if ( dice.count == 0 ) {
                break;
            }
            SixisDie *die = [dice anyObject];
            [dice removeObject:die];
            [dieView setDie:die];
        }
    }
    
}

-(void)handleCardPickup:(NSNotification *)note {
    // Tell the card view at the given index that it should be empty now.
    int index = [[[note userInfo] valueForKey:@"index"] intValue];
    SixisCardView *cardView = [cards objectAtIndex:index];
    [cardView setCard:nil];
    
    // Increment this player's score.
    int playerNumber = [[[self game] players] indexOfObject:currentPlayer] + 1;
    // XXX This is awful. I have to stick this shit into a hash.
    UILabel *scoreLabel;
    if ( playerNumber == 1 ) {
        scoreLabel = player1Score;
    }
    else {
        scoreLabel = player2Score;
    }
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
    
    UIView *bank = [[self view] viewWithTag:playerNumber + BANK_TAG_BASE];
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

- (IBAction)handleRollUnlockedDiceTap:(id)sender {
    [currentPlayer rollUnlockedDice];
}

- (IBAction)handleDieTap:(id)sender {
    // XXX Uhh... I have no association between this button and a particular die.
}

- (IBAction)handleEndTurnTap:(id)sender {
}

- (void) _highlightQualifiedCards {
    for (int i = 0; i < [game cardsInPlay].count; i++) {
        SixisCardView *cardView = [cards objectAtIndex:i];
        if ( [[cardView card] isQualified] ) {
            cardView.highlighted = YES;
        }
    }
}

-(void) _unhighlightAllCards {
    for (int i = 0; i < [game cardsInPlay].count; i++) {
        SixisCardView *cardView = [cards objectAtIndex:i];
        cardView.highlighted = NO;
    }
}
@end
