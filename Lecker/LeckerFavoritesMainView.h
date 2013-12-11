//
//  LeckerFavoritesMainView.h
//  Lecker
//
//  Created by Naujeck, Marcel on 15.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeckerSingleRecipeDetailModel.h"
#import "LeckerFavEntryView.h"

@protocol LeckerFavoritesMainViewProtocol;

@interface LeckerFavoritesMainView : UIView <LeckerFavEntryViewProtocol>
@property (nonatomic,weak) id <LeckerFavoritesMainViewProtocol> delegate;
-(void) showFavList:(NSArray*) recipeList;
- (id)initWithFrame:(CGRect)frame andRecipeList:(NSArray *)recipeList;
@end

@protocol LeckerFavoritesMainViewProtocol <NSObject>
@optional
-(void) recipePressedWithRecipe:(LeckerSingleRecipeDetailModel*) recipe;
-(void) recipeRemoveFromFav:(NSString*) contentId;
-(void) deleteSetFromFavs:(NSSet*) removeSet;
@end