//
//  SixisPlayer.h
//  SixisTemp
//
//  Created by Jason McIntosh on 6/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SixisCard;
@class SixisGame;

@interface SixisPlayer : NSObject <NSCoding> {

}

@property (nonatomic, copy) NSString* name;
@property (nonatomic, strong) NSMutableSet *unlockedDice;
@property (nonatomic, strong) NSMutableSet *lockedDice;
@property (nonatomic, copy) UIColor *dieColor;
@property (nonatomic) int score;
@property (nonatomic, weak) SixisGame *game;
@property int number;

@property (nonatomic) SixisCard *cardJustFlipped;
@property (nonatomic) SixisCard *cardJustTaken;
@property (nonatomic) int indexOfLastCardAction;
@property (nonatomic) BOOL hasRolledDice;

-(id)initWithName: (NSString *)newName;

-(void) takeCard:(SixisCard *)card;
-(void) flipCard:(SixisCard *)card;
-(void) undoLastAction;

-(void) rollAllDice;
-(void) rollUnlockedDice;

-(void) endTurn;
-(void) endRound;

-(NSSet *)dice;

-(NSDictionary *) sortedDice;

-(NSComparisonResult) compareScores:(SixisPlayer *)otherPlayer;

-(SixisPlayer *) teammate;

@end
