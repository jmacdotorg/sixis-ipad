//
//  SixisGame.m
//  SixisTemp
//
//  Created by Jason McIntosh on 6/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisGame.h"
#import "SixisPlayer.h"
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
    for ( SixisPlayer *player in newPlayers ) {
        player.game = self;
    }
    
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
            [[SixisCardTwoPair alloc] init],
            [[SixisCardThreeOfAKind alloc] init],
            [[SixisCardTwoPair alloc] init],
            [[SixisCardOneThreeFive alloc] init],
            [[SixisCardTwoFourSix alloc] init],
            [[SixisCardLow alloc] init],
            [[SixisCardHigh alloc] init],
            nil];
    
    self.winningPlayers = nil;
    
    [self startRound];
}

-(void)startRound {
    // Increment round straight away, since that might be an endgame condition.
    self.currentRound++;
    
    // If someone just won the game, make that info public, and stop.
    [self.gameType checkForWinner];
    if ( self.winningPlayers ) {
        return;
    }
    
    // Set this so that the public new-round property flag goes up when the turn starts:
    shouldRaiseNewRoundFlag = YES;
    
    // Shuffle the blue-card deck.
    NSMutableArray *shuffledDeck = [[NSMutableArray alloc] init];
    for ( int i = 0; i < deck.count; i++ ) {
        int randomIndex = random() % deck.count - 1;
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
    
    // Set the new-round flags
    if ( shouldRaiseNewRoundFlag ) {
        self.newRoundJustStarted = YES;
        shouldRaiseNewRoundFlag = NO;
    }
    else {
        self.newRoundJustStarted = NO;
    }
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
    for ( int i = 0; i < playersType.tableauSize; i++ ) {
        [cardsInPlay addObject:[deck objectAtIndex:0]];
        [deck removeObjectAtIndex:0];
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

@end
