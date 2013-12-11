//
//  LeckerFavoritesViewController.h
//  Lecker
//
//  Created by Naujeck, Marcel on 14.01.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeckerFavoritesMainView.h"
#import "LeckerRecipeDetailView.h"
#import "SASBannerView.h"


@protocol LeckerFavoritesViewControllerProtocol <NSObject>
@optional
-(void) numberOfFavChanged;
-(void) numberofShoppingListItemsChanged;
@end


@interface LeckerFavoritesViewController : UIViewController <LeckerFavoritesMainViewProtocol,LeckerRecipeDetailTabBarProtocol,LeckerRecipeDetailViewProtocol,SASAdViewDelegate>

@property (nonatomic,weak) id <LeckerFavoritesViewControllerProtocol> delegate;
-(void) updateFavView;

@end


