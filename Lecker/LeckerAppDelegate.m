//
//  LeckerAppDelegate.m
//  Lecker
//
//  Created by Naujeck, Marcel on 14.01.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerAppDelegate.h"
#import "LeckerShoppingCartViewController.h"
#import "DataManager.h"
#import "Reachability.h"
#import "SASAdView.h"
#import <INFOnlineLibrary/INFOnlineLibrary.h>
#import "LeckerTools.h"
#import "LeckerInfoViewController.h"



@interface LeckerAppDelegate ()
@property UIActivityIndicatorView *spinning;
@property UIView *layer;
@property LeckerDailyRecipeViewController *dailyRecipeController;
@property LeckerFavoritesViewController *favoritesController;
@property LeckerShoppingCartViewController *shoppingCartController;
@property LeckerSearchViewController *searchController;
@property LeckerAdViewController *adViewController;
@property LeckerInfoViewController *infoViewController;
@property NSString *actualDate;
@end

@implementation LeckerAppDelegate


-(void) processIVWTracking {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    BOOL trackingEnabled = [defaults boolForKey:@"trackingEnabled"];
    if (trackingEnabled) {
        NSLog(@"IVW-Session Start");
        [[IOLSession defaultSession] setDebugLogLevel:IOLDebugLevelInfo];
        [[IOLSession defaultSession] startSessionWithOfferIdentifier:@"applecke"];
    } else {
        NSLog(@"IVW-Session terminate");
        [[IOLSession defaultSession] terminateSession];
    }

}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self processIVWTracking];
    
    [SASAdView setSiteID:46936 baseURL:@"http://www6.smartadserver.com"];
    //[SASAdView enableLogging];
    //[SASAdView enableTestMode];
    
    
    /* GA Initialisierung */
    [GAI sharedInstance].debug = NO;
    [GAI sharedInstance].dispatchInterval = 15;
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    self.tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-16281452-6"];
    [self.tracker setAppName:@"Lecker Tagesrezepte App"];
    [self.tracker setAppVersion:@"V2.0"];
    self.tracker.sessionStart = YES;
    [self.tracker trackEventWithCategory:@"Application" withAction:@"Getting active..." withLabel:@"Start or resume" withValue:nil];

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.dailyRecipeController = [[LeckerDailyRecipeViewController alloc] init];
    self.dailyRecipeController.delegate=self;
    NSLog(@"Daily %f",self.dailyRecipeController.view.bounds.size.height);
    self.searchController = [[LeckerSearchViewController alloc] init];
    self.searchController.delegate=self;
    self.favoritesController = [[LeckerFavoritesViewController alloc] init];
    self.favoritesController.delegate=self;
    self.shoppingCartController = [[LeckerShoppingCartViewController alloc] init];
    self.infoViewController=[[LeckerInfoViewController alloc] init];
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[self.dailyRecipeController,self.searchController,self.favoritesController,self.shoppingCartController,self.infoViewController];
    
    UIViewController *tmpCrt=[[UIViewController alloc] init];
    UIImageView *background;
    if([LeckerTools isIPhone5]) {
        background=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SplashScreenRetina4.png"]];
    } else {
        background=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SplashScreen.png"]];
    }
    
    background.frame=tmpCrt.view.bounds;
    [tmpCrt.view addSubview:background];
   // [tmpCrt setPrefersStatusBarHidden];
    self.window.rootViewController = tmpCrt;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL firstTime = [defaults boolForKey:@"firstTime"];
    if (!firstTime) {
        PrivacyStatementView *tmpView=[[PrivacyStatementView alloc] initWithFrame:tmpCrt.view.bounds];
        tmpView.delegate=self;
        [tmpCrt.view addSubview:tmpView];
    } else {
        [[RSACommunication getInstance] setDelegate:self];
        [self startInit];
        [self numberOfFavChanged];
        [self numberofShoppingListItemsChanged];
    }
    
    [self.window makeKeyAndVisible];

    return YES;
}

-(void) privacyStatementViewClosed {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"trackingEnabled"];
    [defaults setBool:YES forKey:@"firstTime"];
    [defaults synchronize];
    [self processIVWTracking];
     [[RSACommunication getInstance] setDelegate:self];
     [self startInit];
     [self numberOfFavChanged];
     [self numberofShoppingListItemsChanged];
}

