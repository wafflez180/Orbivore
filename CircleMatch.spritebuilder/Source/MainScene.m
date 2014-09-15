//
//  MainScene.m
//  CircleMatch
//
//  Created by Arthur Araujo
//
//

#import "MainScene.h"
#import "circleBlue.h"
#import "circleGreen.h"
#import "circleOrange.h"
#import "ABGameKitHelper.h"
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
    BOOL showedonecircle;
    BOOL lostgame;
    BOOL tutorial;
    CCNodeColor *mainNodePopup;
    CCButton *startGameButton;
    CCSprite *circlesymbol;
    CCNode *circlesHolder;
    CCSprite *pressHoldGesture;
    CCSprite *singleTapGesture;
    CCSprite *nothingtapGesture;
    CCSprite *thumbUpGesture;
    CCLabelTTF *tutorialLabel;
    CCLabelTTF *tutorialLabel2;
    CCLabelTTF *YourReady;
    CCNode *tutorialNode;
    CCLabelTTF *bestscoreLabel;
    CCLabelTTF *highscoreLabel;
    ADBannerView *_bannerView;
    CCButton *leaderboardsButton;
    CCButton *optionsButton;
    CCNode *highscoreContainer;
    CCNode *bestscoreContainer;
    CCSprite *leaderboardnumbers;
    CCNodeColor *scoresContainer;
    CCLabelTTF *firstLoginLabel;
    int howmanytimeslost;
    CCNodeColor *firstLoginContainer;
    bool spawning;
}

-(void)didLoadFromCCB{
    
    NSString *rank = @"0";
    NSDate *lastRead    = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:rank];
    if (lastRead == nil)     // App first run: set up user defaults.
    {
        NSDictionary *appDefaults  = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], rank, nil];
        
        // do any other initialization you want to do here - e.g. the starting default values.
        // [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"should_play_sounds"];
        
        [MGWU setObject:[NSNumber numberWithInt:0] forKey:@"bestscore"];
        [MGWU setObject:[NSNumber numberWithBool:YES] forKey:@"tutorial"];
        
        // sync the defaults to disk
        [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:rank];
    
    paused = TRUE;
    self.userInteractionEnabled = TRUE;
    
    goalBlue.physicsBody.collisionType = @"shotAtBlue";
    goalGreen.physicsBody.collisionType = @"shotAtGreen";
    goalOrange.physicsBody.collisionType = @"shotAtOrange";
    
    physicsNode.collisionDelegate = self;
    
    score = 0;
    howmanytimeslost = 0;
    
    tutorial = FALSE;
    lostgame = FALSE;
    
    NSNumber *tempint = [MGWU objectForKey:@"bestscore"];
    
    bestscoreLabel.visible = TRUE;
    bestscoreLabel.string = [NSString stringWithFormat:@"%@", tempint];
    
    highscoreLabel.visible = FALSE;
    scoresContainer.visible = FALSE;
    bestscoreContainer.visible = FALSE;
    bestscoreLabel.visible = FALSE;
    
    thumbUpGesture.opacity = 0;
    
    tutorialNode.visible = FALSE;
    thumbUpGesture.visible = FALSE;
    nothingtapGesture.visible = FALSE;
    singleTapGesture.visible = FALSE;
    pressHoldGesture.visible = FALSE;
    tutorialLabel.visible = FALSE;
    tutorialLabel2.visible = FALSE;
    
    spawning = FALSE;
    
    [ABGameKitHelper sharedHelper];
    
    highscoreContainer.visible = false;
    bestscoreContainer.position = ccp(0.50, bestscoreContainer.position.y);
    }

-(void)optionsPressed{
    CCScene *options = [CCBReader loadAsScene:@"options"];
    [[CCDirector sharedDirector]replaceScene:options];
}

-(void)leaderboardsPressed{
    
    [[ABGameKitHelper sharedHelper] showLeaderboard:@"01"];
}

