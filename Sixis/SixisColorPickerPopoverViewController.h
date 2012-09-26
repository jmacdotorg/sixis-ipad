//
//  SixisColorPickerPopoverViewController.h
//  Sixis
//
//  Created by Jason McIntosh on 9/24/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SixisDieView;
@class SixisPlayerSetupViewController;
@class SixisPlayerSetupCell;

@interface SixisColorPickerPopoverViewController : UIViewController

@property (weak, nonatomic) IBOutlet SixisDieView *redButton;
@property (weak, nonatomic) IBOutlet SixisDieView *greenButton;
@property (weak, nonatomic) IBOutlet SixisDieView *blackButton;
@property (weak, nonatomic) IBOutlet SixisDieView *purpleButton;
@property (weak, nonatomic) IBOutlet SixisDieView *whiteButton;
@property (weak, nonatomic) IBOutlet SixisDieView *blueButton;

//@property (weak, nonatomic) SixisPlayerSetupViewController *parent;
@property (weak, nonatomic) SixisPlayerSetupCell *parent;

@property int playerNumber;

- (IBAction)handleRedButton:(id)sender;
- (IBAction)handleGreenButton:(id)sender;
- (IBAction)handleBlackButton:(id)sender;
- (IBAction)handlePurpleButton:(id)sender;
- (IBAction)handleWhiteButton:(id)sender;
- (IBAction)handleBlueButton:(id)sender;

-(void)drawButtonsForPlayerNumber:(int)playerNumber;

@end
