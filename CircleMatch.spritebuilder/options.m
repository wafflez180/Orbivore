//
//  options.m
//  CircleMatch
//
//  Created by Arthur Araujo on 8/29/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "options.h"

@implementation options

-(void)didLoadFromCCB{
}

-(void)backToMainscene{
    CCScene *Mainscene = [CCBReader loadAsScene:@"MainScene"];

    [[CCDirector sharedDirector]replaceScene:Mainscene];
}

-(void)playTutorialPressed{
    
    [MGWU setObject:[NSNumber numberWithBool:YES] forKey:@"tutorial"];
    
    CCScene *Mainscene = [CCBReader loadAsScene:@"MainScene"];
    
    [[CCDirector sharedDirector]replaceScene:Mainscene];
}

@end
