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
    circleGreen* thecircleGreen;
    circleOrange* thecircleOrange;
    CGPoint calculatedImpulseLocation;
    int wrong;
    int score;
    CCLabelTTF *scoreLabel;
}

-(void)didLoadFromCCB{
    self.userInteractionEnabled = true;
    
    goalBlue.physicsBody.collisionType = @"shotAtBlue";
    goalGreen.physicsBody.collisionType = @"shotAtGreen";
    goalOrange.physicsBody.collisionType = @"shotAtOrange";
    
    physicsNode.collisionDelegate = self;
    
    [self spawncircles];
    
    score = 0;
    wrong = 0;
    
}

-(void)update:(CCTime)delta{
    scoreLabel.string = [NSString stringWithFormat:@"%i", score];
}

-(void)spawncircles{
    
    float randomspawntime = arc4random() % 4;
    
    if (randomspawntime == 1) {
    [self spawnbluecircles];
    }
    if (randomspawntime == 2) {
    [self spawngreencircles];
    }
    if (randomspawntime == 3) {
    [self spawnorangecircles];
    }
    
    [self performSelector:@selector(spawncircles) withObject:nil afterDelay:1];
}

-(void)spawnbluecircles{
    
    thecircleBlue = (circleBlue*)[CCBReader load:@"circleBlue"];
    
    float random = arc4random() % 20;
    
    random = random + 7;
    
    random = random / 10.00f + 1;
    
    thecircleBlue.positionInPoints = ccp(physicsNode.contentSizeInPoints.width * 1.5, physicsNode.contentSizeInPoints.height / random);
    
    [physicsNode addChild:thecircleBlue];
    
    [thecircleBlue.physicsBody setSleeping:FALSE];
}
-(void)spawngreencircles{
    
    thecircleGreen = (circleGreen*)[CCBReader load:@"circleGreen"];
    
    float random = arc4random() % 20;
    
    random = random + 7;
    
    random = random / 10.00f + 1;
    
    thecircleGreen.positionInPoints = ccp(physicsNode.contentSizeInPoints.width * 1.5, physicsNode.contentSizeInPoints.height / random);
    
    [physicsNode addChild:thecircleGreen];
    
    [thecircleGreen.physicsBody setSleeping:FALSE];
}
-(void)spawnorangecircles{
    
    thecircleOrange = (circleOrange*)[CCBReader load:@"circleOrange"];
    
    float random = arc4random() % 20;
    
    random = random + 7;
    
    random = random / 10.00f + 1;
    
    thecircleOrange.positionInPoints = ccp(physicsNode.contentSizeInPoints.width * 1.5, physicsNode.contentSizeInPoints.height / random);
    
    [physicsNode addChild:thecircleOrange];
    
    [thecircleOrange.physicsBody setSleeping:FALSE];
}

-(void)removefake:(CCSprite *)fake{
    
    [fake removeFromParent];
    
}

