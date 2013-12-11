//
//  LeckerRecipeImageView.h
//  Lecker
//
//  Created by Naujeck, Marcel on 15.04.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeckerRecipeImageViewProtocol <NSObject>

@optional
-(void) pictureTapped;

@end

@interface LeckerRecipeImageView : UIImageView
@property (nonatomic,weak) id <LeckerRecipeImageViewProtocol> delegate;
@end
