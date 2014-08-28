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
#include <iAd/iAd.h>

@implementation MainScene{
    CCSprite *goalBlue;
    CCSprite *goalOrange;
    CCSprite *goalGreen;
    CCPhysicsNode *physicsNode;
    circleBlue* thecircleBlue;
    circleGreen* thecircleGreen;
    circleOrange* thecircleOrange;
    CGPoint calculatedImpulseLocation;
    int score;
    CCLabelTTF *scoreLabel;
    BOOL paused;
    BOOL firsttime;
    BOOL showedonecircle;
    BOOL lostgame;
    CCNodeColor *mainNodePopup;
    CCButton *startGameButton;
    CCSprite *circlesymbol;
    CCNode *circlesHolder;
    CCSprite *pressHoldGesture;
    CCSprite *singleTapGesture;
    CCSprite *nothingtapGesture;
    CCSprite *thumbUpGesture;
    CCLabelTTF *tutorialLabel;
    CCLabelTTF *YourReady;
    CCNode *tutorialNode;
    CCButton *tryAgain;
    CCLabelTTF *bestscoreLabel;
    CCLabelTTF *highscoreLabel;
    int highscore;
    ADBannerView *_bannerView;
}

-(void)didLoadFromCCB{
    
    paused = TRUE;
    self.userInteractionEnabled = TRUE;
    
    goalBlue.physicsBody.collisionType = @"shotAtBlue";
    goalGreen.physicsBody.collisionType = @"shotAtGreen";
    goalOrange.physicsBody.collisionType = @"shotAtOrange";
    
    physicsNode.collisionDelegate = self;
    
    score = 0;
    
    lostgame = FALSE;
    tryAgain.enabled = FALSE;
    tryAgain.visible = FALSE;
    
    firsttime = TRUE;
    
    highscore = 0;
    
    bestscoreLabel.visible = TRUE;
    bestscoreLabel.string = [NSString stringWithFormat:@"BEST: %i", highscore];
    
    highscoreLabel.visible = FALSE;
    
    thumbUpGesture.opacity = 0;
    
    tutorialNode.visible = FALSE;
    thumbUpGesture.visible = FALSE;
    nothingtapGesture.visible = FALSE;
    singleTapGesture.visible = FALSE;
    pressHoldGesture.visible = FALSE;
    tutorialLabel.visible = FALSE;
    
}

-(void)update:(CCTime)delta{
    
    if ( paused != TRUE) {
        if (score < 10) {
            
            physicsNode.physicsNode.gravity = ccp(-200, 0);
            self.spawnRate = 1;
        }
        if (score > 10) {
            physicsNode.physicsNode.gravity = ccp(-300, 0);
            self.spawnRate = 0.8;
        }
        if (score > 15) {
            physicsNode.physicsNode.gravity = ccp(-350, 0);
            self.spawnRate = 0.7;
        }
        
        if (score > 25) {
            physicsNode.physicsNode.gravity = ccp(-400, 0);
            self.spawnRate = 0.6;
        }
        if (score > 50) {
            physicsNode.physicsNode.gravity = ccp(-400, 0);
            self.spawnRate = 0.5;
        }
    }
    if (paused && startGameButton.enabled) {
        [circlesHolder removeAllChildren];
    }
    
    scoreLabel.string = [NSString stringWithFormat:@"%i", score];
    
    if (firsttime == TRUE && startGameButton.enabled == FALSE) {
        
        tutorialLabel.visible = TRUE;
    }else{
        tutorialLabel.visible = FALSE;
    }
    
    if (thumbUpGesture.opacity == 0) {
        YourReady.visible = FALSE;
    }else{
        YourReady.visible = TRUE;
    }
    
    if (paused) {
        physicsNode.userInteractionEnabled = FALSE;
        physicsNode.physicsNode.gravity = ccp(0,0);
    }else{
        physicsNode.userInteractionEnabled = TRUE;
    }
    
}

