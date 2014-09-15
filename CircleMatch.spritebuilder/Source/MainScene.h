//
//  MainScene.m
//  CircleMatch
//
//  Created by Arthur Araujo
//
//

#import "CCNode.h"
#import "ABGameKitHelper.h"
#include <iAd/iAd.h>

@interface MainScene : CCNode <CCPhysicsCollisionDelegate, ADBannerViewDelegate>

@property (nonatomic) float spawnRate;

@property ADBannerView* adView;

@end