// COLLISIONS WITH BLUE CIRCLE

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair touchedCircleBlue:(CCSprite *)touchedCircleBlue shotAtBlue:(CCSprite *)shotAtBlue {
    
    CCSprite *currentfake = [CCSprite spriteWithImageNamed:@"Circle3Fake.png"];
    
    [self addChild:currentfake];
    
    currentfake.position = touchedCircleBlue.position;
    
    currentfake.scale = 2;
    [currentfake runAction:[CCActionScaleTo actionWithDuration:.20 scale:.5]];
    
    [currentfake runAction:[CCActionMoveTo actionWithDuration:.20 position:goalBlue.positionInPoints]];
    [currentfake runAction:[CCActionRotateBy actionWithDuration:.20 angle:10080]];
    
    [self performSelector:@selector(removefake:) withObject:currentfake afterDelay:.20];
    
    touchedCircleBlue.userInteractionEnabled = FALSE;
    
    [touchedCircleBlue removeFromParent];

    score++;
    
    return TRUE;
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair touchedCircleBlue:(CCSprite *)touchedCircleBlue shotAtGreen:(CCSprite *)shotAtGreen {
    
    [touchedCircleBlue removeFromParent];
    
    wrong++;
    
    return TRUE;
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair touchedCircleBlue:(CCSprite *)touchedCircleBlue shotAtOrange:(CCSprite *)shotAtOrange {
    
    [touchedCircleBlue removeFromParent];
    
    wrong++;
    
    return TRUE;
}

// COLLISIONS WITH GREEN CIRCLE

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair touchedCircleGreen:(CCSprite *)touchedCircleGreen shotAtBlue:(CCSprite *)shotAtBlue {
    
    [touchedCircleGreen removeFromParent];
    
    wrong++;
    
    return TRUE;
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair touchedCircleGreen:(CCSprite *)touchedCircleGreen shotAtGreen:(CCSprite *)shotAtGreen {
    
    CCSprite *currentfake = [CCSprite spriteWithImageNamed:@"Circle2Fake.png"];
    
    [self addChild:currentfake];
    
    currentfake.position = touchedCircleGreen.position;
    
    currentfake.scale = 2;
    [currentfake runAction:[CCActionScaleTo actionWithDuration:.20 scale:.5]];
    
    [currentfake runAction:[CCActionMoveTo actionWithDuration:.20 position:goalGreen.positionInPoints]];
    [currentfake runAction:[CCActionRotateBy actionWithDuration:.20 angle:10080]];
    
    [self performSelector:@selector(removefake:) withObject:currentfake afterDelay:.20];
    
    touchedCircleGreen.userInteractionEnabled = FALSE;
    
    [touchedCircleGreen removeFromParent];
    
    score++;
    
    return TRUE;
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair touchedCircleGreen:(CCSprite *)touchedCircleGreen shotAtOrange:(CCSprite *)shotAtOrange {
    
    [touchedCircleGreen removeFromParent];
    
    wrong++;
    
    return TRUE;
}

// COLLISIONS WITH ORANGE CIRCLE

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair touchedCircleOrange:(CCSprite *)touchedCircleOrange shotAtBlue:(CCSprite *)shotAtBlue {
    
    [touchedCircleOrange removeFromParent];
    
    wrong++;
    
    return TRUE;
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair touchedCircleOrange:(CCSprite *)touchedCircleOrange shotAtGreen:(CCSprite *)shotAtGreen {
    
    [touchedCircleOrange removeFromParent];
    
    wrong++;
    
    return TRUE;
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair touchedCircleOrange:(CCSprite *)touchedCircleOrange shotAtOrange:(CCSprite *)shotAtOrange {
    
    CCSprite *currentfake = [CCSprite spriteWithImageNamed:@"Circle1Fake.png"];
    
    [self addChild:currentfake];
    
    currentfake.position = touchedCircleOrange.position;
    
    currentfake.scale = 2;
    [currentfake runAction:[CCActionScaleTo actionWithDuration:.20 scale:.5]];
    
    [currentfake runAction:[CCActionMoveTo actionWithDuration:.20 position:goalOrange.positionInPoints]];
    [currentfake runAction:[CCActionRotateBy actionWithDuration:.20 angle:10080]];
    
    [self performSelector:@selector(removefake:) withObject:currentfake afterDelay:.20];
    
    touchedCircleOrange.userInteractionEnabled = FALSE;
    
    [touchedCircleOrange removeFromParent];
    
    score++;
    
    return TRUE;
}


// OFF BOUNDS COLLISIONS

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair touchedCircleOrange:(CCSprite *)touchedCircleOrange offbounds:(CCNodeColor *)offbounds {
    
    touchedCircleOrange.userInteractionEnabled = FALSE;
    
    [touchedCircleOrange removeFromParent];
    
    return TRUE;
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair touchedCircleBlue:(CCSprite *)touchedCircleBlue offbounds:(CCNodeColor *)offbounds {
    
    touchedCircleBlue.userInteractionEnabled = FALSE;
    
    [touchedCircleBlue removeFromParent];
    
    return TRUE;
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair touchedCircleGreen:(CCSprite *)touchedCircleGreen offbounds:(CCNodeColor *)offbounds {
    
    touchedCircleGreen.userInteractionEnabled = FALSE;
    
    [touchedCircleGreen removeFromParent];
    
    return TRUE;
}










// TO MAKE CIRCLES OVERLAPP/ PASS EACHOTHER

//GREEN
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair touchedCircleGreen:(CCSprite *)touchedCircleGreen touchedCircleGreen:(CCSprite *)touchedCircleGreen {
    return NO;
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair touchedCircleGreen:(CCSprite *)touchedCircleGreen touchedCircleOrange:(CCSprite *)touchedCircleOrange {
    return NO;
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair touchedCircleGreen:(CCSprite *)touchedCircleGreen touchedCircleBlue:(CCSprite *)touchedCircleBlue {
    return NO;
}


//BLUE
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair touchedCircleBlue:(CCSprite *)touchedCircleBlue touchedCircleGreen:(CCSprite *)touchedCircleGreen {
    return NO;
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair touchedCircleBlue:(CCSprite *)touchedCircleBlue touchedCircleOrange:(CCSprite *)touchedCircleOrange {
    return NO;
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair touchedCircleBlue:(CCSprite *)touchedCircleBlue touchedCircleBlue:(CCSprite *)touchedCircleBlue {
    return NO;
}

//ORANGE
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair touchedCircleOrange:(CCSprite *)touchedCircleOrange touchedCircleGreen:(CCSprite *)touchedCircleGreen {
    return NO;
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair touchedCircleOrange:(CCSprite *)touchedCircleOrange touchedCircleOrange:(CCSprite *)touchedCircleOrange {
    return NO;
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair touchedCircleOrange:(CCSprite *)touchedCircleOrange touchedCircleBlue:(CCSprite *)touchedCircleBlue {
    return NO;
}

@end
