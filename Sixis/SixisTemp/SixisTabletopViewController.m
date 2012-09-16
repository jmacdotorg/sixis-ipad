//
//  SixisTabletopViewController.m
//  Sixis
//
//  Created by Jason McIntosh on 7/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisTabletopViewController.h"
#import "SixisCardPopoverViewController.h"
#import "SixisSettingsPopoverViewController.h"
#import "SixisGame.h"
#import "SixisCardView.h"
#import "SixisPlayer.h"
#import "SixisRobot.h"
#import "SixisHuman.h"
#import "SixisDieView.h"
#import "SixisCard.h"
#import "SixisDie.h"
#import "SixisPlayerTableInfo.h"
#import "SixisPlayersType.h"
#import "SixisMainMenuViewController.h"
#import "SixisGameType.h"
#import "SixisRoundsGame.h"
#import "SixisPointsGame.h"

#import <AVFoundation/AVFoundation.h>

@interface SixisTabletopViewController ()

@end

@implementation SixisTabletopViewController
@synthesize roundEndExplanationLabel;
@synthesize roundEndControls;
@synthesize gameEndExplanationLabel;
@synthesize settingsButton;
@synthesize endRoundButton;
@synthesize textPromptLabel;
@synthesize undoCardButton;
@synthesize winMessage;
@synthesize gameOverView;
@synthesize rollAllDiceButton;
@synthesize rollUnlockedDiceButton;
@synthesize endTurnButton;
@synthesize diceView;
@synthesize mainMenuController;

@synthesize game, currentPlayer, aCardAnimationIsOccurring;

#define NAME_LABEL_TAG 10
#define SCORE_LABEL_TAG 20
#define DICE_BANK_TAG 30

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        aCardAnimationIsOccurring = NO;
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
    [nc addObserver:self selector:@selector(handleCardUnpickup:) name:@"SixisPlayerUntookCard" object:nil];
    [nc addObserver:self selector:@selector(handleCardUnflip:) name:@"SixisPlayerUnflippedCard" object:nil];
    [nc addObserver:self selector:@selector(handleDiceLock:) name:@"SixisPlayerLockedDice" object:nil];
    [nc addObserver:self selector:@selector(handleDiceRoll:) name:@"SixisPlayerRolledDice" object:nil];
    [nc addObserver:self selector:@selector(handleWinning:) name:@"SixisPlayersWon" object:nil];
    [nc addObserver:self selector:@selector(handleDealtCard:) name:@"SixisCardDealt" object:nil];
    [nc addObserver:self selector:@selector(handleRoundEnd:) name:@"SixisRoundEnded" object:nil];
    
    // Load the player-controls view from its XIB.
    playerControls = [[[NSBundle mainBundle] loadNibNamed:@"SixisPlayerControls" owner:self options:nil] objectAtIndex:0];
    [[self view] addSubview:playerControls];
    // And the view that holds the rolled dice.
    diceView = [[[NSBundle mainBundle] loadNibNamed:@"SixisRolledDice" owner:self options:nil] objectAtIndex:0];
    [[self view] addSubview:diceView];

    // And the view that holds the text prompt.
    textPromptLabel = [[[NSBundle mainBundle] loadNibNamed:@"SixisTextPrompt" owner:self options:nil] objectAtIndex:0];
    [[self view] addSubview:diceView];
    [[self view] addSubview:textPromptLabel];
    [textPromptLabel setText:@"Hi mom!"];
    
    // And the view that holds the round-might-end reason.
    roundMightEndReasonLabel = [[[NSBundle mainBundle] loadNibNamed:@"RoundEndReason" owner:self options:nil] objectAtIndex:0];
    roundMightEndReasonLabel.hidden = YES;
    [[self view] addSubview:roundMightEndReasonLabel];
    
    // Get out of here, game-over view, nobody likes your style
    gameOverView.hidden = YES;
    
}

