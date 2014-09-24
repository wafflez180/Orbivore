//
//  MainScene.m
//  CircleMatch
//
//  Created by Arthur Araujo
//
//

#import "CCNode.h"
#import "GADBannerView.h"

#ifndef APPORTABLE
#include <iAd/iAd.h>
#import "ABGameKitHelper.h"
#endif

@interface MainScene : CCNode <CCPhysicsCollisionDelegate, GADBannerViewDelegate

#ifndef APPORTABLE
, ADBannerViewDelegate
#endif
>

@property (nonatomic) float spawnRate;

#ifndef APPORTABLE
@property ADBannerView* adView;
#endif

@end
