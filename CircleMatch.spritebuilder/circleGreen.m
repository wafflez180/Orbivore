//
//  circleGreen.m
//  CircleMatch
//
//  Created by Arthur Araujo on 8/21/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "circleGreen.h"

@implementation circleGreen{
    
    CGPoint originalBlueLocation;
    CGFloat originalMass;
    BOOL touchedBlue;
    CGPoint originaltouchLocationInside;
    
}

- (void)didLoadFromCCB
{
    self.physicsBody.affectedByGravity = TRUE;
    self.physicsBody.collisionType = @"touchedCircleGreen";
    self.userInteractionEnabled = TRUE;
    self.zOrder = 0;
    originalMass = self.physicsBody.mass;
    touchedBlue = FALSE;
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    
    if(touchedBlue == FALSE){
        
        CGPoint touchLocation = [touch locationInWorld];
        
        self.position = touchLocation;
        self.physicsBody.affectedByGravity = FALSE;
        self.physicsBody.allowsRotation = FALSE;
        self.physicsBody.velocity = ccp(0, 0);
        self.physicsBody.sleeping = FALSE;
        
        originalBlueLocation = touchLocation;
        
    }
    
}
-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    
    if(touchedBlue == FALSE){
        
        
        CGPoint touchLocation = [touch locationInWorld];
        
        self.position = touchLocation;
        
        self.physicsBody.affectedByGravity = FALSE;
        self.physicsBody.allowsRotation = FALSE;
        self.physicsBody.velocity = ccp(0, 0);
        
    }
    
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    
    if(touchedBlue == FALSE && self.userInteractionEnabled == TRUE){
        
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
        
        NSLog(@"Applied Impulse: %f, %f", calculatedImpulseLocation.x, calculatedImpulseLocation.y);
        
        [self.physicsBody applyImpulse:calculatedImpulseLocation];
        
        touchedBlue = TRUE;
        
    }
}

-(void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event{
    
    if(touchedBlue == FALSE && self.userInteractionEnabled == TRUE){
        
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
        
        NSLog(@"Applied Impulse: %f, %f", calculatedImpulseLocation.x, calculatedImpulseLocation.y);
        
        [self.physicsBody applyImpulse:calculatedImpulseLocation];
        
        touchedBlue = TRUE;
        
    }
}
@end
