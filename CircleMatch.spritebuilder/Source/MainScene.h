//
//  MainScene.m
//  CircleMatch
//
//  Created by Arthur Araujo
//
//

#import "CCNode.h"
#include <iAd/iAd.h>
#import "ABGameKitHelper.h"

@interface MainScene : CCNode <CCPhysicsCollisionDelegate, ADBannerViewDelegate>

@property (nonatomic) float spawnRate;

#ifndef APPORTABLE
@property ADBannerView* adView;
#endif

@end
