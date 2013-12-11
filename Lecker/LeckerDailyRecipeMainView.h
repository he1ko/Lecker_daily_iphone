//
//  LeckerDailyRecipeMainView.h
//  Lecker
//
//  Created by Naujeck, Marcel on 14.01.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeckerSingleRecipeOverviewModel.h"
#import "LeckerSingleRecipeDetailModel.h"
#import "LeckerSingleRecipeOverview.h"
#import "LeckerAdView.h"
#import "SASBannerView.h"


@protocol LeckerDailyRecipeMainViewProtocol;


@interface LeckerDailyRecipeMainView : UIView <LeckerSingleRecipeOverviewProtocol>
@property (nonatomic,weak) id <LeckerDailyRecipeMainViewProtocol> delegate;
-(void) addViewWithModel:(LeckerSingleRecipeOverviewModel*) recipe andFav:(BOOL)isFav;
-(void) initalSetup;
-(void) updateArrayForFavWithSet:(NSSet*) contentIdSet;
-(void) enableBackButton;
-(void) setMax:(int) maxValue;
-(void) createBanner:(SASBannerView*) bannerView;
-(void) removeBanner;
- (id)initWithFrame:(CGRect)frame pinView:(BOOL) hasPinView;
-(void) getFocus;
@end

@protocol LeckerDailyRecipeMainViewProtocol <NSObject>

@optional
-(void) switchToPinView;
-(void) pullNextRecipes;
-(void) recipeActivateWithContentId:(NSString*) contentId recipeImage:(UIImage*) image;
-(void) recipeImageLoadedWithContentId:(NSString *)contentId andRecipeImage:(UIImage *)image;
-(void) optionalBackButtonPressed;
-(void) requestNewAdForBanner;

@required
-(void) addToFavPressedWithContentId:(NSString*) contentId andImage:(UIImage*) image;
-(void) removeFromFavPressedWithContentId:(NSString*) contentId;

@end
