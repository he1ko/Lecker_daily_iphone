//
//  LeckerRecipeDetailTabBar.h
//  Lecker
//
//  Created by Naujeck, Marcel on 07.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    TABBAR_ING=0,
    TABBAR_STEPS=1,
    TABBAR_INFOS=3
};

typedef NSUInteger TabbarStatus;


@protocol LeckerRecipeDetailTabBarProtocol;


@interface LeckerRecipeDetailTabBar : UIView

@property (nonatomic,weak) id <LeckerRecipeDetailTabBarProtocol> delegate;

@end

@protocol LeckerRecipeDetailTabBarProtocol <NSObject>

@optional
-(void) tabBarToggledTo:(TabbarStatus) status;

@end
