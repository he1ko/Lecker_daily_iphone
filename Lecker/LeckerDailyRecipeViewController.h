//
//  LeckerDailyRecipeViewController.h
//  Lecker
//
//  Created by Naujeck, Marcel on 14.01.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSACommunication.h"
#import "LeckerDailyRecipeMainView.h"
#import "LeckerRecipeDetailView.h"
#import "LeckerOfflineView.h"
#import "SASBannerView.h"
#import "LeckerDailyPinView.h"

@protocol LeckerDailyRecipeViewControllerProtocol;

@interface LeckerDailyRecipeViewController : UIViewController <RSACommunicationProtocol,LeckerDailyRecipeMainViewProtocol,LeckerRecipeDetailViewProtocol,UIAlertViewDelegate,LeckerOfflineViewProtocol,SASAdViewDelegate,LeckerDailyPinViewProtocol>
@property (nonatomic,weak) id <LeckerDailyRecipeViewControllerProtocol> delegate;
@property Boolean initialStart;
-(void) updateMainView;
-(void) toggleToOffline;
-(void) toggleToOnline;
-(void) reInitializeMainVIew;
@end

@protocol LeckerDailyRecipeViewControllerProtocol <NSObject>

@optional
-(void) numberOfFavChanged;
-(void) numberofShoppingListItemsChanged;
-(void) switchToOffline;
-(void) switchToOnline;
@end
