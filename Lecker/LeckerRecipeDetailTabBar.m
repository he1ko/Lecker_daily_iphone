//
//  LeckerRecipeDetailTabBar.m
//  Lecker
//
//  Created by Naujeck, Marcel on 07.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerRecipeDetailTabBar.h"

@interface LeckerRecipeDetailTabBar()
@property UIImageView *ing;
@property UIImageView *steps;
@property UIImageView *infos;
@property UIImageView *activ;


@end

@implementation LeckerRecipeDetailTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.ing=[[UIImageView alloc] initWithFrame:CGRectMake(0,-18, 95, 59)];
        [self.ing setImage:[UIImage imageNamed:@"navigations-zutaten.png"]];
        [self addSubview:self.ing];
        self.activ=self.ing;
        UITapGestureRecognizer *ingTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ingTapped:)];
        ingTap.numberOfTapsRequired=1;
        self.ing.userInteractionEnabled=YES;
        [self.ing addGestureRecognizer:ingTap];

        self.steps=[[UIImageView alloc] initWithFrame:CGRectMake(95,-28, 95, 59)];
        [self.steps setImage:[UIImage imageNamed:@"navigations-schritte.png"]];
        [self addSubview:self.steps];
        UITapGestureRecognizer *stepsTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stepsTapped:)];
        stepsTap.numberOfTapsRequired=1;
        self.steps.userInteractionEnabled=YES;
        [self.steps addGestureRecognizer:stepsTap];

        self.infos=[[UIImageView alloc] initWithFrame:CGRectMake(190,-28, 95, 59)];
        [self.infos setImage:[UIImage imageNamed:@"navigations-infos.png"]];
        [self addSubview:self.infos];
        UITapGestureRecognizer *infosTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infosTapped:)];
        infosTap.numberOfTapsRequired=1;
        self.infos.userInteractionEnabled=YES;
        [self.infos addGestureRecognizer:infosTap];

    }
    return self;
}


-(void) animateTapBack:(UIImageView*) backtap TabFront:(UIImageView*) frontTap status:(TabbarStatus) status {
    if (backtap!=frontTap) {
        self.activ=frontTap;
        if([self.delegate respondsToSelector:@selector(tabBarToggledTo:)]) {
            [self.delegate tabBarToggledTo:status];
        }
        CGRect frame1=backtap.frame;
        frame1.origin.y=-28;
        CGRect frame2=frontTap.frame;
        frame2.origin.y=-18;
        [UIView animateWithDuration:0.3f animations:^{
            backtap.frame=frame1;
            frontTap.frame=frame2;
        } completion:^(BOOL finished) {
            
        }];
    }

}

-(void) ingTapped:(UITapGestureRecognizer*) tap {
    [self animateTapBack:self.activ TabFront:self.ing status:TABBAR_ING];
    
}

-(void) stepsTapped:(UITapGestureRecognizer*) tap {
    [self animateTapBack:self.activ TabFront:self.steps status:TABBAR_STEPS];
}

-(void) infosTapped:(UITapGestureRecognizer*) tap {
   [self animateTapBack:self.activ TabFront:self.infos status:TABBAR_INFOS];
}

@end
