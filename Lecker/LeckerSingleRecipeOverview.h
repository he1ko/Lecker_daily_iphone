//
//  LeckerSingleRecipeOverview.h
//  Lecker
//
//  Created by Naujeck, Marcel on 05.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeckerSingleRecipeOverviewModel.h"
#import "LeckerSingleRecipeDetailModel.h"
#import "AsycImageLoader.h"
#import "LeckerRecipeImageView.h"

@protocol LeckerSingleRecipeOverviewProtocol;


@interface LeckerSingleRecipeOverview : UIView <AycnImageLoaderProtocol,LeckerRecipeImageViewProtocol>

@property (nonatomic,weak) id <LeckerSingleRecipeOverviewProtocol> delegate;
@property LeckerSingleRecipeOverviewModel *model;
- (id)initWithFrame:(CGRect)frame recipeData:(LeckerSingleRecipeOverviewModel*) recipe isFav:(Boolean) isFav;
-(void) isFavorite;
-(void) isNotFavorite;
-(void) getFocus;
-(void) switchToAdView;
-(void) switchToNormalView;
@end

@protocol LeckerSingleRecipeOverviewProtocol <NSObject>
@optional
-(void) recipePressedWithContentId:(NSString *) contentId recipeImage:(UIImage*) image;
-(void) recipeImageLoadedWithContentId:(NSString*) contentId andRecipeImage:(UIImage*) image;
@required
-(void) addToFavPressedWithContentId:(NSString*) contentId andImage:(UIImage*) image;
-(void) removeFromFavPressedWithContentId:(NSString*) contentId;
@end
