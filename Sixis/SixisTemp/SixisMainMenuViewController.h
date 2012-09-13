//
//  SixisMainMenuViewController.h
//  Sixis
//
//  Created by Jason McIntosh on 8/15/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SixisTabletopViewController;
@class SixisNewGameInfo;

@interface SixisMainMenuViewController : UIViewController {
    UINavigationController *navController;
    NSMutableArray *seatLabels;
}
@property (weak, nonatomic) IBOutlet UIImageView *bigCardBack;
@property (weak, nonatomic) IBOutlet UIView *bigCardView;
@property (weak, nonatomic) IBOutlet UIView *bigCardRules;
@property (weak, nonatomic) IBOutlet UIWebView *rulesWebView;
- (IBAction)handlePlayButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *controlsView;
@property (nonatomic) SixisTabletopViewController *tabletopController;

-(void)displaySeatingArrangementWithGameInfo:(SixisNewGameInfo *)gameInfo;
-(void)hideSeatingArrangement;

-(void)showRulesCard;
-(void)hideRulesCard;

@end