- (void)viewDidUnload
{
    [self setWinMessage:nil];
    [self setRollAllDiceButton:nil];
    [self setRollUnlockedDiceButton:nil];
    [self setEndTurnButton:nil];
    [self setDiceView:nil];
    [self setEndRoundButton:nil];
    [self setTextPromptLabel:nil];
    [self setGameOverView:nil];
    [self setUndoCardButton:nil];
    [self setRoundEndExplanationLabel:nil];
    [self setRoundEndControls:nil];
    [self setGameEndExplanationLabel:nil];
    [self setSettingsButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        return YES;
    }
    else {
        return NO;
    }
}

-(void)_addCardViewWithX:(int)x Y:(int)y rotation:(CGFloat)rotation {
    CGRect frame = CGRectMake(x, y, 118.75, 170.05);

    SixisCardView *cardView = [[SixisCardView alloc] initWithFrame:frame];
    [cards addObject:cardView];
    
    if ( rotation > 0 ) {
        CGAffineTransform xform = CGAffineTransformMakeRotation( rotation );
        cardView.rotation = rotation;
        cardView.transform = xform;
    }
    
    [cardView addTarget:self action:@selector(handleCardTap:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:cardView];
}

-(void)setGame:(SixisGame *)newGame {
    game = newGame;
    
    // Clean up any cardViews lying around from a previous game.
    // Then init the cards array.
    if ( cards != nil ) {
        for ( SixisCardView *cardView in cards ) {
            [cardView removeFromSuperview];
        }
    }
    cards = [[NSMutableArray alloc] init];
    
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
    
    // Clean up any status bars lying around from a previous game.
    // Then init the status bar array.
    if ( statusBars != nil ) {
        for ( UIView *statusBar in statusBars ) {
            [statusBar removeFromSuperview];
        }
    }
    statusBars = [[NSMutableArray alloc] init];
    
    // Generate all the players' status bars, and store them in an instance variable.
    NSMutableArray *tableInfos = [[NSMutableArray alloc] init];
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    for (SixisPlayer *player in [game players] ) {
        UIView *statusBar = [[[NSBundle mainBundle] loadNibNamed:@"SixisPlayerStatus" owner:self options:nil] objectAtIndex:0];
        [[self view] addSubview:statusBar];
        [statusBars addObject:statusBar];
        
        // Initialize a table-info object for this player.
        SixisPlayerTableInfo *tableInfo = [[SixisPlayerTableInfo alloc] init];
        tableInfo.playerNumber = player.number;
        tableInfo.playerCount = game.players.count;
        tableInfo.statusBar = statusBar;

        [tableInfos addObject:tableInfo];
        
        // Initialize the player's name and score.
        UILabel *nameLabel = (UILabel *)[statusBar viewWithTag:NAME_LABEL_TAG];
        [nameLabel setText:[player name]];
        UILabel *scoreLabel = (UILabel *)[statusBar viewWithTag:SCORE_LABEL_TAG];
        [scoreLabel setText:[NSString stringWithFormat:@"%d", player.score]];
        [tempDict setObject:tableInfo forKey:player.name];
        
        // Set the status bar's frame and rotation.
        [statusBar setFrame:[tableInfo statusFrame]];
        [statusBar setTransform:CGAffineTransformMakeRotation(tableInfo.rotation)];
    }
    tableInfoForPlayer = [NSDictionary dictionaryWithDictionary:tempDict];
    
    // Remember the original gameType, since it might change if people want to add rounds later.
    originalGameType = [game.gameType copy];
    
    // If the game has cards in play, then it's in progress!! Set up an existing game based on the game object.
    if (game.remainingCardsInPlay.count > 0) {
        int cardIndex = 0;
        for (SixisCard *card in game.cardsInPlay) {
            if ( ![[game.cardsInPlay objectAtIndex:cardIndex] isEqual:[NSNull null]] ) {
                [[cards objectAtIndex:cardIndex] setCard:[game.cardsInPlay objectAtIndex:cardIndex]];
            }
            cardIndex++;
        }
        
        // Draw everyone's locked dice.
        for (SixisPlayer *player in [game players] ) {
            [self lockDice:[player lockedDice] forPlayerNumber:[player number]];
        }
        
        // Start the current player's turn in motion.
        [self startNewTurnWithPlayer:game.currentPlayer];
        
        // If the current player's a robot, give it a nudge.
        if ( [currentPlayer isKindOfClass:[SixisRobot class]]) {
            SixisRobot *robot = (SixisRobot *)currentPlayer;
            [robot takeTurn];
        }
        
        /* These don't work too good right now
        if (currentPlayer.hasRolledDice) {
            [self rollDice:currentPlayer.dice];
        }
        if (currentPlayer.cardJustFlipped) {
            [self flipCard:currentPlayer.cardJustFlipped atIndex:currentPlayer.indexOfLastCardAction];
        }
        if (currentPlayer.cardJustTaken) {
            [self takeCardatIndex:currentPlayer.indexOfLastCardAction];
        }
         */
    }
    
}

/****************
 Notification handlers!!
 ****************/

-(void)handleNewTurn:(NSNotification *)note {
    
    // Set the current player, based on the argument attached to this notification.
    SixisPlayer *player = [[note userInfo] valueForKey:@"player"];
    [self startNewTurnWithPlayer:player];
}

-(void)startNewTurnWithPlayer:(SixisPlayer *)player {
    currentPlayer = player;
    
    // Update the thisIsTheFirstRound boolean.
    if ( firstPlayer == nil ) {
        firstPlayer = currentPlayer;
        thisIsTheFirstGoRound = YES;
    }
    else if ( [firstPlayer isEqual:currentPlayer] ) {
        thisIsTheFirstGoRound = NO;
    }

    // Get the current player's tableInfo object.
    SixisPlayerTableInfo *info = (SixisPlayerTableInfo *)[tableInfoForPlayer objectForKey:[currentPlayer name]];
    
    // Reposition the UIView that holds the rolled dice.
    diceView.hidden = YES;
    CGPoint diceCenter = info.diceCenter;
    [diceView setCenter:diceCenter];
    [diceView setTransform:CGAffineTransformMakeRotation(info.rotation)];

    // If the current player is a human, plop the control view on the screen, placed and rotated in a position appropriate to that player.
    if ( [currentPlayer isKindOfClass:[SixisHuman class]]) {

        CGPoint controlsCenter = info.controlsCenter;
        [playerControls setCenter:controlsCenter];
        [playerControls setTransform:CGAffineTransformMakeRotation(info.rotation)];
        playerControls.hidden = NO;
        
        // Reposition and show the UILabel that displays the text prompt.
        CGPoint textCenter = info.textCenter;
        [textPromptLabel setCenter:textCenter];
        [textPromptLabel setTransform:CGAffineTransformMakeRotation(info.rotation)];
        textPromptLabel.hidden = NO;
        
        // Define the text and status of the dice-rolling buttons, depending on die-count.
        if ( currentPlayer.lockedDice.count == 0 ) {
            rollAllDiceButton.hidden = YES;
            rollUnlockedDiceButton.hidden = NO;
            [self _setTitleOfButton:rollUnlockedDiceButton toString:@"Roll All"];
        }
        else if ( currentPlayer.lockedDice.count == 6 ) {
            rollAllDiceButton.hidden = NO;
            rollUnlockedDiceButton.hidden = NO;
            rollUnlockedDiceButton.titleLabel.textAlignment = UITextAlignmentCenter;
            [self _setTitleOfButton:rollUnlockedDiceButton toString:@"Roll None"];
        }
        else {
            rollAllDiceButton.hidden = NO;
            rollUnlockedDiceButton.hidden = NO;
            [self _setTitleOfButton:rollUnlockedDiceButton toString:@"Roll Unlocked"];
        }
        
        endTurnButton.hidden = YES;
        undoCardButton.hidden = YES;
        
        // If it's a 2P game and the player can call the round over, show that button.
        if ( [game roundMightEnd] ) {
            endRoundButton.hidden = NO;
            
            // Also display the label explaining why.
            roundMightEndReasonLabel.hidden = NO;
            roundMightEndReasonLabel.center = [info roundMightEndReasonCenter];
            roundMightEndReasonLabel.transform = CGAffineTransformMakeRotation([info rotation]);
            roundMightEndReasonLabel.text = [NSString stringWithFormat:@"%@\n\nIn a two-player game, that means either player can end the round before their roll.", [game.playersType roundMightEndReason]];
        }
        else {
            endRoundButton.hidden = YES;
            roundMightEndReasonLabel.hidden = YES;
        }
        
        // Update the text prompt.
        NSMutableString *newText = [[NSMutableString alloc] init];
        
        if ( [game roundMightEnd] ) {
            [newText appendString:@"Tap the End Round button to declare this round over.\n\n"];
        }
        
        if ( currentPlayer.lockedDice.count == 6 ) {
            [newText appendString:@"All of your dice are locked! Roll nothing, OR re-roll all six."];
        }
        else if ( thisIsTheFirstGoRound ) {
            [newText appendString:@"This is your first turn this round, so roll all your dice! Tap the Roll All button."];
        }
        else if ( currentPlayer.lockedDice.count == 0 ) {
            [newText appendString:@"None of your dice are locked, so roll all your dice!"];
        }
        else {
            [newText appendString:@"Roll your unlocked dice, OR re-roll all six of your dice."];
        }
        
        [textPromptLabel setText:newText];
    }
    else {
        // The player is a robot, so hide all the player controls and stuff.
        playerControls.hidden = YES;
        textPromptLabel.hidden = YES;
    }
    
    // Lower the opacity of all cards not available to this player.
    NSSet *availableCards = [game availableCards];
    for (SixisCardView *cardView in cards) {
        if ( [availableCards containsObject:cardView.card] ) {
            cardView.alpha = 1;
        }
        else {
            cardView.alpha = .6;
        }
    }
    
}

-(void)handleDiceRoll:(NSNotification *)note {
    // Set the dice of the given player's die-views.
    // (This assumes that the views are all clear to begin with...)
    NSSet *theDice = [[note userInfo] valueForKey:@"dice"];
    [self rollDice:theDice];
}

-(void)rollDice:(NSSet *)theDice {
    NSMutableSet *dice = [NSMutableSet setWithSet:theDice];
    // Sweep out the dice from the player's bank, and add em to the dice to display.
    [dice unionSet:[currentPlayer lockedDice]];
    SixisPlayerTableInfo *info = (SixisPlayerTableInfo *)[tableInfoForPlayer objectForKey:[currentPlayer name]];
    UIView *bank = [info.statusBar viewWithTag:DICE_BANK_TAG];
    NSArray *bankDieViews = [bank subviews];
    for (SixisDieView *dieView in bankDieViews) {
        [dieView setDie:nil];
    }
    
    // Play a dice-rolling sound.
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"two_dice_on_wood" withExtension:@"aiff"];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    [audioPlayer play];
    
    // Update the dice imageviews.
    if ( diceView.hidden ) {
        diceView.hidden = NO;
    }
    
    NSArray *dieViews = [diceView subviews];
    for (SixisDieView *dieView in dieViews) {
        if ( dice.count == 0 ) {
            break;
        }
        SixisDie *die = [dice anyObject];
//        if ( ! die.isLocked ) {
            [dice removeObject:die];
            [dieView setDie:die];
//        }
    }
    [self _selectOnlyLockedDice];
    
    // Too late to end the round now...
    endRoundButton.hidden = YES;

    
}