-(void)startgame{
    
    score = 0;
    
    if (firsttime != TRUE) {
    paused = FALSE;
    startGameButton.enabled = FALSE;
    startGameButton.visible = FALSE;
        tryAgain.enabled = FALSE;
        tryAgain.visible = FALSE;
        
    [self spawncircles];
        [bestscoreLabel runAction:[CCActionFadeOut actionWithDuration:1]];
        [highscoreLabel runAction:[CCActionFadeOut actionWithDuration:1]];
    [mainNodePopup runAction:[CCActionFadeOut actionWithDuration:1]];
    [circlesymbol runAction:[CCActionFadeOut actionWithDuration:1]];
    circlesHolder.userInteractionEnabled = TRUE;
    tutorialNode.visible = FALSE;

    }else{
        startGameButton.enabled = FALSE;
        startGameButton.visible = FALSE;
        tryAgain.enabled = FALSE;
        tryAgain.visible = FALSE;
        [mainNodePopup runAction:[CCActionFadeOut actionWithDuration:1]];
        [circlesymbol runAction:[CCActionFadeOut actionWithDuration:1]];
        [bestscoreLabel runAction:[CCActionFadeOut actionWithDuration:1]];
        [highscoreLabel runAction:[CCActionFadeOut actionWithDuration:1]];
        
        [self starttutorial];
    }
}

-(void)losegame{
    
    if (paused == FALSE) {
        
    paused = TRUE;
    
    if (highscore < score) {
        highscore = score;
    }
    bestscoreLabel.visible = TRUE;
    bestscoreLabel.string = [NSString stringWithFormat:@"BEST: %i", highscore];
    highscoreLabel.visible = TRUE;
    highscoreLabel.string = [NSString stringWithFormat:@"SCORE: %i", score];
    
    score = 0;
    [circlesHolder removeAllChildren];
    circlesHolder.userInteractionEnabled = FALSE;
    startGameButton.enabled = TRUE;
    startGameButton.visible = TRUE;
    tryAgain.enabled = TRUE;
    tryAgain.visible = TRUE;
    lostgame = TRUE;
    [bestscoreLabel runAction:[CCActionFadeIn actionWithDuration:1]];
    [highscoreLabel runAction:[CCActionFadeIn actionWithDuration:1]];
    [mainNodePopup runAction:[CCActionFadeIn actionWithDuration:1]];
    [circlesymbol runAction:[CCActionFadeIn actionWithDuration:1]];
    }
}

-(void)starttutorial{
    
    tutorialNode.visible = TRUE;
    
    tutorialLabel.visible = TRUE;
    
    tutorialLabel.string = @"Tutorial";
    
    pressHoldGesture.visible = FALSE;
    singleTapGesture.visible = FALSE;
    nothingtapGesture.visible = FALSE;
    
    if (showedonecircle == FALSE) {
    thecircleBlue = (circleBlue*)[CCBReader load:@"circleBlue"];
    
    thecircleBlue.positionInPoints = ccp(physicsNode.contentSizeInPoints.width * 1.5, physicsNode.contentSizeInPoints.height / 1.95);
    
    [circlesHolder addChild:thecircleBlue];
        
    thecircleBlue.userInteractionEnabled = FALSE;
        
    }else{
        thecircleGreen = (circleGreen*)[CCBReader load:@"circleGreen"];
        
        thecircleGreen.positionInPoints = ccp(physicsNode.contentSizeInPoints.width * 1.5, physicsNode.contentSizeInPoints.height / 1.95);
        
        [circlesHolder addChild:thecircleGreen];
        
        thecircleGreen.userInteractionEnabled = FALSE;
    }
    
    singleTapGesture.visible = TRUE;
    pressHoldGesture.visible = FALSE;
    
    [singleTapGesture runAction:[CCActionMoveTo actionWithDuration:1.8 position:ccp(physicsNode.contentSizeInPoints.width / 2,physicsNode.contentSizeInPoints.height / 1.95)]];
    
    [pressHoldGesture runAction:[CCActionMoveTo actionWithDuration:1.8 position:ccp(physicsNode.contentSizeInPoints.width / 2,physicsNode.contentSizeInPoints.height / 1.95)]];
    
    [nothingtapGesture runAction:[CCActionMoveTo actionWithDuration:1.8 position:ccp(physicsNode.contentSizeInPoints.width / 2,physicsNode.contentSizeInPoints.height / 1.95)]];
    
    if (showedonecircle != TRUE) {
        
    [self performSelector:@selector(tutorialflick:) withObject:thecircleBlue afterDelay:1.8];
        
    }else{
        
    [self performSelector:@selector(tutorialflick:) withObject:thecircleGreen afterDelay:1.8];
        
    }
}