-(void) numberofShoppingListItemsChanged {
    int num=[[DataManager getInstance] numberOfShoppingCardItems];
    UIViewController *tmp=[self.tabBarController.customizableViewControllers objectAtIndex:3];
    if (num!=0) {
        tmp.tabBarItem.badgeValue=[NSString stringWithFormat:@"%d", num];
    } else {
        tmp.tabBarItem.badgeValue=nil;
    }
    [self.shoppingCartController updateMainView];
}

-(void) numberOfFavChanged {
    int num=[[DataManager getInstance] numberOfFavorits];
    UIViewController *tmp=[self.tabBarController.customizableViewControllers objectAtIndex:2];
    if (num!=0) {
        tmp.tabBarItem.badgeValue=[NSString stringWithFormat:@"%d", num];  
    } else {
        tmp.tabBarItem.badgeValue=nil;
    }

    [self.favoritesController updateFavView];
    [self.dailyRecipeController updateMainView];
    [self.searchController updateMainView];
}

-(void) startInit {
    [self lockApp];
    if([DataManager getInstance].securityInformation==nil) {
        NSLog(@"Getting new Public Key");
        [[RSACommunication getInstance] doKeyRequest];
    } else {
        [self unlockApp];
        [self getFacets];
    }
}

-(void) getFacets {
   [self lockApp];
    NSNumber *facetLoadet=[[DataManager getInstance] appStatus].facetLoaded;
    if([facetLoadet boolValue]) {
        [self unlockApp];
        self.adViewController=[[LeckerAdViewController alloc] init];
        self.adViewController.delegate=self;
        [self.adViewController prepareForBanner];

    } else {
        NSLog(@"Getting facetlist");
        [[RSACommunication getInstance] doFacetRequest];
    }
}

-(void) adLoaded {
    self.window.rootViewController = self.adViewController;
     [self.window makeKeyAndVisible];
}

-(void) adClosed {
    self.window.rootViewController = self.tabBarController;
     [self.window makeKeyAndVisible];
}

-(void) adFailed {
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
}

-(void) communicationFailedinStatus:(RSAStatus)status
{
    Reachability *internetReachable = [Reachability reachabilityForInternetConnection];
    NetworkStatus rstatus = [internetReachable currentReachabilityStatus];
    NSString *msg;
    [self unlockApp];
    if(rstatus == NotReachable)
    {
        msg = @"Bitte überprüfen sie Ihre Netzwerkverbindung. Weder 3G noch WLAN haben eine Verbindung";
    }
    else
    {
        msg = @"Der Leckerserver konnte nicht erreicht werden. Versuchen Sie es später nochmal.";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Verbindungsfehler"
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Erneut Versuchen"
                                              otherButtonTitles:nil];
    [alertView show];
}

-(void)communicationFinishSuccessfulinStatus:(RSAStatus)status {
    [self unlockApp];
    if(status==RSAStatus_KEYREQUEST) {
        [self getFacets];
    } else if (status==RSAStatus_FACETREQUEST) {
        [[DataManager getInstance] facetLoaded];
        self.window.rootViewController = self.tabBarController;
        [self.window makeKeyAndVisible];
    }
}


-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self startInit];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)  fromDate: [NSDate date]];
    self.actualDate=[NSString stringWithFormat:@"%d.%d.%d",components.day,components.month,components.year];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)  fromDate: [NSDate date]];
    NSString *tmp=[NSString stringWithFormat:@"%d.%d.%d",components.day,components.month,components.year];
    if (![tmp isEqualToString:self.actualDate]) {
        self.dailyRecipeController.initialStart=YES;
        [self.dailyRecipeController reInitializeMainVIew];
    } 
    [self processIVWTracking];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) switchToOffline {
    [self.searchController toggleToOffline];
    [self.dailyRecipeController toggleToOffline];
}


-(void) lockApp {
    UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];
    self.spinning= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinning.frame = mainWindow.bounds;
    self.spinning.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    [self.spinning startAnimating];
    
    self.layer=[[UIView alloc] initWithFrame:mainWindow.bounds];
    self.layer.backgroundColor=[UIColor blackColor];
    self.layer.alpha=0.5f;
    
    [mainWindow addSubview:self.layer];
    [mainWindow addSubview:self.spinning];
}

-(void) unlockApp {
    [self.spinning removeFromSuperview];
    self.spinning= nil;
    
    [self.layer removeFromSuperview];
    self.layer=nil;
}

-(void) switchToOnline {
    [self.searchController toggleToOnline];
    [self.dailyRecipeController toggleToOnline];
}

@end