-(void)handleCardPickup:(NSNotification *)note {
    // Tell the card view at the given index that it should be empty now.
    int index = [[[note userInfo] valueForKey:@"index"] intValue];
    [self takeCardatIndex:index];
}

-(void)takeCardatIndex:(int)index {
    SixisCardView *cardView = [cards objectAtIndex:index];
    [cardView setCard:nil];
    
    // Increment this player's score.
    SixisPlayerTableInfo *info = (SixisPlayerTableInfo *)[tableInfoForPlayer objectForKey:[currentPlayer name]];
    UILabel *scoreLabel = (UILabel *)[info.statusBar viewWithTag:SCORE_LABEL_TAG];
    scoreLabel.text = [NSString stringWithFormat:@"%d", [currentPlayer score]];
    
    // If they have a teammate, increment the teammate's score as well.
    SixisPlayer *teammate = [currentPlayer teammate];
    if ( teammate != nil ) {
        SixisPlayerTableInfo *teammateInfo = (SixisPlayerTableInfo *)[tableInfoForPlayer objectForKey:[teammate name]];
        UILabel *scoreLabel = (UILabel *)[teammateInfo.statusBar viewWithTag:SCORE_LABEL_TAG];
        scoreLabel.text = [NSString stringWithFormat:@"%d", [teammate score]];
    }

    // Unhide the undo button.
    undoCardButton.hidden = NO;
    
    // Make a flippy noise.
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"cardflip" withExtension:@"aiff"];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    [audioPlayer play];
    
}

