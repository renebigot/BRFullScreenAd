//
//  BRFullScreenAd.h
//  Twins4Kids
//
//  Created by René Bigot on 06/11/12.
//  Copyright (c) 2012 René Bigot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <RevMobAds/RevMobAds.h>
#import <RevMobAds/RevMobAdsDelegate.h>
#import "Chartboost.h"

@interface BRFullScreenAd : UIViewController <RevMobAdsDelegate> {
    IBOutlet UIImageView *_backgroundImage;
}

+ (void)presentAd;
+ (BRFullScreenAd *)sharedFullScreenAd;
+ (void)startRevMobSessionWithAppID:(NSString *)revmobAppId;
+ (void)startChartboostSessionWithAppId:(NSString *)chartboostAppId
                        andAppSignature:(NSString *)chartboostAppSignature;

- (IBAction)closeAd:(id)sender;
- (IBAction)openAdLink:(id)sender;

@property (nonatomic, strong) UIView *adContent;
@property (nonatomic, strong) UIView *loadingView;

@end