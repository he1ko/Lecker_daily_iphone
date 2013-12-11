//
//  LeckerAppDelegate.h
//  Lecker
//
//  Created by Naujeck, Marcel on 14.01.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSACommunication.h"
#import "LeckerDailyRecipeViewController.h"
#import "LeckerFavoritesViewController.h"
#import "LeckerSearchViewController.h"
#import "PrivacyStatementView.h"
#import "GAI.h"
#import "SASInterstitialView.h"
#import "LeckerAdViewController.h"

@interface LeckerAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, UIAlertViewDelegate,RSACommunicationProtocol,LeckerDailyRecipeViewControllerProtocol,LeckerFavoritesViewControllerProtocol,LeckerSearchControllerProtocol,PrivacyStatementViewProtocol,LeckerAdViewControllerProtocol>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
-(void) lockApp;
-(void) unlockApp;
@property(nonatomic, retain) id<GAITracker> tracker;
@end
