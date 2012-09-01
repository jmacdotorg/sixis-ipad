//
//  SixisCard.h
//  SixisTemp
//
//  Created by Jason McIntosh on 6/26/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

/** This is an abstract class for Sixis cards. Each side of each card in the game gets its own class, a subclass of this one. 
 
 SixisCard provides properties and methods common to all Sixis cards. The card-specific subclasses are responsible for implementing their own isQualified: methods, as well as their own initWIthValue:flipSide:Blueness: initialization methods.

 Note that this implementation of Sixis treats each side of each of the game's double-sided cards as its own class. SixisCard's flipSide property serves to establish the relationship between one SixisCard subclass that is on the flip side of another card.
 
 */

#import <Foundation/Foundation.h>

@class SixisGame;

@interface SixisCard : NSObject <NSCoding> {
    
}

/// @name Properties

/// If this card is blue, then YES. If it's red, NO.
@property (nonatomic) BOOL isBlue;

/** (Blue cards only.) The card on the flip side of this one. That is, if the player chooses to flip the card, this is the card that will replace it on the table.
 
 Only blue cards have this property set, since red cards don't flip. (And making this a one-way relationship simplifies the object diagram.)
 */
@property (nonatomic, strong) SixisCard *flipSide;

/// The current SixisGame object.
@property (nonatomic, weak) SixisGame *game;

/// An integer representing this card's point value.
@property (nonatomic) int value;

/// @name Creating a card
/** Designated initializer. Creates a new card with the given value, flip-side card, and "blueness".
 
 SixisCard itself leaves this method as a minimal stub; card-specific subclasses must override it, defining their own point vaues and such.
 
 You shouldn't ever need to call this. A game object creates one of each card when it sets itself up, and that's all the card creation that ever happens. */

-(id) initWithValue:(int)newValue
           flipSide:(SixisCard *)newFlipSide
           Blueness:(BOOL)blueness;

/// @name Querying cards

/** Returns YES if the current player can pick up the current card, based on the results of the most recent die roll. NO otherwise.
 
 SixisCard itself leaves this method as a no-op stub; card-specific subclasses must define it. (Indeed, the bulk of a card's specific business logic will go into defining this. */

-(BOOL) isQualified;

/** Returns the SixisDie objects belonging to the current player which best fit this card's demands.
 
 If this is a blue card, then this message is automatically passed along to this card's flipSide: red card.
 */

-(NSSet *) bestDice;

/// @name Convenience methods

/// Calls sortedDice: on the current player.

-(NSDictionary *) sortedDice;

/// Calls dice: on the current player.

-(NSSet *) dice;

@end
