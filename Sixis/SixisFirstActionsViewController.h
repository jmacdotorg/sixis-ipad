//
//  SixisFirstActionsViewController.h
//  Sixis
//
//  Created by Jason McIntosh on 9/10/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SixisNewGameInfo;

@interface SixisFirstActionsViewController : UIViewController

@property (nonatomic, strong) SixisNewGameInfo *gameInfo;


- (IBAction)handlePlayButton:(id)sender;
- (IBAction)handleAboutButton:(id)sender;
@end
