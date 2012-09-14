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
    NSMutableArray *partnerLabels;
}
@property (weak, nonatomic) IBOutlet UIImageView *bigCardBack;
@property (weak, nonatomic) IBOutlet UIView *bigCardView;
@property (weak, nonatomic) IBOutlet UIView *bigCardRules;
@property (weak, nonatomic) IBOutlet UIWebView *rulesWebView;

@property (weak, nonatomic) IBOutlet UIView *controlsView;
@property (nonatomic) SixisTabletopViewController *tabletopController;

-(void)displaySeatingArrangementWithGameInfo:(SixisNewGameInfo *)gameInfo;
-(void)hideSeatingArrangement;

-(void)displayPartnerArangementWithGameInfo:(SixisNewGameInfo *)gameInfo;
-(void)hidePartnerArrangement;

-(void)showRulesCard;
-(void)hideRulesCard;

-(void)resetHelperViews;

@end
