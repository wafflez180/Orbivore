//
//  circleBlue.m
//  CircleMatch
//
//  Created by Arthur Araujo on 8/21/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "circleBlue.h"
#include <math.h>

@implementation circleBlue{
    
    CGPoint originalBlueLocation;
    CGFloat originalMass;
}

- (void)didLoadFromCCB
{
    self.physicsBody.affectedByGravity = TRUE;
    self.physicsBody.collisionType = @"touchedCircleBlue";
    self.userInteractionEnabled = TRUE;
    self.zOrder = 0;
    originalMass = self.physicsBody.mass;
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    
        CGPoint touchLocation = [touch locationInWorld];
        
        self.position = touchLocation;
        self.physicsBody.affectedByGravity = FALSE;
        self.physicsBody.allowsRotation = FALSE;
        self.physicsBody.velocity = ccp(0, 0);
        self.physicsBody.sleeping = FALSE;
        
        originalBlueLocation = touchLocation;
        
    
}
-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    
        CGPoint touchLocation = [touch locationInWorld];
        
        self.position = touchLocation;
        self.physicsBody.affectedByGravity = FALSE;
        self.physicsBody.allowsRotation = FALSE;
        self.physicsBody.velocity = ccp(0, 0);
    
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    
    if(self.userInteractionEnabled == TRUE){
    
    CGPoint touchLocation = [touch locationInWorld];
    
        self.position = touchLocation;
        self.physicsBody.affectedByGravity = FALSE;
        self.physicsBody.allowsRotation = FALSE;
        
        CGPoint calculatedImpulseLocation;
        
        calculatedImpulseLocation.x = originalBlueLocation.x - touchLocation.x;
        calculatedImpulseLocation.y = originalBlueLocation.y - touchLocation.y;
        
        calculatedImpulseLocation.x = -calculatedImpulseLocation.x * 100;
        calculatedImpulseLocation.y = -calculatedImpulseLocation.y * 100;
        
        if (calculatedImpulseLocation.x == 0) {
            calculatedImpulseLocation.x = 1;
        }
        if (calculatedImpulseLocation.y == 0) {
            calculatedImpulseLocation.y = 1;
        }
        
        int limitedspeed = 5000;
        
          //////// LIMITS THE SPEED OF THE BALL /////////
        
        if (calculatedImpulseLocation.x > limitedspeed ) {
            calculatedImpulseLocation.x = limitedspeed;
        }
        if (calculatedImpulseLocation.x < -limitedspeed ) {
            calculatedImpulseLocation.x = -limitedspeed;
        }
        if (calculatedImpulseLocation.y > limitedspeed ) {
            calculatedImpulseLocation.y = limitedspeed;
        }
        if (calculatedImpulseLocation.y < -limitedspeed ) {
            calculatedImpulseLocation.y = -limitedspeed;
        }
        
        self.physicsBody.mass = originalMass;
        
        if (calculatedImpulseLocation.x < 2 && calculatedImpulseLocation.x > -2) {
            self.physicsBody.affectedByGravity = TRUE;
            self.physicsBody.allowsRotation = FALSE;
            self.physicsBody.sleeping = FALSE;
            calculatedImpulseLocation.x = 2;
        }
        if (calculatedImpulseLocation.y < 2 && calculatedImpulseLocation.y > -2) {
            self.physicsBody.affectedByGravity = TRUE;
            self.physicsBody.allowsRotation = FALSE;
            self.physicsBody.sleeping = FALSE;
            calculatedImpulseLocation.y = 2;
        }
        
        self.physicsBody.velocity = ccp(1,1);
        [self.physicsBody setVelocity:ccp(1, 1)];
        
        self.physicsBody.mass = 3;
        
        if (isnan(self.physicsBody.velocity.x)) {
            NSLog(@"BLUE CIRCLE NAN DETECTED = %f", self.physicsBody.velocity.x);
        }
        if (isnan(self.physicsBody.velocity.y)) {
            NSLog(@"BLUE CIRCLE NAN DETECTED = %f", self.physicsBody.velocity.y);
        }
        
        NSLog(@"Applied Impulse: %f, %f", calculatedImpulseLocation.x, calculatedImpulseLocation.y);
        
        [self.physicsBody applyImpulse:calculatedImpulseLocation];
    }
}

-(void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event{
    
    if(self.userInteractionEnabled == TRUE){
        
        CGPoint touchLocation = [touch locationInWorld];
        
        self.position = touchLocation;
        self.physicsBody.affectedByGravity = FALSE;
        self.physicsBody.allowsRotation = FALSE;
        
        CGPoint calculatedImpulseLocation;
        
        calculatedImpulseLocation.x = originalBlueLocation.x - touchLocation.x;
        calculatedImpulseLocation.y = originalBlueLocation.y - touchLocation.y;
        
        calculatedImpulseLocation.x = -calculatedImpulseLocation.x * 100;
        calculatedImpulseLocation.y = -calculatedImpulseLocation.y * 100;
        
        if (calculatedImpulseLocation.x == 0) {
            calculatedImpulseLocation.x = 1;
        }
        if (calculatedImpulseLocation.y == 0) {
            calculatedImpulseLocation.y = 1;
        }
        
        int limitedspeed = 5000;
        
        //////// LIMITS THE SPEED OF THE BALL /////////
        
        if (calculatedImpulseLocation.x > limitedspeed ) {
            calculatedImpulseLocation.x = limitedspeed;
        }
        if (calculatedImpulseLocation.x < -limitedspeed ) {
            calculatedImpulseLocation.x = -limitedspeed;
        }
        if (calculatedImpulseLocation.y > limitedspeed ) {
            calculatedImpulseLocation.y = limitedspeed;
        }
        if (calculatedImpulseLocation.y < -limitedspeed ) {
            calculatedImpulseLocation.y = -limitedspeed;
        }
        
        self.physicsBody.mass = originalMass;
        
        if (calculatedImpulseLocation.x < 2 && calculatedImpulseLocation.x > -2) {
            self.physicsBody.affectedByGravity = TRUE;
            self.physicsBody.allowsRotation = FALSE;
            self.physicsBody.sleeping = FALSE;
            calculatedImpulseLocation.x = 2;
        }
        if (calculatedImpulseLocation.y < 2 && calculatedImpulseLocation.y > -2) {
            self.physicsBody.affectedByGravity = TRUE;
            self.physicsBody.allowsRotation = FALSE;
            self.physicsBody.sleeping = FALSE;
            calculatedImpulseLocation.y = 2;
        }
        
        NSLog(@"Applied Impulse: %f, %f", calculatedImpulseLocation.x, calculatedImpulseLocation.y);
        
        [self.physicsBody applyImpulse:calculatedImpulseLocation];
    }
}
@end
