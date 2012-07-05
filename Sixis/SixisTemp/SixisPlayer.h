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

@interface SixisPlayer : NSObject

@property (nonatomic, copy) NSString* name;
@property (nonatomic, strong) NSMutableSet *unlockedDice;
@property (nonatomic, strong) NSMutableSet *lockedDice;
@property (nonatomic, copy) UIColor *dieColor;
@property (nonatomic) int score;
@property (nonatomic, weak) SixisGame *game;

-(id)initWithName: (NSString *)newName;

-(void) takeCard:(SixisCard *)card;
-(void) flipCard:(SixisCard *)card;

-(void) rollAllDice;
-(void) rollUnlockedDice;

-(void) endTurn;

-(NSSet *)dice;

-(NSDictionary *) sortedDice;

-(NSComparisonResult) compareScores:(SixisPlayer *)otherPlayer;

@end
