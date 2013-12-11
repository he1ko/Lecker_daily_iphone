//
//  LeckerDailyPinView.h
//  Lecker
//
//  Created by Naujeck, Marcel on 12.04.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeckerDailyPinSingleView.h"

@protocol LeckerDailyPinViewProtocol <NSObject>

@required
-(void) backToSwipeView;
-(void) pullNextRecipes;
-(void) recipeActivateWithContentId:(NSString *)contentId recipeImage:(UIImage *)image;
@end


@interface LeckerDailyPinView : UIView <LeckerDailyPinSingleViewProtocol,UIScrollViewDelegate>
-(void) processWithArray:(NSArray*) initArray;
@property (nonatomic,weak) id <LeckerDailyPinViewProtocol> delegate;
@end
