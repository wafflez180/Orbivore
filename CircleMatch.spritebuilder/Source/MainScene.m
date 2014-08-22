//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "circleBlue.h"
#import "circleGreen.h"
#import "circleOrange.h"


@implementation MainScene{
    CCSprite *goalBlue;
    CCSprite *goalOrange;
    CCSprite *goalGreen;
    CCPhysicsNode *physicsNode;
    circleBlue* thecircleBlue;
    BOOL touchedBlue;
    CGPoint originalBlueLocation;
    CGPoint calculatedImpulseLocation;
}

-(void)didLoadFromCCB{
    self.userInteractionEnabled = true;
    
    goalBlue.physicsBody.collisionType = @"shotAtBlue";
    
    physicsNode.collisionDelegate = self;
    
    [self spawncircles];
    
}

-(void)spawncircles{
    
    if (touchedBlue != TRUE) {
    
    thecircleBlue = (circleBlue*)[CCBReader load:@"circleBlue"];
    
    thecircleBlue.positionInPoints = ccp(physicsNode.contentSizeInPoints.width / 2, physicsNode.contentSizeInPoints.height / 2);
    
    [physicsNode addChild:thecircleBlue];
        
    }
    
    [self performSelector:@selector(spawncircles) withObject:nil afterDelay:1];
}

-(void)update:(CCTime)delta{
    
    if (touchedBlue) {
        thecircleBlue.physicsBody.affectedByGravity = FALSE;
        thecircleBlue.physicsBody.allowsRotation = FALSE;
        thecircleBlue.physicsBody.sleeping = FALSE;
    }
    
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    
    CGPoint touchLocation = [touch locationInNode:physicsNode];
    
    if (CGRectContainsPoint([thecircleBlue boundingBox], touchLocation)) {
        thecircleBlue.position = touchLocation;
        touchedBlue = TRUE;
        thecircleBlue.physicsBody.affectedByGravity = FALSE;
        thecircleBlue.physicsBody.allowsRotation = FALSE;
        thecircleBlue.physicsBody.velocity = ccp(0, 0);
        thecircleBlue.physicsBody.sleeping = FALSE;
        
        originalBlueLocation = touchLocation;
    }
}
-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    
    CGPoint touchLocation = [touch locationInNode:physicsNode];
    
    if (CGRectContainsPoint([thecircleBlue boundingBox], touchLocation) && touchedBlue) {
        thecircleBlue.position = touchLocation;
        thecircleBlue.physicsBody.affectedByGravity = FALSE;
        thecircleBlue.physicsBody.allowsRotation = FALSE;
        thecircleBlue.physicsBody.velocity = ccp(0, 0);
    }
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    
        CGPoint touchLocation = [touch locationInNode:physicsNode];
    
    if (CGRectContainsPoint([thecircleBlue boundingBox], touchLocation) || touchedBlue) {
        thecircleBlue.position = touchLocation;
        thecircleBlue.physicsBody.affectedByGravity = FALSE;
        thecircleBlue.physicsBody.allowsRotation = FALSE;
        
        calculatedImpulseLocation.x = originalBlueLocation.x - touchLocation.x;
        calculatedImpulseLocation.y = originalBlueLocation.y - touchLocation.y;
        
        calculatedImpulseLocation.x = -calculatedImpulseLocation.x * 15;
        calculatedImpulseLocation.y = -calculatedImpulseLocation.y * 15;

        
        [thecircleBlue.physicsBody applyImpulse:calculatedImpulseLocation];
    }
}

-(void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLocation = [touch locationInNode:physicsNode];
    
    if (CGRectContainsPoint([thecircleBlue boundingBox], touchLocation)  || touchedBlue) {
        thecircleBlue.position = touchLocation;
        thecircleBlue.physicsBody.affectedByGravity = FALSE;
        thecircleBlue.physicsBody.allowsRotation = FALSE;
        
        calculatedImpulseLocation.x = originalBlueLocation.x - touchLocation.x;
        calculatedImpulseLocation.y = originalBlueLocation.y - touchLocation.y;
        
        calculatedImpulseLocation.x = -calculatedImpulseLocation.x * 15;
        calculatedImpulseLocation.y = -calculatedImpulseLocation.y * 15;
        
        
        [thecircleBlue.physicsBody applyImpulse:calculatedImpulseLocation];
    }
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair touchedCircleBlue:(CCSprite *)touchedCircleBlue shotAtBlue:(CCSprite *)shotAtBlue {
    [thecircleBlue removeFromParent];
    touchedBlue = FALSE;
    return TRUE;
}

@end
