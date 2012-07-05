//
//  SixisLogicTests.h
//  SixisLogicTests
//
//  Created by Jason McIntosh on 7/4/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "SixisGame.h"
#import "SixisHuman.h"


@interface SixisLogicTests : SenTestCase {
    SixisGame *game;
    SixisHuman *alice;
    SixisHuman *bob;
}

@end
