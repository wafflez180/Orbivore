//
//  birdblueblink.m
//  CircleMatch
//
//  Created by Arthur Araujo on 9/13/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "birdblueblink.h"

@implementation birdblueblink
    
-(void)didLoadFromCCB{
    
    float randomspawntime = arc4random() % 20;
    
    [self performSelector:@selector(closeeyes) withObject:nil afterDelay:randomspawntime];
}

-(void)openeyes:(CCSprite *)fake{
    [fake removeFromParent];
    
    
    float randomspawntime = arc4random() % 20;
    
    [self performSelector:@selector(closeeyes) withObject:nil afterDelay:randomspawntime];
}
-(void)closeeyes{
        CCSprite *blinkpic = [CCSprite spriteWithImageNamed:@"Assets/birdblueblink.png"];
        
        [self addChild:blinkpic];
        
        blinkpic.positionInPoints = ccp(self.contentSizeInPoints.width /2, self.contentSizeInPoints.height /2);
        
        blinkpic.scale = 1;
    
        [self performSelector:@selector(openeyes:) withObject:blinkpic afterDelay:0.2];
}

@end