-(void)tutorialflick:(CCSprite *)thecurrentcircle{
    
    singleTapGesture.visible = FALSE;
    pressHoldGesture.visible = TRUE;
    
    thecurrentcircle.positionInPoints = pressHoldGesture.positionInPoints;
    
    NSString *originalXlocation = [NSString stringWithFormat: @"%f", pressHoldGesture.positionInPoints.x];
    NSString *originalYlocation = [NSString stringWithFormat: @"%f", pressHoldGesture.positionInPoints.y];
    
    thecurrentcircle.physicsBody.affectedByGravity = FALSE;
    thecurrentcircle.physicsBody.allowsRotation = FALSE;
    thecurrentcircle.physicsBody.velocity = ccp(0, 0);
    thecurrentcircle.physicsBody.sleeping = FALSE;
    
    if (showedonecircle != TRUE) {
    
    [pressHoldGesture runAction:[CCActionMoveTo actionWithDuration:.5 position:ccp(physicsNode.contentSizeInPoints.width / 2.5,physicsNode.contentSizeInPoints.height / 1.6)]];
    
    [nothingtapGesture runAction:[CCActionMoveTo actionWithDuration:.5 position:ccp(physicsNode.contentSizeInPoints.width / 2.5,physicsNode.contentSizeInPoints.height / 1.6)]];
    
    [thecurrentcircle runAction:[CCActionMoveTo actionWithDuration:.5 position:ccp(physicsNode.contentSizeInPoints.width / 2.5,physicsNode.contentSizeInPoints.height / 1.6)]];
        
    }else{
        
        [pressHoldGesture runAction:[CCActionMoveTo actionWithDuration:.5 position:ccp(physicsNode.contentSizeInPoints.width / 2,physicsNode.contentSizeInPoints.height / 1.6)]];
        
        [nothingtapGesture runAction:[CCActionMoveTo actionWithDuration:.5 position:ccp(physicsNode.contentSizeInPoints.width / 2,physicsNode.contentSizeInPoints.height / 1.6)]];
        
        [thecurrentcircle runAction:[CCActionMoveTo actionWithDuration:.5 position:ccp(physicsNode.contentSizeInPoints.width / 2,physicsNode.contentSizeInPoints.height / 1.6)]];
        
    }
    
    NSArray *locations = [NSArray arrayWithObjects:originalXlocation,originalYlocation, thecurrentcircle,nil];
    
    [self performSelector:@selector(tutorialapplyimpulse:) withObject:locations afterDelay:0.5];
    
}

