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
@class SixisCard;

@interface SixisTabletopViewController : UIViewController {
    NSMutableArray *cards;
    UIView *playerControls;
    UIPopoverController *popover;
    NSDictionary *statusBarForPlayer;
}
@property (weak, nonatomic) IBOutlet UILabel *player1Score;
@property (weak, nonatomic) IBOutlet UILabel *player2Score;
@property (weak, nonatomic) IBOutlet UILabel *winMessage;
@property (weak, nonatomic) IBOutlet UIButton *rollAllDiceButton;
@property (weak, nonatomic) IBOutlet UIButton *rollUnlockedDiceButton;
@property (weak, nonatomic) IBOutlet UIButton *endTurnButton;
@property (weak, nonatomic) IBOutlet UIView *diceView;
@property (weak, nonatomic) IBOutlet UIButton *endRoundButton;

- (IBAction)handleRollAllDiceTap:(id)sender;
- (IBAction)handleRollUnlockedDiceTap:(id)sender;
- (IBAction)handleDieTap:(id)sender;
- (IBAction)handleEndTurnTap:(id)sender;
-(void)handleTakeCardTap:(SixisCard *)card;
-(void)handleFlipCardTap:(SixisCard *)card;
- (IBAction)handleEndRoundButtonTap:(id)sender;

@property (nonatomic, strong) SixisGame *game;
@property (nonatomic, strong) SixisPlayer *currentPlayer;

-(void)_addCardViewWithX: (int) x
                       Y: (int) y
                rotation: (CGFloat) rotation;

// Notification handlers.
-(void)handleNewTurn:(NSNotification *)note;
-(void)handleDiceRoll:(NSNotification *)note;
-(void)handleCardPickup:(NSNotification *)note;
-(void)handleCardFlip:(NSNotification *)note;
-(void)handleDiceLock:(NSNotification *)note;
-(void)handleWinning:(NSNotification *)note;
-(void)handleDealtCard:(NSNotification *)note;

@end
