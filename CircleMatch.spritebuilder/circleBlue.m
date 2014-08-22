//
//  circleBlue.m
//  CircleMatch
//
//  Created by Arthur Araujo on 8/21/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "circleBlue.h"

@implementation circleBlue{
    
}

- (void)didLoadFromCCB
{
    self.position = ccp(.50, .50);
    self.zOrder = 0;
    self.physicsBody.collisionType = @"touchedCircleBlue";
}

@end