-(void)tutorialapplyimpulse: (NSArray*)originallocation{
    
    pressHoldGesture.visible = FALSE;
    nothingtapGesture.visible = TRUE;
    
    float xlocation = [originallocation[0] floatValue];
    float ylocation = [originallocation[1] floatValue];
    CCSprite *thecurrentcircle = originallocation[2];
    
    calculatedImpulseLocation.x = xlocation - pressHoldGesture.positionInPoints.x;
    calculatedImpulseLocation.y = ylocation - pressHoldGesture.positionInPoints.y;
    
    calculatedImpulseLocation.x = -calculatedImpulseLocation.x * 100;
    calculatedImpulseLocation.y = -calculatedImpulseLocation.y * 100;
    
    [thecurrentcircle.physicsBody applyImpulse:calculatedImpulseLocation];
    
    if (showedonecircle == TRUE) {
        
        pressHoldGesture.visible = FALSE;
        nothingtapGesture.visible = FALSE;
        singleTapGesture.visible = FALSE;
        pressHoldGesture.positionInPoints = ccp(200.0, 15);
        singleTapGesture.positionInPoints = ccp(200.0, 15);
        nothingtapGesture.positionInPoints = ccp(200.0, 15);
        
        paused = FALSE;
        
        thumbUpGesture.opacity = 1;
        
        thumbUpGesture.visible = TRUE;
        
        thumbUpGesture.position = ccp(0.5, -0.5);
        
        id bouncein = [CCActionMoveTo actionWithDuration:1 position:ccp(0.5, 0.6)];
        
        id reposition = [CCActionMoveTo actionWithDuration:.25 position:ccp(0.5, 0.5)];
        
        id fadeout = [CCActionFadeOut actionWithDuration:1.5];
        
        id sequence = [CCActionSequence actions:bouncein,reposition, fadeout,nil];

        circlesHolder.userInteractionEnabled = TRUE;
        
        [thumbUpGesture runAction:sequence];
        
        [self performSelector:@selector(spawncircles) withObject:nil afterDelay:4];
    
        firsttime = FALSE;
        
    }else if(showedonecircle != TRUE){
    showedonecircle = TRUE;
        [self starttutorial];
    }
}

-(void)spawncircles{
    
    if (paused != TRUE) {
    
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
    
    [self performSelector:@selector(spawncircles) withObject:nil afterDelay:self.spawnRate];
        
    }
}

-(void)spawnbluecircles{
    
    thecircleBlue = (circleBlue*)[CCBReader load:@"circleBlue"];
    
    float random = arc4random() % 20;
    
    random = random + 7;
    
    random = random / 10.00f + 1;
    
    thecircleBlue.positionInPoints = ccp(physicsNode.contentSizeInPoints.width * 1.5, physicsNode.contentSizeInPoints.height / random);
    
    [circlesHolder addChild:thecircleBlue];
    
    [thecircleBlue.physicsBody setSleeping:FALSE];
}
-(void)spawngreencircles{
    
    thecircleGreen = (circleGreen*)[CCBReader load:@"circleGreen"];
    
    float random = arc4random() % 20;
    
    random = random + 7;
    
    random = random / 10.00f + 1;
    
    thecircleGreen.positionInPoints = ccp(physicsNode.contentSizeInPoints.width * 1.5, physicsNode.contentSizeInPoints.height / random);
    
    [circlesHolder addChild:thecircleGreen];
    
    [thecircleGreen.physicsBody setSleeping:FALSE];
}
-(void)spawnorangecircles{
    
    thecircleOrange = (circleOrange*)[CCBReader load:@"circleOrange"];
    
    float random = arc4random() % 20;
    
    random = random + 7;
    
    random = random / 10.00f + 1;
    
    thecircleOrange.positionInPoints = ccp(physicsNode.contentSizeInPoints.width * 1.5, physicsNode.contentSizeInPoints.height / random);
    
    [circlesHolder addChild:thecircleOrange];
    
    [thecircleOrange.physicsBody setSleeping:FALSE];
}

-(void)removefake:(CCSprite *)fake{
        // load particle effect
        CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"correctParticles"];
        // make the particle effect clean itself up, once it is completed
        explosion.autoRemoveOnFinish = TRUE;
        // place the particle effect on the seals position
        explosion.position = fake.position;
        // add the particle effect to the same node the seal is on
        [fake.parent addChild:explosion];
        
        // finally, remove the destroyed seal
        [fake removeFromParent];
}

