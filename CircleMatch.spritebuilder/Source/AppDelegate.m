/*
 * SpriteBuilder: http://www.spritebuilder.org
 *
 * Copyright (c) 2012 Zynga Inc.
 * Copyright (c) 2013 Apportable Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "cocos2d.h"
#import "GADBannerView.h"
#import "AppDelegate.h"
#import "GADBannerView.h"
#import "CCBuilderReader.h"
#ifndef APPORTABLE
#import <Crashlytics/Crashlytics.h>
#endif

@implementation AppController

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [MGWU loadMGWU:@"Family360"];
    
    [MGWU setAppiraterAppId:@"914284583" andAppName:@"Orbivore"];
    
    [MGWU setReminderMessage:@"Come back and play Orbivore!"];
    
    [MGWU dark];
#ifndef APPORTABLE
    [Crashlytics startWithAPIKey:@"b3f968f6cdf4372d174aad54e4647514c1888e83"];
#endif
    // Configure Cocos2d with the options set in SpriteBuilder
    NSString* configPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Published-iOS"]; // TODO: add support for Published-Android support
    configPath = [configPath stringByAppendingPathComponent:@"configCocos2d.plist"];
    
    NSMutableDictionary* cocos2dSetup = [NSMutableDictionary dictionaryWithContentsOfFile:configPath];
    
    // Note: this needs to happen before configureCCFileUtils is called, because we need apportable to correctly setup the screen scale factor.
#ifdef APPORTABLE
    if([cocos2dSetup[CCSetupScreenMode] isEqual:CCScreenModeFixed])
        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenAspectFitEmulationMode];
    else
        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenScaledAspectFitEmulationMode];
#endif
    
    // Configure CCFileUtils to work with SpriteBuilder
    [CCBReader configureCCFileUtils];
    
    [self setupCocos2dWithOptions:cocos2dSetup];
    
#ifndef APPORTABLE
// IOS ONLY
#else
    
    [self createAdmobAds];
    
#endif
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)tokenId {
    [MGWU registerForPush:tokenId];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [MGWU gotPush:userInfo];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error{
    [MGWU failedPush:error];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [MGWU gotLocalPush:notification];
}

- (CCScene*) startScene
{
    return [CCBReader loadAsScene:@"MainScene"];
}

-(void)createAdmobAds
{
    mBannerType = BANNER_TYPE;
    
    AppController *app =  (AppController*)[[UIApplication sharedApplication] delegate];
    // Create a view of the standard size at the bottom of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
    
    if(mBannerType <= kBanner_Portrait_Bottom)
        mBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    else
        mBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerLandscape];
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    mBannerView.adUnitID = @"ca-app-pub-2396206924319009/8591272379";
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    
    GADRequest *request = [GADRequest alloc];
    
    mBannerView.rootViewController = app.navController;
    [app.navController.view addSubview:mBannerView];
    
    // Initiate a generic request to load it with an ad.
    [mBannerView loadRequest:request];
    
    CGSize s = [[CCDirector sharedDirector] viewSize];
    
    CGRect frame = mBannerView.frame;
    
    off_x = 0.0f;
    on_x = 0.0f;
    
    switch (mBannerType)
    {
        case kBanner_Portrait_Top:
        {
            off_y = -frame.size.height;
            on_y = 0.0f;
        }
            break;
        case kBanner_Portrait_Bottom:
        {
            off_y = s.height;
            on_y = s.height-frame.size.height;
        }
            break;
        case kBanner_Landscape_Top:
        {
            off_y = -frame.size.height;
            on_y = 0.0f;
        }
            break;
        case kBanner_Landscape_Bottom:
        {
            off_y = s.height;
            on_y = s.height-frame.size.height;
        }
            break;
            
        default:
            break;
    }
    
    frame.origin.y = off_y;
    frame.origin.x = off_x;
    
    mBannerView.frame = frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    frame = mBannerView.frame;
    frame.origin.x = on_x;
    frame.origin.y = on_y;
    
    
    mBannerView.frame = frame;
    [UIView commitAnimations];
    
    [self showBannerView];
}


-(void)showBannerView
{
    if (mBannerView)
    {
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: UIViewAnimationCurveEaseOut
                         animations:^
         {
             CGRect frame = mBannerView.frame;
             frame.origin.y = on_y;
             frame.origin.x = on_x;
             
             mBannerView.frame = frame;
         }
                         completion:^(BOOL finished)
         {
         }];
    }
    
}


-(void)hideBannerView
{
    if (mBannerView)
    {
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: UIViewAnimationCurveEaseOut
                         animations:^
         {
             CGRect frame = mBannerView.frame;
             frame.origin.y = off_y;
             frame.origin.x = off_x;
         }
                         completion:^(BOOL finished)
         {
         }];
    }
    
}

-(void)dismissAdView
{
    if (mBannerView)
    {
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: UIViewAnimationCurveEaseOut
                         animations:^
         {
             CGRect frame = mBannerView.frame;
             frame.origin.y = off_y;
             frame.origin.x = off_x;
             mBannerView.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             [mBannerView setDelegate:nil];
             [mBannerView removeFromSuperview];
             mBannerView = nil;
             
         }];
    }
}
@end
