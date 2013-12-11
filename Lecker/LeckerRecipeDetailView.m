//
//  LeckerRecipeDetailView.m
//  Lecker
//
//  Created by Naujeck, Marcel on 07.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//


#import "LeckerRecipeDetailView.h"
#import <INFOnlineLibrary/INFOnlineLibrary.h>

@interface LeckerRecipeDetailView()
@property LeckerIngView *ingView;
@property UIImage *recipeImage;
@property LeckerInfoView *infoView;
@property LeckerPrepStepsView *prepView;
@property UIView *actualView;
@property LeckerRecipeDetailTabBar *tabBar;
@property UIView *contentView;
@property UIImageView *backButton;
@property LeckerSingleRecipeDetailModel *recipe;
@property UIWebView *webview;

@end

@implementation LeckerRecipeDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        UIImageView *background=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"holz.png"]];
        background.frame=frame;
        [self addSubview:background];
        self.contentView=[[UIView alloc] initWithFrame:self.bounds];
        [self addSubview: self.contentView];
        self.tabBar=[[LeckerRecipeDetailTabBar alloc] initWithFrame:CGRectMake(35, 0, 285, 35)];
        self.tabBar.delegate=self;
        [self addSubview:self.tabBar];
        self.backButton=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back.png"]];
        self.backButton.frame=CGRectMake(0, 0, 32, 32);
        [self addSubview: self.backButton];
        UITapGestureRecognizer *backTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTapped:)];
        backTap.numberOfTapsRequired=1;
        [self.backButton addGestureRecognizer:backTap];
        self.backButton.userInteractionEnabled=YES;
    }
    return self;
}

-(void) showRecipe:(LeckerSingleRecipeDetailModel*) recipe withImage:(UIImage*) image {
    self.recipe=recipe;
    self.recipeImage=image;
    
    self.ingView=[[LeckerIngView alloc] initWithFrame:self.bounds recipe:self.recipe andImage:self.recipeImage];
    self.ingView.delegate=self;
    [self.contentView addSubview:self.ingView];
    self.actualView=self.ingView;
    
    self.prepView=[[LeckerPrepStepsView alloc] initWithFrame:self.bounds recipe:self.recipe andImage:self.recipeImage];
    self.prepView.face_delegate=self;
    self.infoView=[[LeckerInfoView alloc] initWithFrame:self.bounds recipe:self.recipe andImage:self.recipeImage];
    self.infoView.delegate=self;
}

-(void) addIngredientsSet:(NSSet *)ingSet {
    if([self.delegate respondsToSelector:@selector(addIngredientsSet:)]) {
        [self.delegate addIngredientsSet:ingSet];
    }
}

-(void) backTapped:(UITapGestureRecognizer*) tap {
    if([self.delegate respondsToSelector:@selector(backButtonPressed)]) {
        [self.delegate backButtonPressed];
    }
}

-(void) tabBarToggledTo:(TabbarStatus)status {
    self.tabBar.userInteractionEnabled=NO;
    switch (status) {
        case TABBAR_ING: {
            [UIView transitionFromView:self.actualView toView:self.ingView duration:0.6f options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
                [self.actualView removeFromSuperview];
                self.actualView=self.ingView;
                self.tabBar.userInteractionEnabled=YES;
                [[IOLSession defaultSession] logEventWithType:IOLEventTypeView state:IOLViewAppeared category:@"IngredientsViewOpen" comment:@"IngredientsViewOpen"];
            }];
        }
        break;
        case TABBAR_STEPS:{
            [UIView transitionFromView:self.actualView toView:self.prepView duration:0.6f options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
                [self.actualView removeFromSuperview];
                self.actualView=self.prepView;
                self.tabBar.userInteractionEnabled=YES;
                [[IOLSession defaultSession] logEventWithType:IOLEventTypeView state:IOLViewAppeared category:@"PreperationStepsViewOpen" comment:@"PreperationStepsViewOpen"];
            }];
        }
        break;
        case TABBAR_INFOS:{
            [UIView transitionFromView:self.actualView toView:self.infoView duration:0.6f options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
                [self.actualView removeFromSuperview];
                self.actualView=self.infoView;
                self.tabBar.userInteractionEnabled=YES;
                [[IOLSession defaultSession] logEventWithType:IOLEventTypeView state:IOLViewAppeared category:@"InfoViewOpen" comment:@"InfoViewOpen"];
            }];
        }
        break;
    }
}

-(void) facebookShare {
    if ([self.delegate respondsToSelector:@selector(facebookShareWithTitle:Image:Id:)]) {
        [self.delegate facebookShareWithTitle:self.recipe.title Image:self.recipeImage Id:self.recipe.contentId];
    }
    
}


@end
