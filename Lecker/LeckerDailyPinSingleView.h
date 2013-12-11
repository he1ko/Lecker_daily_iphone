//
//  LeckerDailyPinSingleView.h
//  Lecker
//
//  Created by Naujeck, Marcel on 16.04.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeckerSingleRecipeOverviewModel.h"

@protocol LeckerDailyPinSingleViewProtocol;

@interface LeckerDailyPinSingleView : UIView <LeckerSingleRecipeOverviewModelProtocol>
- (id)initWithFrame:(CGRect)frame andDetailData:(LeckerSingleRecipeOverviewModel*) model andPos:(int) pos;
-(void) processInit;
@property (nonatomic,weak) id <LeckerDailyPinSingleViewProtocol> delegate;
@end

@protocol LeckerDailyPinSingleViewProtocol <NSObject>
@required
-(void) viewReady:(LeckerDailyPinSingleView*) view;
-(void) recipePressedWithId:(NSString*) recipeId andImage:(UIImage*) image;
@end