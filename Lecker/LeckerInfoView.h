//
//  LeckerInfoView.h
//  Lecker
//
//  Created by Naujeck, Marcel on 08.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeckerSingleRecipeDetailModel.h"

@protocol LeckerInfoViewProtocol;

@interface LeckerInfoView : UIView
- (id)initWithFrame:(CGRect)frame recipe:(LeckerSingleRecipeDetailModel*) recipe andImage:(UIImage*) image;
@property (nonatomic,weak) id <LeckerInfoViewProtocol> delegate;
@end

@protocol LeckerInfoViewProtocol <NSObject>
@optional
-(void) facebookShare;
@end