-(void)handleCardUnpickup:(NSNotification *)note {
    // Replace the card at the given index.
    int index = [[[note userInfo] valueForKey:@"index"] intValue];
    SixisCard *card = [[note userInfo] valueForKey:@"card"];
    SixisCardView *cardView = [cards objectAtIndex:index];
    [cardView setCard:card];
    
    // Decrement this player's score.
    SixisPlayerTableInfo *info = (SixisPlayerTableInfo *)[tableInfoForPlayer objectForKey:[currentPlayer name]];
    UILabel *scoreLabel = (UILabel *)[info.statusBar viewWithTag:SCORE_LABEL_TAG];
    scoreLabel.text = [NSString stringWithFormat:@"%d", [currentPlayer score]];
    
    // If they have a teammate, decrement the teammate's score as well.
    SixisPlayer *teammate = [currentPlayer teammate];
    if ( teammate != nil ) {
        SixisPlayerTableInfo *teammateInfo = (SixisPlayerTableInfo *)[tableInfoForPlayer objectForKey:[teammate name]];
        UILabel *scoreLabel = (UILabel *)[teammateInfo.statusBar viewWithTag:SCORE_LABEL_TAG];
        scoreLabel.text = [NSString stringWithFormat:@"%d", [teammate score]];
    }
    
    // Re-hide the undo button.
    undoCardButton.hidden = YES;
    [self _prepareForDiceInteraction];
    
}

