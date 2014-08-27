//
//  MainScene.h
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "CCNode.h"
#include <iAd/iAd.h>

@interface MainScene : CCNode <CCPhysicsCollisionDelegate, ADBannerViewDelegate>

@property (nonatomic) float spawnRate;

@property ADBannerView* adView;

@end
