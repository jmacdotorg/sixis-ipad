//
//  SixisGame.m
//  SixisTemp
//
//  Created by Jason McIntosh on 6/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisGame.h"
#import "SixisPlayer.h"
#import "SixisRobot.h"
#import "SixisDie.h"
#import "SixisCard.h"

// We need to import only the blue cards to the build the deck. And the Sixis card.
#import "SixisCardDoubleOnes.h"
#import "SixisCardDoubleTwos.h"
#import "SixisCardDoubleThrees.h"
#import "SixisCardDoubleFours.h"
#import "SixisCardDoubleFives.h"
#import "SixisCardDoubleSixes.h"
#import "SixisCardOneAndSix.h"
#import "SixisCardTwoAndFive.h"
#import "SixisCardThreeAndFour.h"
#import "SixisCardRun123.h"
#import "SixisCardRun456.h"
#import "SixisCardOneThreeFive.h"
#import "SixisCardTwoFourSix.h"
#import "SixisCardThreeOfAKind.h"
#import "SixisCardTwoPair.h"
#import "SixisCardLow.h"
#import "SixisCardHigh.h"

#import "SixisCardSixis.h"

#import "SixisPlayersType.h"
#import "SixisGameType.h"

@implementation SixisGame

@synthesize gameType, playersType, players, cardsInPlay, winningPlayers, hasTeams, currentRound, newRoundJustStarted, currentPlayer;

-(id)initWithGameType:(SixisGameType *)newGameType PlayersType:(SixisPlayersType *)newPlayersType Players:(NSMutableArray *)newPlayers {
    self = [super init];
    
    self.players = newPlayers;
    self.gameType = newGameType;
    self.playersType = newPlayersType;
    
    // Give each player object a (weak) backlink to this game object.)
    // Also, tell the players what player number they are (an int between 1 and 4).
    for ( SixisPlayer *player in players ) {
        [player setGame:self];
        int number = [players indexOfObject:player] + 1;
        [player setNumber:number];
    }
    
    // Register for various notifications.
    // For the most part, we'll just react to these events by logging them.
    // The controllers will also register as observers to the same events, and their reactions will of more interest to actual players.
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(handleNewTurn:) name:@"SixisNewTurn" object:nil];
    [nc addObserver:self selector:@selector(handleCardPickup:) name:@"SixisPlayerTookCard" object:nil];
    [nc addObserver:self selector:@selector(handleCardFlip:) name:@"SixisPlayerFlippedCard" object:nil];
    [nc addObserver:self selector:@selector(handleDiceLock:) name:@"SixisPlayerLockedDice" object:nil];
    [nc addObserver:self selector:@selector(handleDiceRoll:) name:@"SixisPlayerRolledDice" object:nil];
    [nc addObserver:self selector:@selector(handleWinning:) name:@"SixisPlayersWon" object:nil];
    [nc addObserver:self selector:@selector(handleDealtCard:) name:@"SixisCardDealt" object:nil];
    
    return self;
}

-(void)startGame {

    for (SixisPlayer *player in players) {
        // Unlock every player's dice.
        for (SixisDie *die in player.lockedDice) {
            [player.lockedDice removeObject:die];
            [player.unlockedDice addObject:die];
        }
        
        // Reset every player's score.
        player.score = 0;
    }
    
    self.currentRound = 0; // startRound will increment this to 1

    // Initialize the deck of blue cards.
    deck = [NSMutableArray arrayWithObjects:[[SixisCardDoubleOnes alloc] init], 
            [[SixisCardDoubleTwos alloc] init], 
            [[SixisCardDoubleThrees alloc] init],
            [[SixisCardDoubleFours alloc] init],
            [[SixisCardDoubleFives alloc] init],
            [[SixisCardDoubleSixes alloc] init],
            [[SixisCardOneAndSix alloc] init],
            [[SixisCardTwoAndFive alloc] init],
            [[SixisCardThreeAndFour alloc] init],
            [[SixisCardRun123 alloc] init],
            [[SixisCardRun456 alloc] init],
            [[SixisCardThreeOfAKind alloc] init],
            [[SixisCardTwoPair alloc] init],
            [[SixisCardOneThreeFive alloc] init],
            [[SixisCardTwoFourSix alloc] init],
            [[SixisCardLow alloc] init],
            [[SixisCardHigh alloc] init],
            nil];
    
    // XXX This is dumb I bet.
    for ( SixisCard *card in deck ) {
        [card setGame:self];
    }
    
    self.winningPlayers = nil;
    
    [self startRound];
}

-(void)startRound {
    // Increment round straight away, since that might be an endgame condition.
    self.currentRound++;
    
    // If someone just won the game, make that info public, and stop.
    [self.gameType checkForWinner];
    if ( self.winningPlayers ) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SixisPlayersWon" object:self userInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self.winningPlayers, nil] forKeys:[NSArray arrayWithObjects:@"players", nil]]];
        return;
    }
    
    // Set this so that the public new-round property flag goes up when the turn starts:
    shouldRaiseNewRoundFlag = YES;
    
    // Shuffle the blue-card deck.
    NSMutableArray *shuffledDeck = [[NSMutableArray alloc] init];
    while ( deck.count > 0 ) {
        int randomIndex = random() % deck.count;
        [shuffledDeck addObject:[deck objectAtIndex:randomIndex]];
        [deck removeObjectAtIndex:randomIndex];
    }
    deck = shuffledDeck;
    
    // Deal out the cards
    [self deal];
    
    // XXX This isn't the correct way to determine the first player.
    self.currentPlayer = [players objectAtIndex:0];
    
    [self startTurn];
}