-(void)handleDiceLock:(NSNotification *)note {
    // Sweep away all the current player's dice.

    int playerNumber = [[[self game] players] indexOfObject:currentPlayer] + 1;
    NSSet *theDice = [[note userInfo] objectForKey:@"dice"];
    
    [self lockDice:theDice forPlayerNumber:playerNumber];
}

-(void)lockDice:(NSSet *)theDice forPlayerNumber:(int)playerNumber {
    UIView *dieHolder = [[self view] viewWithTag:playerNumber];
    NSArray *dieViews = [dieHolder subviews];
    
    for (SixisDieView *dieView in dieViews) {
       [dieView setDie:nil];
    }
   
    NSMutableSet *dice = [NSMutableSet setWithSet:theDice];
    
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
    NSMutableString *winners = [[NSMutableString alloc] init];
    for (SixisPlayer *winner in game.winningPlayers) {
        if ( winners.length ) {
            [winners appendString:@" & "];
        }
        [winners appendString:winner.name];
    }
    if (game.winningPlayers.count > 1) {
        [winners appendString:@" win!"];
    }
    else {
        [winners appendString:@" wins!"];
    }
    winMessage.text = winners;
    
    gameEndExplanationLabel.text = [game.gameType gameEndReason];
    [gameOverView setHidden:NO];
    [self.view bringSubviewToFront:gameOverView];
}

