//
//  MainScene.m
//  CircleMatch
//
//  Created by Arthur Araujo
//
//

#import "CCNode.h"
#ifndef APPORTABLE
#include <iAd/iAd.h>
#import "ABGameKitHelper.h"
#else
#import "GADBannerView.h"
#endif

@interface MainScene : CCNode <CCPhysicsCollisionDelegate,
#ifndef APPORTABLE
ADBannerViewDelegate>
#else
GADBannerViewDelegate>
#endif

@property (nonatomic) float spawnRate;

#ifndef APPORTABLE
@property ADBannerView* adView;
#else
@property GADBannerView* googleadView;
#endif

@end
