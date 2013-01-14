//
//  BRFullScreenAd.m
//  Twins4Kids
//
//  Created by René Bigot on 06/11/12.
//  Copyright (c) 2012 René Bigot. All rights reserved.
//

#import "BRFullScreenAd.h"

@implementation BRFullScreenAd

static BRFullScreenAd *_sharedFullScreenAd = nil;
static UIViewController *_topMostController = nil;
static Chartboost *_sharedChartboost = nil;
static const NSInteger kAnimationDuration = .5;

+ (void)startRevMobSessionWithAppID:(NSString *)revMobAppId {
    [RevMobAds startSessionWithAppID:revMobAppId];
}

+ (void)startChartboostSessionWithAppId:(NSString *)chartboostAppId
                        andAppSignature:(NSString *)chartboostAppSignature {
    _sharedChartboost = [Chartboost sharedChartboost];
    _sharedChartboost.appId = chartboostAppId;
    _sharedChartboost.appSignature = chartboostAppSignature;
    [_sharedChartboost startSession];
    //Cache instertitial -> no delay to show ad
    [_sharedChartboost cacheInterstitial];
}

+ (void)presentAd {
    BOOL showChartboost = [[NSUserDefaults standardUserDefaults] boolForKey:@"showChartboostAd"];
    
    if (_sharedFullScreenAd.loadingView) {
        [_sharedFullScreenAd.loadingView removeFromSuperview];
    }

    //If no cached chartboost ad, show revmob
    if (showChartboost && [_sharedChartboost hasCachedInterstitial]) {
        [_sharedChartboost showInterstitial];
        [_sharedChartboost cacheInterstitial];
    } else {
        if (_sharedFullScreenAd) {
            [_sharedFullScreenAd.view removeFromSuperview];
            _sharedFullScreenAd = nil;
        }
        
        _sharedFullScreenAd = [[BRFullScreenAd alloc] init];
        
        [_sharedFullScreenAd.view setHidden:YES];
        _topMostController = [BRFullScreenAd topMostController];
        [_sharedFullScreenAd.view setFrame:_topMostController.view.frame];
        
        [_topMostController.view addSubview:_sharedFullScreenAd.view];

        //Need to present a modal view controller to fire _sharedFullScreenAd viewDidAppear... Don't know why...
        UIViewController *unusedVC = [[UIViewController alloc] init];
        if ([_topMostController respondsToSelector:@selector(presentViewController:animated:completion:)]) {
            [_topMostController presentViewController:unusedVC animated:NO completion:NULL];
        } else {
            [_topMostController presentModalViewController:unusedVC animated:NO];
        }
        [unusedVC dismissModalViewControllerAnimated:NO];
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:!showChartboost forKey:@"showChartboostAd"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (UIViewController*)topMostController {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    NSLog(@"Top most ViewController : %@", topController);

    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
        NSLog(@"Top most ViewController : %@", topController);
    }
    
    return topController;
}


#pragma mark - BRFullScreenAd methods

- (void)createAdContent {
    UIWindow* mainWindow = [UIApplication sharedApplication].keyWindow;
    if (!mainWindow)
        mainWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
    
    UIView *mainWindowView = [[mainWindow subviews] objectAtIndex:0];
    [self.view setFrame:mainWindowView.bounds];
    
    //Can't do a performSelector:withObject:afterDelay since it needs to be on main thread
    [NSThread sleepForTimeInterval:0.001];
    [self createAdContentSelector];
}

- (void)createAdContentSelector {
    static NSString *adImageName = nil;
    
    if (_adContent) {
        [_adContent removeFromSuperview];
    } else {
        adImageName = [NSString stringWithFormat:@"adSplashBackground_%d.png", arc4random_uniform(4)+1];
    }
    
    [self.view setBackgroundColor:[UIColor colorWithWhite:0. alpha:0.5]];
    [self.view setOpaque:NO];
    
    CGSize adSize = CGSizeZero;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        adSize = CGSizeMake(380, 273);
    } else {
        adSize = CGSizeMake(273, 380);
    }
    
    _adContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, adSize.width, adSize.height)];
    [_adContent setCenter:self.view.center];
    [_adContent setAutoresizingMask:UIViewAutoresizingNone];
    
    [self.view addSubview:_adContent];
    
    UIImageView *adSplashBorder = [[UIImageView alloc] initWithImage:
                                   [[UIImage imageNamed:@"adSplashBorder.png"]
                                    stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
    [adSplashBorder setFrame:CGRectMake(0, 15, _adContent.bounds.size.width - 15, _adContent.bounds.size.height - 15)];
    
    UIImageView *adBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:adImageName]];
    [adBackground setContentMode:UIViewContentModeScaleAspectFill];
    [adBackground setClipsToBounds:YES];
    adBackground.layer.cornerRadius = 20;
    adBackground.frame = adSplashBorder.frame;
    
    [_adContent addSubview:adBackground];
    [_adContent addSubview:adSplashBorder];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                   35,
                                                                   adSplashBorder.frame.size.width - 40,
                                                                   adSplashBorder.frame.size.height / 2)];
    [textLabel setText:@"DOWNLOAD\nA FREE\nGAME!"];
    [textLabel setFont:[UIFont systemFontOfSize:37]];
    [textLabel setNumberOfLines:3];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [textLabel setTextColor:[UIColor whiteColor]];
    [textLabel setShadowOffset:CGSizeMake(1, 1)];
    [textLabel setShadowColor:[UIColor blackColor]];
    [_adContent addSubview:textLabel];
    
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [okButton setFrame:CGRectMake(20,
                                  textLabel.frame.size.height + textLabel.frame.origin.y + 20,
                                  textLabel.frame.size.width,
                                  adSplashBorder.frame.size.height - (textLabel.frame.size.height + textLabel.frame.origin.y + 40))];
    [okButton setBackgroundImage:[[UIImage imageNamed:@"adOkButton.png"]
                                  stretchableImageWithLeftCapWidth:11 topCapHeight:32]
                        forState:UIControlStateNormal];
    [okButton setTitle:@"OK" forState:UIControlStateNormal];
    [okButton.titleLabel setShadowColor:[UIColor blackColor]];
    [okButton.titleLabel setShadowOffset:CGSizeMake(0, -2)];
    [okButton.titleLabel setFont:[UIFont systemFontOfSize:37]];
    [_adContent addSubview:okButton];
    
    UIButton *adButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [adButton setFrame:adSplashBorder.frame];
    [adButton addTarget:self action:@selector(openAdLink:) forControlEvents:UIControlEventTouchUpInside];
    [_adContent addSubview:adButton];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"adCloseButton.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeAd:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setFrame:CGRectMake(_adContent.frame.size.width - 40, 0, 40, 40)];
    [_adContent addSubview:closeButton];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(createAdContent)
                                                 name:@"UIDeviceOrientationDidChangeNotification"
                                               object:nil];
    [self createAdContent];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.view setHidden:NO];
    CALayer *adContentLayer = self.adContent.layer;
    
    CATransform3D layerTransform = CATransform3DIdentity;
    layerTransform.m34 = 1.0 / 1000;
    
    adContentLayer.transform = layerTransform;
    
    CABasicAnimation *rotationY = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationY.duration = kAnimationDuration;
    rotationY.fromValue = [NSNumber numberWithFloat:M_PI_2];
    rotationY.toValue = [NSNumber numberWithFloat:0];
    [adContentLayer addAnimation:rotationY forKey:@"transform.rotation.y"];
    
    CABasicAnimation *translationX = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    translationX.duration = kAnimationDuration;
    translationX.fromValue = [NSNumber numberWithFloat:-adContentLayer.frame.size.width];
    translationX.toValue = [NSNumber numberWithFloat:0];
    [adContentLayer addAnimation:translationX forKey:@"transform.translation.x"];
    
    CABasicAnimation *translationZ = [CABasicAnimation animationWithKeyPath:@"transform.translation.z"];
    translationZ.duration = kAnimationDuration;
    translationZ.fromValue = [NSNumber numberWithFloat:adContentLayer.frame.size.width/2];
    translationZ.toValue = [NSNumber numberWithFloat:0];
    [adContentLayer addAnimation:translationZ forKey:@"transform.translation.z"];
}

