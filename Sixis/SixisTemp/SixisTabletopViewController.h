//
//  SixisTabletopViewController.h
//  Sixis
//
//  Created by Jason McIntosh on 7/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SixisGame;
@class SixisPlayer;

@interface SixisTabletopViewController : UIViewController {
    NSMutableArray *cards;
}
@property (weak, nonatomic) IBOutlet UILabel *player1Score;
@property (weak, nonatomic) IBOutlet UILabel *player2Score;
@property (weak, nonatomic) IBOutlet UILabel *winMessage;


@property (nonatomic, strong) SixisGame *game;
@property (nonatomic, strong) SixisPlayer *currentPlayer;

-(void)_addCardViewWithX: (int) x
                       Y: (int) y
                   width: (int) width
                rotation: (int) rotation;

// Notification handlers.
-(void)handleNewTurn:(NSNotification *)note;
-(void)handleDiceRoll:(NSNotification *)note;
-(void)handleCardPickup:(NSNotification *)note;
-(void)handleCardFlip:(NSNotification *)note;
-(void)handleDiceLock:(NSNotification *)note;
-(void)handleWinning:(NSNotification *)note;
-(void)handleDealtCard:(NSNotification *)note;

@end