-(void)startTurn {
    // If someone just won the game, make that info public, and stop.
    [self.gameType checkForWinner];
    if ( self.winningPlayers ) {
        return;
    }
    
    // Check for round-end.
    if ( [self.playersType roundHasEnded] ) {
        [self startRound];
        return;
    }

    // Set the new-round flags
    if ( shouldRaiseNewRoundFlag ) {
        self.newRoundJustStarted = YES;
        shouldRaiseNewRoundFlag = NO;
    }
    else {
        self.newRoundJustStarted = NO;
    }
    
    // Unless this is a brand-new round, post a notification about the previous player's 
    // locked dice.
    if ( ! newRoundJustStarted ) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SixisPlayerLockedDice"object:self userInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[currentPlayer lockedDice], currentPlayer, nil] forKeys:[NSArray arrayWithObjects:@"dice", @"player", nil]]];
    }
    
    // Advance the player-pointer.
    int indexOfCurrentPlayer = [players indexOfObject:self.currentPlayer];
    int indexOfNextPlayer;
    if ( indexOfCurrentPlayer == players.count - 1 ) {
        indexOfNextPlayer = 0;
    }
    else {
        indexOfNextPlayer = indexOfCurrentPlayer + 1;
    }
    self.currentPlayer = [players objectAtIndex:indexOfNextPlayer];
    
    
    // Post a notification that a new turn has started.
    // If the current player is a robot, this will spur them into action.
    NSLog(@"Hi.");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SixisNewTurn" object:self userInfo:[NSDictionary dictionaryWithObject:currentPlayer forKey:@"player"]];
}


-(void)setPlayersType:(SixisPlayersType *)newPlayersType {
    playersType = newPlayersType;
    self.playersType.game = self;
}

-(void)setGameType:(SixisGameType *)newGameType {
    gameType = newGameType;
    self.gameType.game = self;
}

-(void)deal {
    cardsInPlay = [[NSMutableArray alloc] init];
    [cardsInPlay addObject:[[SixisCardSixis alloc] init]];
    [[cardsInPlay objectAtIndex:0] setGame:self];
    for ( int i = 0; i < playersType.tableauSize; i++ ) {
        [cardsInPlay addObject:[deck objectAtIndex:0]];
        [deck removeObjectAtIndex:0];
    }
    
    // Post notifications about all these new cards (including the Sixis card)
    int index = 0;
    for (SixisCard *card in cardsInPlay) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SixisCardDealt" object:self userInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:card, [NSNumber numberWithInt:index++], nil] forKeys:[NSArray arrayWithObjects:@"card", @"index", nil]]];        
    }

}

-(NSArray *)remainingCardsInPlay {
    NSMutableArray *remainingCards = [[NSMutableArray alloc] init];
    for (NSObject *object in cardsInPlay) {
        if ( [object isKindOfClass:[SixisCard class]] ) {
            // Not totally sure I need to cast the object like this...
            SixisCard *card = (SixisCard *)object;
            [remainingCards addObject:card];
        }
    }
    return [NSArray arrayWithArray:remainingCards];
}

-(NSSet *)availableCards {
    NSSet *cardIndices = [playersType cardIndicesForPlayerAtIndex:[players indexOfObject:currentPlayer]];
    NSMutableSet *availableCards = [[NSMutableSet alloc] init];
    for (NSNumber *index in cardIndices) {
        SixisCard *card = [cardsInPlay objectAtIndex:[index intValue]];
        if ( ! [ card isEqual:[NSNull null] ] ) {
            [availableCards addObject:card];
            NSLog(@"I see %@ at index %d.", card, [index integerValue]);
        }
    }
    
    return [NSSet setWithSet:availableCards];
}

-(BOOL)roundMightEnd {
    return [playersType roundMightEnd];
}

-(void)handleNewTurn:(NSNotification *)note {
    NSLog(@"A new turn just started.");
}

-(void)handleDiceRoll:(NSNotification *)note {
    NSLog(@"Looks like some dice just got rolled:");
    NSMutableString *dieString = [[NSMutableString alloc] init];
    for ( SixisDie *die in currentPlayer.dice ) {
        [dieString appendString:[NSString stringWithFormat:@"%d ", die.value]];
    }
    NSLog(@"%@", dieString);
}

-(void)handleCardPickup:(NSNotification *)note {
    int index = [(NSNumber *)[[note userInfo] valueForKey:@"index"] intValue];
    NSLog(@"The current player just took the card %@ from position %d.", [[note userInfo] valueForKey:@"card"], index);
}

-(void)handleCardFlip:(NSNotification *)note {
    int index = [(NSNumber *)[[note userInfo] valueForKey:@"index"] intValue];
    NSLog(@"The current player just flipped the card %@ at position %d. Now the card at that position is %@.", [[note userInfo] valueForKey:@"card"], index, [cardsInPlay objectAtIndex:index]);
}

-(void)handleDiceLock:(NSNotification *)note {
    int count = [(NSSet *)[[note userInfo] valueForKey:@"dice"] count];
    NSLog(@"The current player has chosen to lock %d out of their 6 dice.", count);
}

-(void)handleWinning:(NSNotification *)note {
    NSSet *winners = (NSSet *)[[note userInfo] valueForKey:@"players"];
    NSLog(@"We have winners! Congratulations, %@.", winners);
}

-(void)handleDealtCard:(NSNotification *)note {
    NSLog(@"A card just got dealt.");
}

@end
