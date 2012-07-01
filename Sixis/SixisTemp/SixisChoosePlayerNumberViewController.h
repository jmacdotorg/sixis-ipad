//
//  SixisChoosePlayerNumberViewController.h
//  SixisTemp
//
//  Created by Jason McIntosh on 6/20/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SixisNewGameInfo.h"

@interface SixisChoosePlayerNumberViewController : UIViewController

@property (nonatomic, strong) SixisNewGameInfo *gameInfo;

- (IBAction)twoPlayerButtonTapped:(id)sender;
- (IBAction)threePlayerButtonTapped:(id)sender;
- (IBAction)fourPlayerButtonTapped:(id)sender;

@end