-(void)handleDealtCard:(NSNotification *)note {
    
    // Tell the card view at the given index that it's holding a new card.
    int index = [[[note userInfo] valueForKey:@"index"] intValue];
    SixisCard *card = [[note userInfo] valueForKey:@"card"];
    [self dealCard:card toIndex:index];

}
 
-(void)dealCard:(SixisCard *)card toIndex:(int)index {
    
    SixisCardView *cardView = [cards objectAtIndex:index];
    [cardView setCard:card];
    
    // Make a card-shuffle noise (if none such is playing).
    if ( ! audioPlayer.playing ) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"shuffle" withExtension:@"aiff"];
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
        [audioPlayer play];
    }
    
    // Make sure that all players' banks are empty.
    // XXX This is inefficient; should really just fire on the first dealt card. Eh.
    for (SixisPlayer *player in game.players) {
        SixisPlayerTableInfo *info = (SixisPlayerTableInfo *)[tableInfoForPlayer objectForKey:[player name]];
        UIView *bank = [info.statusBar viewWithTag:DICE_BANK_TAG];
        NSArray *bankDieViews = [bank subviews];
        for (SixisDieView *dieView in bankDieViews) {
            [dieView setDie:nil];
        }
    }
}



-(void)handleCardFlip:(NSNotification *)note {
    // Tell the card view at the given index that it's holding a new card.
    int index = [[[note userInfo] valueForKey:@"index"] intValue];
    SixisCard *card = [[note userInfo] valueForKey:@"card"];
    [self flipCard:card atIndex:index];
}

-(void)flipCard:(SixisCard *)card atIndex:(int)index {
    SixisCardView *cardView = [cards objectAtIndex:index];
    [cardView setCard:[card flipSide]];
    
    // Unhide the undo button.
    undoCardButton.hidden = NO;
    
    // Make a flippy noise.
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"cardflip" withExtension:@"aiff"];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    [audioPlayer play];
}

-(void)handleCardUnflip:(NSNotification *) note {
    // Tell the card view at the given index that it's holding a new card.
    int index = [[[note userInfo] valueForKey:@"index"] intValue];
    SixisCard *card = [[note userInfo] valueForKey:@"card"];
    SixisCardView *cardView = [cards objectAtIndex:index];
    [cardView setCard:card];
    
    // Re-hide the undo button.
    undoCardButton.hidden = YES;
    [self _prepareForDiceInteraction];
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
    NSMutableString *newText = [[NSMutableString alloc] init];
    
    if (thereAreHighlightedCards) {
        [newText appendString:@"You may take OR flip one card that matches your dice.\n\n"];
    }
    else {
        [newText appendString:@"No cards match your dice this time.\n\n"];
    }
    
    [newText appendString:@"Tap dice to choose which ones to lock."];
    
    [textPromptLabel setText:newText];
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
    SixisPlayerTableInfo *info = (SixisPlayerTableInfo *)[tableInfoForPlayer objectForKey:[currentPlayer name]];
    content.rotation = info.rotation;
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
    [self _removeCardInstruction];
}

- (void)handleFlipCardTap:(SixisCard *)card {
    [popover dismissPopoverAnimated:YES];
    [currentPlayer flipCard:card];
    [self _unhighlightAllCards];
    [self _removeCardInstruction];
}

-(void) _removeCardInstruction {
    if ( [currentPlayer isKindOfClass:[SixisHuman class]]) {
        textPromptLabel.text = @"Tap dice to choose which ones to lock.";
    }
}

- (void) _highlightQualifiedCards {
    NSSet *availableCardIndices = [game.playersType cardIndicesForPlayerAtIndex:[currentPlayer number] - 1];
    thereAreHighlightedCards = NO;
    for (NSNumber *cardIndex in availableCardIndices) {
        SixisCardView *cardView = [cards objectAtIndex:[cardIndex integerValue]];
        if ( [[cardView card] isQualified] ) {
            cardView.selected = YES;
            cardView.enabled = YES;
            thereAreHighlightedCards = YES;
        }
    }
}

