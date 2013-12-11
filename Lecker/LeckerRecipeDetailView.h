//
//  LeckerRecipeDetailView.h
//  Lecker
//
//  Created by Naujeck, Marcel on 07.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeckerRecipeDetailTabBar.h"
#import "LeckerSingleRecipeDetailModel.h"
#import "LeckerIngView.h"
#import "LeckerInfoView.h"
#import "LeckerPrepStepsView.h"

@protocol LeckerRecipeDetailViewProtocol;


@interface LeckerRecipeDetailView : UIView <LeckerRecipeDetailTabBarProtocol,LeckerIngViewProtocol,UIWebViewDelegate,UIAlertViewDelegate,LeckerInfoViewProtocol,LeckerPrepStepsViewProtocol>
-(void) showRecipe:(LeckerSingleRecipeDetailModel*) recipe withImage:(UIImage*) image;
@property (nonatomic,weak) id <LeckerRecipeDetailViewProtocol> delegate;
@end

@protocol LeckerRecipeDetailViewProtocol <NSObject>
@optional
-(void) backButtonPressed;
-(void) addIngredientsSet:(NSSet *)ingSet;
-(void) facebookShareWithTitle:(NSString*) title Image:(UIImage*) image Id:(NSString*) recipeId;
@end