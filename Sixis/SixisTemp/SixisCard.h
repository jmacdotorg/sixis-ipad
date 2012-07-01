//
//  SixisCard.h
//  SixisTemp
//
//  Created by Jason McIntosh on 6/26/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SixisGame;

@interface SixisCard : NSObject {
//    BOOL (^dieTest)(id, BOOL *);
    
}

@property (nonatomic) BOOL isBlue;
@property (nonatomic, weak) SixisCard *flipSide;
@property (nonatomic, weak) SixisGame *game;
@property (nonatomic) int value;

-(BOOL) isQualified;

-(id) initWithValue:(int)newValue
           flipSide:(SixisCard *)newFlipSide
           Blueness:(BOOL)blueness;

@end
