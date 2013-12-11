//
//  LeckerIngView.h
//  Lecker
//
//  Created by Naujeck, Marcel on 08.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeckerSingleRecipeDetailModel.h"
#import "AsycImageLoader.h"
#import "LeckerSingleIngView.h"

@protocol LeckerIngViewProtocol;

@interface LeckerIngView : UIView <AycnImageLoaderProtocol,LeckerSingleIngProtocol>
- (id)initWithFrame:(CGRect)frame recipe:(LeckerSingleRecipeDetailModel*) recipe andImage:(UIImage*) image;
@property (nonatomic,weak) id <LeckerIngViewProtocol> delegate;
@end

@protocol LeckerIngViewProtocol <NSObject>
@optional
-(void) addIngredientsSet:(NSSet*) ingSet;
-(void) facebookShare;
@end
