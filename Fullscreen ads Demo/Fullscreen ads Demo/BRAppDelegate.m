//
//  BRAppDelegate.m
//  Fullscreen ads Demo
//
//  Created by René Bigot on 15/11/12.
//  Copyright (c) 2012 René Bigot. All rights reserved.
//

#import "BRAppDelegate.h"
#import "BRViewController.h"

#import "BRFullScreenAd.h"

@implementation BRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //BRFullscreenAd config : Must be called first
    [BRFullScreenAd startRevMobSessionWithAppID:@"REV_MOB_APP_ID"];
    [BRFullScreenAd startChartboostSessionWithAppId:@"CHARTBOOST_APP_ID"
                                    andAppSignature:@"CHARTBOOST_APP_SIGNATURE"];
    //End
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[BRViewController alloc] initWithNibName:@"BRViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [BRFullScreenAd presentAd];
    
}

@end
