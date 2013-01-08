#Fullscreen ad handler for Chartboost and RevMob

BRFullScreenAd will allow you to easily present Chartboost and Revmob interstitial ads inside you application.

The Revmob ads are some custom interstitials. I don't use Revmob original one cause the close button is to small and users don't like to be redirect by error to the AppStore.

The Chartboost's one are provided by Chartboost without modification.

It's the same class I use in my apps.

#Screen shots

Chartboost ad  
![Chartboost](https://github.com/renebigot/BRFullScreenAd/raw/master/screenshot1.png)

Revmob custom interstitial in landscape  
![Revmob](https://github.com/renebigot/BRFullScreenAd/raw/master/screenshot2.png)

Revmob custom interstitial in portrait  
![Revmob](https://github.com/renebigot/BRFullScreenAd/raw/master/screenshot3.png)

#Compatibility

Needs iOS 5 or 6 (probably iOS 4.3 to). Compatible with all iDevices.

#Linked frameworks

Add the following frameworks and libs to your project :  
    * QuartzCore.framework  
    * AdSupport.framework (Optional)  
    * StoreKit.framework (Optional)  
    * SystemConfiguration.framework  
    * RevMobAds.framework  
    * libChartboost.a (add all *.h files from the Chartboost lib)

#Code

    //Init ads networks
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
        //BRFullscreenAd config : Must be called first
        [BRFullScreenAd startRevMobSessionWithAppID:@"REV_MOB_APP_ID"];
        [BRFullScreenAd startChartboostSessionWithAppId:@"CHARTBOOST_APP_ID"
                                        andAppSignature:@"CHARTBOOST_APP_SIGNATURE"];
        //End
    
        [...]
        
        return YES;
    }

    //Fire ad
    - (void)applicationDidBecomeActive:(UIApplication *)application
    {
        [BRFullScreenAd presentAd];
        
    }



#License

BSD License

Copyright (c) 2012-2013 René BIGOT

