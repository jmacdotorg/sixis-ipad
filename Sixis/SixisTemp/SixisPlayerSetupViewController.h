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

UIBarButtonItem *doneButton;

}

@property (nonatomic, strong) SixisNewGameInfo *gameInfo;

@end
