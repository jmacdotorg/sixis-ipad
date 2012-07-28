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
#import "SixisDieView.h"
#import "SixisCard.h"

@interface SixisTabletopViewController ()

@end

@implementation SixisTabletopViewController
@synthesize player1Score;
@synthesize player2Score;
@synthesize winMessage;

@synthesize game, currentPlayer;

#define DICE_TAG_BASE 0
#define BANK_TAG_BASE 4
#define SCORE_TAG_BASE 8

#define FIRST_ROLL_TEXT @"Roll!"
#define ROLL_ALL_DICE_TEXT @"Roll all dice"
#define ROLL_UNLOCKED_DICE_TEXT @"Roll unlocked dice"
#define ROLL_NOTHING_TEXT @"Keep all dice locked"

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
}

- (void)viewDidUnload
{
    [self setPlayer1Score:nil];
    [self setPlayer2Score:nil];
    [self setWinMessage:nil];
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
        [self _addCardViewWithX:400 Y:0 width:100 rotation:0];

        [self _addCardViewWithX:0 Y:0 width:100 rotation:0];
        [self _addCardViewWithX:100 Y:0 width:100 rotation:0];
        [self _addCardViewWithX:200 Y:0 width:100 rotation:0];
        [self _addCardViewWithX:300 Y:0 width:100 rotation:0];

        [self _addCardViewWithX:500 Y:0 width:100 rotation:0];
        [self _addCardViewWithX:600 Y:0 width:100 rotation:0];
        [self _addCardViewWithX:700 Y:0 width:100 rotation:0];
        [self _addCardViewWithX:800 Y:0 width:100 rotation:0];
    }
}

/****************
 Notification handlers!!
 ****************/

-(void)handleNewTurn:(NSNotification *)note {
    // Set the current player, based on the argument attached to this notification.
    SixisPlayer *player = [[note userInfo] valueForKey:@"player"];
    currentPlayer = player;
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
    UIView *dieHolder = [[self view] viewWithTag:playerNumber];
    NSArray *dieViews = [dieHolder subviews];
    for (SixisDieView *dieView in dieViews) {
        if ( dice.count == 0 ) {
            break;
        }
        SixisDie *die = [dice anyObject];
        [dice removeObject:die];
        [dieView setDie:die];
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
}

- (IBAction)handleRollUnlockedDiceTap:(id)sender {
    [currentPlayer rollUnlockedDice];
}
@end
