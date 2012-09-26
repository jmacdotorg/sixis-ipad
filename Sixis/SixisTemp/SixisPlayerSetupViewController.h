//
//  SixisPlayerSetupViewController.h
//  SixisTemp
//
//  Created by Jason McIntosh on 6/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SixisNewGameInfo;

@interface SixisPlayerSetupViewController : UITableViewController {

}

@property (nonatomic, strong) SixisNewGameInfo *gameInfo;
@property (nonatomic, strong) NSMutableSet *unusedColors;

-(void)doneTapped:(id)sender;
-(void)assignAnyUnusedColorToPlayerNumber:(int)playerNumber;
-(void)assignColor:(UIColor *)newColor toPlayerNumber:(int)playerNumber;

@end
