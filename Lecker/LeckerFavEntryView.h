//
//  LeckerFavEntryView.h
//  Lecker
//
//  Created by Naujeck, Marcel on 15.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeckerSingleRecipeDetailModel.h"

@protocol LeckerFavEntryViewProtocol;


@interface LeckerFavEntryView : UIView
@property (nonatomic,weak) id <LeckerFavEntryViewProtocol> delegate;
- (id)initWithFrame:(CGRect)frame andRecipe:(LeckerSingleRecipeDetailModel*) recipe;
-(void) toggleToEdit;
-(void) toggleToNormal;
@end

@protocol LeckerFavEntryViewProtocol <NSObject>
@optional
-(void) recipePressedWithRecipe:(LeckerSingleRecipeDetailModel*) recipe;
-(void) recipeRemoveFromFav:(NSString*) contentId;
-(void) addToRemoveList:(NSString*) contentId;
-(void) removeFromRemoveList:(NSString*) contentId;
@end