-(void)update:(CCTime)delta{
    
    if (circlesymbol.opacity == 0) {
        scoreLabel.visible = TRUE;
    }else{
        scoreLabel.visible = FALSE;
    }
    
    if ( paused != TRUE) {
        if (score < 10 && score >= 0) {
            
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

    scoreLabel.string = [NSString stringWithFormat:@"%i", score];
    
    BOOL tutorialbool = [[MGWU objectForKey:@"tutorial"] boolValue];
    
    if (tutorialbool == TRUE && startGameButton.enabled == FALSE) {
        
        tutorialLabel.visible = TRUE;
        tutorialLabel2.visible = TRUE;
    }else{
        tutorialLabel.visible = FALSE;
        tutorialLabel2.visible = FALSE;
    }
    
    if (thumbUpGesture.opacity == 0) {
        YourReady.visible = FALSE;
    }else{
        YourReady.visible = TRUE;
    }
}

-(void)startgame{
        
    score = 0;
    
    self.spawnRate = 1;
    
    [circlesHolder removeAllChildren];
    
    BOOL tutorialbool = [[MGWU objectForKey:@"tutorial"] boolValue];
    
    float fadeouttime = 0.5;
    
    for(int i = 0; mainNodePopup.children.count > i; i++){
        
        [mainNodePopup.children[i] runAction:[CCActionFadeOut actionWithDuration:fadeouttime]];
        
    }
    for(int i = 0; bestscoreContainer.children.count > i; i++){
        
        [bestscoreContainer.children[i] runAction:[CCActionFadeOut actionWithDuration:fadeouttime]];
        
    }
    for(int i = 0; highscoreContainer.children.count > i; i++){
        
        [highscoreContainer.children[i] runAction:[CCActionFadeOut actionWithDuration:fadeouttime]];
        
    }
    [optionsButton setCascadeOpacityEnabled:YES];
    [leaderboardsButton setCascadeOpacityEnabled:YES];
    [startGameButton setCascadeOpacityEnabled:YES];
    
    [optionsButton runAction:[CCActionFadeOut actionWithDuration:fadeouttime]];
    [leaderboardsButton runAction:[CCActionFadeOut actionWithDuration:fadeouttime]];
    [leaderboardnumbers runAction:[CCActionFadeOut actionWithDuration:fadeouttime]];
    [startGameButton runAction:[CCActionFadeOut actionWithDuration:fadeouttime]];
    
    if (howmanytimeslost >= 1) {
        firstLoginLabel.visible = FALSE;
        firstLoginContainer.visible = FALSE;
    }else{
        [firstLoginLabel runAction:[CCActionFadeOut actionWithDuration:fadeouttime]];
        [firstLoginContainer runAction:[CCActionFadeOut actionWithDuration:fadeouttime]];
    }
    
    [scoresContainer runAction:[CCActionFadeTo actionWithDuration:fadeouttime opacity:0.0]];

    
    if (tutorialbool != TRUE) {
    paused = FALSE;
    startGameButton.enabled = FALSE;
        leaderboardsButton.enabled = FALSE;
        optionsButton.enabled = FALSE;
        
    [self performSelector:@selector(startthespawning) withObject:nil afterDelay:1];

    circlesHolder.userInteractionEnabled = TRUE;
    tutorialNode.visible = FALSE;

    }else{
        startGameButton.enabled = FALSE;
        leaderboardsButton.enabled = FALSE;
        optionsButton.enabled = FALSE;
        
        [self starttutorial];
    }
}

-(void)losegame{
    
    if (paused == FALSE) {
        
        howmanytimeslost++;
        
        paused = TRUE;
        
        NSNumber *thehighscore = [MGWU objectForKey:@"bestscore"];
        
        int highscore = [thehighscore intValue];
        
        NSLog(@"Score: %i", score);
        
        if (highscore < score) {
            highscore = score;
            
            NSLog(@"New Highscore: %i", highscore);
            
            [MGWU setObject:[NSNumber numberWithInt:highscore] forKey:@"bestscore"];
            
            NSNumber *tempint = [MGWU objectForKey:@"bestscore"];
            
            bestscoreLabel.visible = TRUE;
            bestscoreLabel.string = [NSString stringWithFormat:@"%@", tempint];
            
            [[ABGameKitHelper sharedHelper] reportScore:highscore forLeaderboard:@"01"];
        }
        spawning = FALSE;
        highscoreLabel.visible = TRUE;
        bestscoreContainer.visible = TRUE;
        bestscoreLabel.visible = TRUE;
        scoresContainer.visible = TRUE;
        highscoreLabel.string = [NSString stringWithFormat:@"%i", score];
        
        highscoreContainer.visible = TRUE;
        score = 0;
        [circlesHolder removeAllChildren];
        circlesHolder.userInteractionEnabled = FALSE;
        startGameButton.enabled = TRUE;
        startGameButton.visible = TRUE;
        leaderboardsButton.enabled = TRUE;
        leaderboardsButton.visible = TRUE;
        optionsButton.enabled = TRUE;
        optionsButton.visible = TRUE;
        lostgame = TRUE;
        float fadeintime = 0.5;
        
        for(int i = 0; mainNodePopup.children.count > i; i++){
            
            [mainNodePopup.children[i] runAction:[CCActionFadeIn actionWithDuration:fadeintime]];
            
        }
        for(int i = 0; bestscoreContainer.children.count > i; i++){
            
            [bestscoreContainer.children[i] runAction:[CCActionFadeIn actionWithDuration:fadeintime]];
            
        }
        for(int i = 0; highscoreContainer.children.count > i; i++){
            
            [highscoreContainer.children[i] runAction:[CCActionFadeIn actionWithDuration:fadeintime]];
            
        }
        [optionsButton setCascadeOpacityEnabled:YES];
        [leaderboardsButton setCascadeOpacityEnabled:YES];
        [startGameButton setCascadeOpacityEnabled:YES];
        
        [optionsButton runAction:[CCActionFadeIn actionWithDuration:fadeintime]];
        [leaderboardsButton runAction:[CCActionFadeIn actionWithDuration:fadeintime]];
        [leaderboardnumbers runAction:[CCActionFadeIn actionWithDuration:fadeintime]];
        [startGameButton runAction:[CCActionFadeIn actionWithDuration:fadeintime]];
        
        [scoresContainer runAction:[CCActionFadeTo actionWithDuration:fadeintime opacity:1]];
        
    }
}

-(void)starttutorial{
    
    tutorial = TRUE;
    
    tutorialNode.visible = TRUE;
    
    tutorialLabel.visible = TRUE;
    tutorialLabel2.visible = TRUE;
    
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
        tutorial = FALSE;

        thumbUpGesture.opacity = 0.01;
        
        thumbUpGesture.visible = TRUE;
        
        thumbUpGesture.position = ccp(0.5, -0.5);
        
        id bouncein = [CCActionMoveTo actionWithDuration:1 position:ccp(0.5, 0.6)];
        
        id reposition = [CCActionMoveTo actionWithDuration:.25 position:ccp(0.5, 0.5)];
        
        id fadeout = [CCActionFadeTo actionWithDuration:1.5 opacity:0];
        
        id sequence = [CCActionSequence actions:bouncein,reposition, fadeout,nil];

        circlesHolder.userInteractionEnabled = TRUE;
        
        [thumbUpGesture runAction:sequence];
        
        [self performSelector:@selector(startthespawning) withObject:nil afterDelay:4];
        
        [MGWU setObject:[NSNumber numberWithBool:NO] forKey:@"tutorial"];
        
    }else if(showedonecircle != TRUE){
    showedonecircle = TRUE;
        [self starttutorial];
    }
}

-(void)startthespawning{
    if (!spawning) {
        spawning = TRUE;
        [self performSelector:@selector(spawncircles) withObject:nil afterDelay:0];
    }
}

-(void)spawncircles{
    
    if (paused != TRUE && spawning) {
    
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
        explosion.position= fake.position;
    
        explosion.positionInPoints = ccp(explosion.positionInPoints.x, explosion.positionInPoints.y + (fake.positionInPoints.y / 15));
    
        // add the particle effect to the same node the seal is on
        explosion.zOrder = 500;
    
        [fake.parent addChild:explosion];
        
        // finally, remove the destroyed seal
        [fake removeFromParent];
}
-(void)removefakenoexp:(CCSprite *)fake{
    [fake removeFromParent];
}
-(void)addclosed: (NSString *)closedPic{
    if ([closedPic isEqualToString:@"Blue"]) {
        CCSprite *theclosedpic = [CCSprite spriteWithImageNamed:@"Assets/birdblueclosed.png"];
        
        [physicsNode addChild:theclosedpic];
        
        theclosedpic.position = goalBlue.positionInPoints;
        
        theclosedpic.scale = 0.80f;
        
        [self performSelector:@selector(removefakenoexp:) withObject:theclosedpic afterDelay:.30];
    }
    if ([closedPic isEqualToString:@"Green"]) {
        CCSprite *theclosedpic = [CCSprite spriteWithImageNamed:@"Assets/birdgreenclosed.png"];
        
        [physicsNode addChild:theclosedpic];
        
        theclosedpic.position = goalGreen.positionInPoints;
        
        theclosedpic.scale = 0.80f;
        
        [self performSelector:@selector(removefakenoexp:) withObject:theclosedpic afterDelay:.30];
    }
    if ([closedPic isEqualToString:@"Orange"]) {
        CCSprite *theclosedpic = [CCSprite spriteWithImageNamed:@"Assets/birdorangeclosed.png"];
        
        [physicsNode addChild:theclosedpic];
        
        theclosedpic.position = goalOrange.positionInPoints;
        
        theclosedpic.scale = 0.80f;
        
        [self performSelector:@selector(removefakenoexp:) withObject:theclosedpic afterDelay:.30];
    }
}

// COLLISIONS WITH BLUE CIRCLE

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair touchedCircleBlue:(CCSprite *)touchedCircleBlue shotAtBlue:(CCSprite *)shotAtBlue {
    
    CCSprite *currentfake = [CCSprite spriteWithImageNamed:@"Assets/Circle3Fake.png"];
    
    [circlesHolder addChild:currentfake];
    
    currentfake.position = touchedCircleBlue.position;
    
    currentfake.scale = 2;
    [currentfake runAction:[CCActionScaleTo actionWithDuration:.10 scale:.5]];
    
    [currentfake runAction:[CCActionMoveTo actionWithDuration:.20 position:ccp(goalBlue.positionInPoints.x, goalBlue.positionInPoints.y - (goalBlue.contentSizeInPoints.height / 5.5))]];
    [currentfake runAction:[CCActionRotateBy actionWithDuration:.20 angle:10080]];
    
    [self performSelector:@selector(removefake:) withObject:currentfake afterDelay:.20];
    
    NSString *addclosed = @"Blue";
    
    [self performSelector:@selector(addclosed:) withObject:addclosed afterDelay:.20];

    
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
    
    CCSprite *currentfake = [CCSprite spriteWithImageNamed:@"Assets/Circle2Fake.png"];
    
    [circlesHolder addChild:currentfake];
    
    currentfake.position = touchedCircleGreen.position;
    
    currentfake.scale = 2;
    [currentfake runAction:[CCActionScaleTo actionWithDuration:.10 scale:.5]];
    
    [currentfake runAction:[CCActionMoveTo actionWithDuration:.20 position:ccp(goalGreen.positionInPoints.x, goalGreen.positionInPoints.y - (goalGreen.contentSizeInPoints.height / 5.5))]];
    [currentfake runAction:[CCActionRotateBy actionWithDuration:.20 angle:10080]];
    
    [self performSelector:@selector(removefake:) withObject:currentfake afterDelay:.20];
    
    NSString *addclosed = @"Green";
    
    [self performSelector:@selector(addclosed:) withObject:addclosed afterDelay:.20];
    
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
    
    CCSprite *currentfake = [CCSprite spriteWithImageNamed:@"Assets/Circle1Fake.png"];
    
    [circlesHolder addChild:currentfake];
    
    currentfake.position = touchedCircleOrange.position;
    
    currentfake.scale = 2;
    [currentfake runAction:[CCActionScaleTo actionWithDuration:.10 scale:.5]];
    
    [currentfake runAction:[CCActionMoveTo actionWithDuration:.20 position:ccp(goalOrange.positionInPoints.x, goalOrange.positionInPoints.y - (goalOrange.contentSizeInPoints.height / 5.5))]];
    [currentfake runAction:[CCActionRotateBy actionWithDuration:.20 angle:10080]];
    
    [self performSelector:@selector(removefake:) withObject:currentfake afterDelay:.20];
    
    NSString *addclosed = @"Orange";
    
    [self performSelector:@selector(addclosed:) withObject:addclosed afterDelay:.20];
    
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
