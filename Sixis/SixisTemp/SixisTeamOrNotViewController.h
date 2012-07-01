//
//  SixisTeamOrNotViewController.h
//  SixisTemp
//
//  Created by Jason McIntosh on 6/22/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

@class SixisNewGameInfo;
#import <UIKit/UIKit.h>

@interface SixisTeamOrNotViewController : UIViewController
- (IBAction)yesButtonTapped:(id)sender;
- (IBAction)noButtonTapped:(id)sender;

@property SixisNewGameInfo *gameInfo;

@end