-(void) _unhighlightAllCards {
    for (int i = 0; i < [game cardsInPlay].count; i++) {
        SixisCardView *cardView = [cards objectAtIndex:i];
        cardView.selected = NO;
        cardView.enabled = NO;
    }
    thereAreHighlightedCards = NO;
}

// _selectLockedDice: select all dice that the current player has locked.
-(void) _selectOnlyLockedDice {
    NSArray *dieViews = [diceView subviews];
    for (SixisDieView *dieView in dieViews) {
        if ( dieView.die.isLocked ) {
            dieView.selected = YES;
        }
        else {
            dieView.selected = NO;
        }
    }
}

- (IBAction)handleEndRoundButtonTap:(id)sender {
    [game endRound];
}

- (IBAction)handlePlayAgain:(id)sender {

    // Reset player score displays.
    for (SixisPlayer *player in [game players] ) {
        SixisPlayerTableInfo *info = (SixisPlayerTableInfo *)[tableInfoForPlayer objectForKey:[player name]];
        UILabel *scoreLabel = (UILabel *)[info.statusBar viewWithTag:SCORE_LABEL_TAG];
        scoreLabel.text = @"0";
    }

    gameOverView.hidden = YES;
    
    // Replace the game's possibly-mutated gameType with a pristine copy.
    game.gameType = [originalGameType copy];
    
    [game startGame];
}

- (IBAction)handleMainMenu:(id)sender {
    gameOverView.hidden = YES;
    
    if (popover) {
        [popover dismissPopoverAnimated:YES];
    }
    [game unsave];
    self.game = nil;
    
    SixisMainMenuViewController *mainMenu = self.mainMenuController;
    self.view.window.rootViewController = mainMenu;

}

-(void)_setTitleOfButton:(UIButton *)button toString:(NSString *)label {
    [button setTitle: label forState: UIControlStateNormal];
    [button setTitle: label forState: UIControlStateApplication];
    [button setTitle: label forState: UIControlStateHighlighted];
    [button setTitle: label forState: UIControlStateReserved];
    [button setTitle: label forState: UIControlStateSelected];
    [button setTitle: label forState: UIControlStateDisabled];
}

- (IBAction)handleAddRound:(id)sender {
    game.currentRound++;
    if ( [game.gameType isKindOfClass:[SixisRoundsGame class]] ) {
        SixisRoundsGame *gameType = (SixisRoundsGame *)game.gameType;
        game.currentRound--;
        gameType.rounds++;
        gameOverView.hidden = YES;
        game.winningPlayers = nil;
        [game startRound];
    }
    else {
        SixisRoundsGame *gameType = [[SixisRoundsGame alloc] initWithRounds:2];
        game.currentRound = 2;
        game.gameType = gameType;
        gameOverView.hidden = YES;
        game.winningPlayers = nil;
        [game startRound];
    }
}

- (IBAction)handleUndoCard:(id)sender {
    [currentPlayer undoLastAction];
}

- (IBAction)handleNextRound:(id)sender {
    roundEndControls.hidden = YES;
    [game startRound];
}

- (IBAction)handleSettingsButton:(id)sender {
    SixisSettingsPopoverViewController *content = [[SixisSettingsPopoverViewController alloc] init];
    popover = [[UIPopoverController alloc] initWithContentViewController:content];
    
    // Display the popover as eminating from the tapped card.
    [popover presentPopoverFromRect:[settingsButton frame] inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)handleRoundEnd:(NSNotification *)note {
    
    // Update the explanation text.
    roundEndExplanationLabel.text = [game roundEndExplanation];
    
    // Display the round-end dialog.
    roundEndControls.hidden = NO;
    [self.view bringSubviewToFront:roundEndControls];    
}

@end
