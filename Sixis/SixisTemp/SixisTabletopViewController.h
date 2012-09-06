//
//  SixisTabletopViewController.h
//  Sixis
//
//  Created by Jason McIntosh on 7/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class SixisGame;
@class SixisPlayer;
@class SixisCard;
@class SixisMainMenuViewController;
@class SixisGameType;

@interface SixisTabletopViewController : UIViewController {
    NSMutableArray *cards;
    NSMutableArray *statusBars;
    UIView *playerControls;
    UIPopoverController *popover;
    NSDictionary *tableInfoForPlayer;
    BOOL thereAreHighlightedCards;
    SixisPlayer *firstPlayer;
    BOOL thisIsTheFirstGoRound;
    SixisGameType *originalGameType;
    AVAudioPlayer *audioPlayer;
}
@property (weak, nonatomic) IBOutlet UILabel *winMessage;
@property (weak, nonatomic) IBOutlet UIView *gameOverView;
@property (weak, nonatomic) IBOutlet UIButton *rollAllDiceButton;
@property (weak, nonatomic) IBOutlet UIButton *rollUnlockedDiceButton;
@property (weak, nonatomic) IBOutlet UIButton *endTurnButton;
@property (weak, nonatomic) IBOutlet UIView *diceView;
@property (weak, nonatomic) IBOutlet UIButton *endRoundButton;
@property (strong, nonatomic) IBOutlet UILabel *textPromptLabel;
@property (weak, nonatomic) IBOutlet UIButton *undoCardButton;
@property (nonatomic) SixisMainMenuViewController *mainMenuController;
@property (nonatomic) BOOL aCardAnimationIsOccurring;
@property (weak, nonatomic) IBOutlet UILabel *roundEndExplanationLabel;
@property (weak, nonatomic) IBOutlet UIView *roundEndControls;

- (IBAction)handleRollAllDiceTap:(id)sender;
- (IBAction)handleRollUnlockedDiceTap:(id)sender;
- (IBAction)handleDieTap:(id)sender;
- (IBAction)handleEndTurnTap:(id)sender;
-(void)handleTakeCardTap:(SixisCard *)card;
-(void)handleFlipCardTap:(SixisCard *)card;
- (IBAction)handleEndRoundButtonTap:(id)sender;
- (IBAction)handlePlayAgain:(id)sender;
- (IBAction)handleMainMenu:(id)sender;
- (IBAction)handleAddRound:(id)sender;
- (IBAction)handleUndoCard:(id)sender;
- (IBAction)handleNextRound:(id)sender;


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
