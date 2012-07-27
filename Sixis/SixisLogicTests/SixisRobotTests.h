//
//  SixisRobotTests.h
//  Sixis
//
//  Created by Jason McIntosh on 7/12/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

@class SixisGame;
@class SixisSmartbot;
#import <SenTestingKit/SenTestingKit.h>

@interface SixisRobotTests : SenTestCase {
    SixisGame *game;
    SixisSmartbot *rockem;
    SixisSmartbot *sockem;
}

-(void)checkForWinner;

@end
