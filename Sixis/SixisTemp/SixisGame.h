//
//  SixisGame.h
//  SixisTemp
//
//  Created by Jason McIntosh on 6/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

/**
An instance of this class is an abstract representation of a Sixis game.
 */

#import <Foundation/Foundation.h>
@class SixisGameType;
@class SixisPlayersType;
@class SixisPlayer;

@interface SixisGame : NSObject <NSCoding> {
    NSMutableArray *deck;
    SixisPlayer *firstPlayer;
}

/// @name Properties

/** This game's gameType object, an instance of either SixisPointsGame or SixisRoundsGame.
 
 This object provides methods whose outcome is dependent on the type of Sixis game being played, e.g. checkForWinner.
 */
@property (nonatomic, strong) SixisGameType *gameType;

/** This game's playersType object, a different SixisPlayersType subclass depending upon the number of players.
 
 This object provides methods whose outcome is dependent on the type of Sixis game being played, e.g. roundHasEnded.
 */
@property (nonatomic, strong) SixisPlayersType *playersType;

/** An array of this game's SixisPlayer instances.
 
 They will actually each be of a SixisPlayer subclass -- SixisHuman or SixisRobot.
 */
@property (nonatomic, strong) NSArray *players;

/// YES if this is a four-player team game. NO otherwise.
@property (nonatomic) BOOL hasTeams;
@property (nonatomic) BOOL shouldRaiseNewRoundFlag;

/** YES if the current turn is happening in the first go-round of the current round.
 
 Useful when restoring a saved game, when it's not technically possible to deduce this information based on the current game state.
 */
@property (nonatomic) BOOL thisIsTheFirstGoRound;

/// If the game is over, this array contains the winning players. (It will contain more than one player on a team victory, or a tie.)
@property (nonatomic, strong) NSArray *winningPlayers;

/// The SixisPlayer object whose turn it is.
@property (nonatomic, strong) SixisPlayer *currentPlayer;

/** An array containing all the _spaces_ of the cards currently in play. Each member is either a SixisCard subclass, or an NSNull object (and therefore false in boolean context).
 
 When a player scores a card, its position in this array is replaced with an NSNull instance.
 
 The card at index 0 of this array is _always_ the Sixis card. Each "arm" of cards on the table (two, three, or four of them, depending on the number of players) is then represented by a contiguous groups of members in this array (three or four of them, depending upon number of players). For example, in a two-player game, the members at indexes 1 through 4 are the cards to one side of the Sixis card, and 5 through 8 are the cards on the other side.
 
 */
@property (nonatomic, strong) NSMutableArray *cardsInPlay;

/// YES if the current turn is also the first turn of this round. NO otherwise.
@property (nonatomic) BOOL newRoundJustStarted;

/// The number of the current round. (The first round is number 1.)
@property (nonatomic) int currentRound;

/// Convenience property, holding the trailing players as of the start of the current round.
@property (nonatomic, readonly) NSMutableArray *trailingPlayers;

/// @name Initializing a Game

/** This is the designated initializer.
 
 @param newGameType A SixisGameType subclass object. This will define whether the game is being played for points or for rounds, and will provide the game's game-end checks.
 
 @param newPlayersType A SixisPlayersType subclass object. This will provide methods that must act differently depending upon the number of players present.
 
 @param newPlayers An array of SixisPlayer objects.

 */
-(id)initWithGameType: (SixisGameType *)newGameType
          PlayersType: (SixisPlayersType *)newPlayersType
              Players: (NSArray *)newPlayers;

/// @name Controlling game flow
 
/** 
 Starts a new game, given the players and configuration objects already present. Resets all player scores to zero, and the round counter to zero.

It then calls startRound:.
 */
-(void)startGame;

/** Starts a new round. Shuffles the deck and deals out cards to the table. The number of cards it deals varies depending upon the playersType object present.

It then calls startTurn:.

 */
-(void)startRound;


/// Ends the current round, and sends out a notification about this.
-(void)endRound;

/** Starts a new turn, shifting the currentPlayer pointer appropriately. */
-(void)startTurn;

/// Deals the top _N_ cards from the deck to the table, where _N_ is defined by the playersType object present.
-(void)deal;

/// Returns an array holding only the cards still on the table. This is a convenience method around having to filter the blank spots out of the game object's raw cards array.
-(NSArray *)remainingCardsInPlay;


/// Returns the subset of remainingCardsInPlay containing only those cards available to the current player.
-(NSSet *)availableCards;

// -(void)endRobotTurn;

/// Returns YES if this is a two-player game, and the board is in a state where either player has the option of declaring the round over (at the start of their turn).
-(BOOL) roundMightEnd;

/// Encodes and saves the game state to the filesystem.
-(BOOL) save;

/// Removes this game's save-position from the filesystem.
-(void) unsave;

/// An (English-only, at this time) explanation of why the round just ended. Note that it does no sanity-checking of whether a round actually did just end. Calling this method at any other time won't give you meaningful information.
-(NSString *) roundEndExplanation;

// Notification handlers
-(void)handleNewTurn:(NSNotification *)note;
-(void)handleDiceRoll:(NSNotification *)note;
-(void)handleCardPickup:(NSNotification *)note;
-(void)handleCardFlip:(NSNotification *)note;
-(void)handleDiceLock:(NSNotification *)note;
-(void)handleWinning:(NSNotification *)note;
-(void)handleDealtCard:(NSNotification *)note;

+(NSString *)gameArchivePath;

@end