- (void)showLoadingView {
    if (!self.loadingView) {
        self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [self.loadingView setCenter:CGPointMake(_topMostController.view.bounds.size.width / 2, _topMostController.view.bounds.size.height / 2)];
        [self.loadingView.layer setCornerRadius:15];
        [self.loadingView setOpaque:NO];
        [self.loadingView setBackgroundColor:[UIColor colorWithWhite:0 alpha:.8]];
        
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityIndicatorView setCenter:CGPointMake(self.loadingView.frame.size.width / 2, self.loadingView.frame.size.width / 2)];
        [activityIndicatorView startAnimating];
        [self.loadingView addSubview:activityIndicatorView];
    }
    [_topMostController.view addSubview:self.loadingView];
}

- (IBAction)openAdLink:(id)sender {
    [self showLoadingView];
    [[RevMobAds revMobAds] openAdLinkWithDelegate:self];
    
    [self closeAd:nil];
}

- (IBAction)closeAd:(id)sender {
    CALayer *adContentLayer = self.adContent.layer;
    
    CATransform3D layerTransform = CATransform3DIdentity;
    layerTransform.m34 = 1.0 / 500;
    adContentLayer.transform = layerTransform;
    
    CABasicAnimation *rotationY = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationY.duration = kAnimationDuration;
    rotationY.fromValue = [NSNumber numberWithFloat:0];
    rotationY.toValue = [NSNumber numberWithFloat:- M_PI_2];
    [adContentLayer addAnimation:rotationY forKey:@"transform.rotation.y"];
    
    CABasicAnimation *translationX = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    translationX.duration = kAnimationDuration;
    translationX.fromValue = [NSNumber numberWithFloat:0];
    translationX.toValue = [NSNumber numberWithFloat:adContentLayer.frame.size.width];
    [adContentLayer addAnimation:translationX forKey:@"transform.translation.x"];
    
    CABasicAnimation *translationZ = [CABasicAnimation animationWithKeyPath:@"transform.translation.z"];
    translationZ.duration = kAnimationDuration;
    translationZ.fromValue = [NSNumber numberWithFloat:0];
    translationZ.toValue = [NSNumber numberWithFloat:adContentLayer.frame.size.width/2];
    [adContentLayer addAnimation:translationZ forKey:@"transform.translation.z"];
    
    
    [self performSelector:@selector(hideAd) withObject:nil afterDelay:.25];
}

- (void)hideAd {
    [_adContent setHidden:YES];
    [self.view removeFromSuperview];
}

#pragma mark - UIView orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate {
    return [self shouldAutorotateToInterfaceOrientation:self.interfaceOrientation];
}

@end