// COLLISIONS WITH BLUE CIRCLE

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair touchedCircleBlue:(CCSprite *)touchedCircleBlue shotAtBlue:(CCSprite *)shotAtBlue {
    
    CCSprite *currentfake = [CCSprite spriteWithImageNamed:@"Circle3Fake.png"];
    
    [circlesHolder addChild:currentfake];
    
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
    
    return TRUE;
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair touchedCircleBlue:(CCSprite *)touchedCircleBlue shotAtOrange:(CCSprite *)shotAtOrange {
    
    return TRUE;
}

// COLLISIONS WITH GREEN CIRCLE

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair touchedCircleGreen:(CCSprite *)touchedCircleGreen shotAtBlue:(CCSprite *)shotAtBlue {
    
    return TRUE;
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair touchedCircleGreen:(CCSprite *)touchedCircleGreen shotAtGreen:(CCSprite *)shotAtGreen {
    
    CCSprite *currentfake = [CCSprite spriteWithImageNamed:@"Circle2Fake.png"];
    
    [circlesHolder addChild:currentfake];
    
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
    
    return TRUE;
}

// COLLISIONS WITH ORANGE CIRCLE

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair touchedCircleOrange:(CCSprite *)touchedCircleOrange shotAtBlue:(CCSprite *)shotAtBlue {
    
    return TRUE;
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair touchedCircleOrange:(CCSprite *)touchedCircleOrange shotAtGreen:(CCSprite *)shotAtGreen {
    
    return TRUE;
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair touchedCircleOrange:(CCSprite *)touchedCircleOrange shotAtOrange:(CCSprite *)shotAtOrange {
    
    CCSprite *currentfake = [CCSprite spriteWithImageNamed:@"Circle1Fake.png"];
    
    [circlesHolder addChild:currentfake];
    
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
    
    [self losegame];

    return TRUE;
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair touchedCircleBlue:(CCSprite *)touchedCircleBlue offbounds:(CCNodeColor *)offbounds {
    
    touchedCircleBlue.userInteractionEnabled = FALSE;
    
    [touchedCircleBlue removeFromParent];
    
    [self losegame];
    
    return TRUE;
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair touchedCircleGreen:(CCSprite *)touchedCircleGreen offbounds:(CCNodeColor *)offbounds {
    
    touchedCircleGreen.userInteractionEnabled = FALSE;
    
    [touchedCircleGreen removeFromParent];
    
    [self losegame];
    
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

# pragma mark - iAd code

-(id)init
{
    if( (self= [super init]) )
    {
        // On iOS 6 ADBannerView introduces a new initializer, use it when available.
        if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)]) {
            _adView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
            
        } else {
            _adView = [[ADBannerView alloc] init];
        }
        
        // GETS THE HEIGHT OF THE DEVICE
        
        float screenBounds = [UIScreen mainScreen].bounds.size.height;

        float tempint = screenBounds;
        
        CGRect adFrame = _adView.frame;
        adFrame.origin.y = tempint - _adView.frame.size.height;
        adFrame.origin.x = self.contentSizeInPoints.width / 2;
        _adView.frame = adFrame;
        
        // MAKES THE BANNER GO TO THE BOTTOM OF THE SCREEN
        
        _adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
        _adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
        [[[CCDirector sharedDirector]view]addSubview:_adView];
        [_adView setBackgroundColor:[UIColor clearColor]];
        [[[CCDirector sharedDirector]view]addSubview:_adView];
        
        _adView.delegate = self;
        
    }
    [self layoutAnimated:YES];
    return self;
}


- (void)layoutAnimated:(BOOL)animated
{
    // As of iOS 6.0, the banner will automatically resize itself based on its width.
    // To support iOS 5.0 however, we continue to set the currentContentSizeIdentifier appropriately.
    CGRect contentFrame = [CCDirector sharedDirector].view.bounds;

        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    
    CGRect bannerFrame = _bannerView.frame;
    if (_bannerView.bannerLoaded) {
        contentFrame.size.height -= _bannerView.frame.size.height;
        bannerFrame.origin.y = contentFrame.size.height;
    } else {
        bannerFrame.origin.y = contentFrame.size.height;
    }
    
    [UIView animateWithDuration:animated ? 0.25 : 0.0 animations:^{
        _bannerView.frame = bannerFrame;
    }];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    [self layoutAnimated:YES];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    [self layoutAnimated:YES];
}

@end
