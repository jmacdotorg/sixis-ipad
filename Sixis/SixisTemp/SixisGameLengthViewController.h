//
//  SixisGameLengthViewController.h
//  SixisTemp
//
//  Created by Jason McIntosh on 6/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SixisNewGameInfo;

@interface SixisGameLengthViewController : UIViewController
- (IBAction)oneRoundButtonTapped:(id)sender;
- (IBAction)threeRoundButtonTapped:(id)sender;
- (IBAction)fiveRoundButtonTapped:(id)sender;
- (IBAction)pointButtonTapped:(id)sender;
@property SixisNewGameInfo *gameInfo;

@end
