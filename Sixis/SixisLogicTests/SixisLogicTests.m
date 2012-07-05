//
//  SixisLogicTests.m
//  SixisLogicTests
//
//  Created by Jason McIntosh on 7/4/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisLogicTests.h"
#import "SixisTwoPlayers.h"
#import "SixisRoundsGame.h"
#import "SixisHuman.h"

@implementation SixisLogicTests

- (void)setUp
{
    [super setUp];
    
    alice = [[SixisHuman alloc] initWithName:@"Alice"];
    bob = [[SixisHuman alloc] initWithName:@"Bob"];
    
    NSArray *players = [NSArray arrayWithObjects: alice, bob, nil];
    
    game = [[SixisGame alloc] initWithGameType:[[SixisRoundsGame alloc] initWithRounds:1] PlayersType:[[SixisTwoPlayers alloc] init] Players:players];
    
    [game startGame];
    NSLog(@"I see this many cards on the table: %d", [game cardsInPlay].count);
}

- (void)testGameSetup {
    STAssertTrue([game players].count == 2, @"There are two players here");
    STAssertTrue([game cardsInPlay].count == 9, @"There are nine cards in play");
    STAssertNil([game winningPlayers], @"There are no winning players yet");
    STAssertEqualObjects(bob, [game currentPlayer], @"Bob gets the first turn.");
    STAssertEquals([bob score], 0, @"Bob has no points at the start of the game.");
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

/*
- (void)testExample
{
    STFail(@"Unit tests are not implemented yet in SixisLogicTests");
}
*/

@end
