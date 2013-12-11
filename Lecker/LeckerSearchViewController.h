//
//  LeckerSearchViewController.h
//  Lecker
//
//  Created by Naujeck, Marcel on 14.01.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeckerSearchMainView.h"
#import "RSACommunication.h"
#import "LeckerDailyRecipeMainView.h"
#import "LeckerRecipeDetailView.h"
#import "LeckerOfflineView.h"
#import "SASBannerView.h"

@protocol LeckerSearchControllerProtocol <NSObject>
-(void) numberOfFavChanged;
-(void) numberofShoppingListItemsChanged;
-(void) switchToOffline;
-(void) switchToOnline;
@end

@interface LeckerSearchViewController : UIViewController <LeckerSearchMainViewProtocol,RSACommunicationProtocol,LeckerDailyRecipeMainViewProtocol,LeckerRecipeDetailViewProtocol,UIAlertViewDelegate,LeckerOfflineViewProtocol,SASAdViewDelegate>
@property (nonatomic,weak) id <LeckerSearchControllerProtocol> delegate;
-(void) updateMainView;
-(void) toggleToOffline;
-(void) toggleToOnline;
@end





