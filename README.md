#Fullscreen ad handler for Chartboost and RevMob

BRFullScreenAd will allow you to easily present Chartboost and Revmob interstitial ads inside you application.

The Revmob ads are some custom interstitials. I don't use Revmob original one cause the close button is to small and users don't like to be redirect by error to the AppStore.

The Chartboost's one are provided by Chartboost without modification.

It's the same class I use in my Twins4Kids app.

#Screen shots

Chartboost ad  
![Chartboost](https://github.com/renebigot/BRFullScreenAd/raw/master/screenshot1.png)

Revmob custom interstitial in landscape  
![Revmob](https://github.com/renebigot/BRFullScreenAd/raw/master/screenshot.png)

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

#License

BSD License

Copyright (c) 2012 René BIGOT

