//
//  LeckerFavEntryView.m
//  Lecker
//
//  Created by Naujeck, Marcel on 15.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerFavEntryView.h"
#import "LeckerPreviewImage.h"
#import <QuartzCore/QuartzCore.h>
#import "LeckerTools.h"

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

@interface LeckerFavEntryView()
@property LeckerSingleRecipeDetailModel *recipe;
@property LeckerPreviewImage *recipeImage;
@property UILabel *recipeTitle;
@property UILabel *recipeSubtitle;
@property UIButton *delete;
@property UIView *buttonView;
@property UIView *bgView;
@property UIImageView *arrow;
@property UIImageView *deleteSign;
@end

@implementation LeckerFavEntryView


- (id)initWithFrame:(CGRect)frame andRecipe:(LeckerSingleRecipeDetailModel*) recipe
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.recipe=recipe;
        self.recipeImage=[[LeckerPreviewImage alloc] initWithFrame:CGRectMake(self.bounds.origin.x+5, self.bounds.origin.y+5, self.bounds.size.height-10, self.bounds.size.height-10) withImage:[UIImage imageWithData:recipe.image]];

        [self addSubview:self.recipeImage];
        
        // Save devider:
        NSString *devider = @"mit";
        NSArray *titleArray=[recipe.title componentsSeparatedByString:devider];
        if (titleArray.count==1)
        {
            devider = @"auf";
            titleArray=[recipe.title componentsSeparatedByString:devider];
        }
        // TODO: Wäre ein einfaches Linebreak vor dem Devider nicht einfacher?
        // und visuell konsistenter?
        
        self.recipeTitle=[[UILabel alloc]
                          initWithFrame:CGRectMake(self.recipeImage.frame.origin.x+self.recipeImage.frame.size.width+7, self.recipeImage.frame.origin.y+10, 185, 40)];
        self.recipeTitle.text=[titleArray objectAtIndex:0];
        self.recipeTitle.font=[UIFont fontWithName:@"DroidSans" size:14];
        self.recipeTitle.textColor=[UIColor blackColor];
        self.recipeTitle.backgroundColor=[UIColor clearColor];
        self.recipeTitle.numberOfLines=2;
        [self addSubview:self.recipeTitle];
        
        if (titleArray.count>1) {
            CGRect frame=self.recipeTitle.frame;
            frame.origin.y-=4;
            self.recipeTitle.frame=frame;
            self.recipeTitle.numberOfLines=1;
            self.recipeSubtitle=[[UILabel alloc]
                                 initWithFrame:CGRectMake(self.recipeImage.frame.origin.x+self.recipeImage.frame.size.width+7, self.recipeImage.frame.origin.y+30, 185, 20)];
            self.recipeSubtitle.text=[devider stringByAppendingString:[titleArray objectAtIndex:1]]; // SK "auf" könnte durch "mit" ersetzt werden... Fixed with devider
            self.recipeSubtitle.font=[UIFont fontWithName:@"DroidSans" size:12];
            self.recipeSubtitle.textColor=[UIColor blackColor];
            self.recipeSubtitle.backgroundColor=[UIColor clearColor];
            self.recipeSubtitle.numberOfLines=0;
            [self addSubview:self.recipeSubtitle]; 
        }
        
        self.arrow=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
        frame=self.arrow.frame;
        frame.origin.x=self.bounds.size.width-30;
        frame.origin.y=self.bounds.size.height/2-frame.size.height/2;
        self.arrow.frame=frame;
        [self addSubview:self.arrow];
        
        self.userInteractionEnabled=YES;

        UISwipeGestureRecognizer *swipeLeft=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
        swipeLeft.direction=UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swipeLeft];
        
        UISwipeGestureRecognizer *swipeRight=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
        swipeRight.direction=UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:swipeRight];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        tap.numberOfTapsRequired=1;
        [self addGestureRecognizer:tap];

        self.deleteSign=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"minus.png"]];
        frame=self.deleteSign.frame;
        frame.origin.x=0;
        frame.origin.y=self.bounds.size.height/2-frame.size.height/2;
        self.deleteSign.frame=frame;
        self.deleteSign.alpha=0.0;
        [self addSubview:self.deleteSign];
        
    }
    return self;
}

-(void) tapped:(UITapGestureRecognizer*) tap {
    if([self.delegate respondsToSelector:@selector(recipePressedWithRecipe:)]) {
        [self.delegate recipePressedWithRecipe:self.recipe];
    }
}

-(void) swipeLeft:(UISwipeGestureRecognizer*) swipe {
    if(self.delete==nil) {
        CGRect frame=self.bounds;
        frame.origin.x=self.bounds.size.width-70;
        frame.size.width=70;
        frame.origin.y=(self.bounds.size.height/2)-15;
        frame.size.height=30;
        
        self.buttonView=[[UIView alloc] initWithFrame:frame];
        
        
        
        self.delete=[UIButton buttonWithType:UIButtonTypeCustom];
        [self.delete setBackgroundImage:[UIImage imageNamed:@"button_loeschen_rot.png"] forState:UIControlStateNormal];
        [self.delete setTitleColor:[LeckerTools colorFromHexString:@"#db3b3a"] forState:UIControlStateNormal];
        [self.delete setTitle:@"Löschen" forState:UIControlStateNormal];
        [self.delete setTitleEdgeInsets:UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)];
        self.delete.titleLabel.font = [UIFont fontWithName:@"TimesNewRomanPSMT" size:14];
        self.delete.frame=self.buttonView.bounds;
        
        /*[self.delete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.delete setBackgroundColor:[UIColor blackColor]];
        
        [self.delete setTitle:@"Löschen" forState:UIControlStateNormal];
                
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = self.delete.layer.bounds;
        
        gradientLayer.colors = [NSArray arrayWithObjects:
                                (id)[UIColor colorWithRed:1 green:0 blue:0 alpha:0.4].CGColor,
                                (id)[UIColor colorWithRed:1 green:0 blue:0 alpha:0.6].CGColor,
                                (id)[UIColor colorWithRed:1 green:0 blue:0 alpha:0.7].CGColor,
                                (id)[UIColor colorWithRed:1 green:0 blue:0 alpha:1.0].CGColor,
                                nil];
        
        gradientLayer.locations = [NSArray arrayWithObjects:
                                   [NSNumber numberWithFloat:0.0f],
                                   [NSNumber numberWithFloat:0.5],
                                   [NSNumber numberWithFloat:0.5],
                                   [NSNumber numberWithFloat:1.0f],
                                   nil];
        
        
        [self.delete.layer insertSublayer:gradientLayer atIndex:1];
        
        
        
        gradientLayer.cornerRadius = self.delete.layer.cornerRadius;
        
        
        CALayer *btnLayer = [self.delete layer];
        [btnLayer setMasksToBounds:YES];
        [btnLayer setCornerRadius:8.0f];
        
        [btnLayer setBorderWidth:1.0f];
        [btnLayer setBorderColor:[[UIColor blackColor] CGColor]];*/
        
        [self.buttonView addSubview:self.delete];
        [self addSubview:self.buttonView];
        
        self.buttonView.clipsToBounds=YES,
        frame=self.buttonView.frame;
        frame.origin.x=frame.origin.x+frame.size.width;
        frame.size.width=1;
        
        CGRect frame2=self.buttonView.frame;
        self.buttonView.frame=frame;
        
        CGRect frame3=self.delete.frame;
        CGRect frame4=frame3;
        frame4.origin.x=frame4.size.width*-1;
        self.delete.frame=frame4;
        
        CGRect frame5=self.recipeTitle.frame;
        frame5.size.width-=40;
        CGRect frame6=self.recipeSubtitle.frame;
        frame6.size.width-=40;
        
        [UIView animateWithDuration:0.2f animations:^{
            self.buttonView.frame=frame2;
            self.delete.frame=frame3;
        } completion:^(BOOL finished) {
            self.recipeSubtitle.frame=frame6;
            self.recipeTitle.frame=frame5;
            [self.delete addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
        }];
    }
}

-(void) buttonPressed:(UIButton*) button {

    [UIView animateWithDuration:0.2f animations:^{
        self.delete.alpha=0.0f;
    } completion:^(BOOL finished) {
        [self.delete removeFromSuperview];
        if([self.delegate respondsToSelector:@selector(recipeRemoveFromFav:)]) {
            [self.delegate recipeRemoveFromFav:self.recipe.contentId];
        }
    }];
}

-(void) swipeRight:(UISwipeGestureRecognizer*) swipe {
    if (self.delete!=nil) {
        CGRect frame=self.buttonView.frame;
        frame.origin.x+=frame.size.width;
        frame.size.width=0;
        
        CGRect frame1=self.delete.frame;
        frame1.origin.x=frame1.size.width*-1;
        
        CGRect frame2=self.recipeTitle.frame;
        frame2.size.width+=40;
        CGRect frame3=self.recipeSubtitle.frame;
        frame3.size.width+=40;
        [UIView animateWithDuration:0.4f animations:^{
            self.buttonView.frame=frame;
            self.delete.frame=frame1;
            
        } completion:^(BOOL finished) {
            self.recipeTitle.frame=frame2;
            self.recipeSubtitle.frame=frame3;
            [self.delete removeFromSuperview];
            self.delete=nil;
        }];
    }
}

-(void) toggleToEdit {

    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        [self removeGestureRecognizer:gesture];
    }
    CGRect frame0=self.recipeImage.frame;
    frame0.origin.x+=18;
    
    
    CGRect frame1=self.recipeTitle.frame;
    frame1.origin.x+=18;
    
    
    CGRect frame2=self.recipeSubtitle.frame;
    frame2.origin.x+=18;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.recipeImage.frame=frame0;
        self.recipeTitle.frame=frame1;
        self.recipeSubtitle.frame=frame2;
        self.arrow.alpha=0.0;
        self.deleteSign.alpha=1;
    } completion:^(BOOL finished) {
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleToSelected)];
        tap.numberOfTapsRequired=1;
        [self addGestureRecognizer:tap];
    }];
}

-(void) toggleToNormal {
    
    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        [self removeGestureRecognizer:gesture];
    }
    CGRect frame0=self.recipeImage.frame;
    frame0.origin.x-=18;
    
    
    CGRect frame1=self.recipeTitle.frame;
    frame1.origin.x-=18;
    
    
    CGRect frame2=self.recipeSubtitle.frame;
    frame2.origin.x-=18;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.recipeImage.frame=frame0;
        self.recipeTitle.frame=frame1;
        self.recipeSubtitle.frame=frame2;
        self.arrow.alpha=1.0;
        self.deleteSign.alpha=0.0;
    } completion:^(BOOL finished) {
        UISwipeGestureRecognizer *swipeLeft=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
        swipeLeft.direction=UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swipeLeft];
        
        UISwipeGestureRecognizer *swipeRight=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
        swipeRight.direction=UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:swipeRight];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        tap.numberOfTapsRequired=1;
        [self addGestureRecognizer:tap];
        
    }];
}

-(void) toggleToSelected {
    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        [self removeGestureRecognizer:gesture];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.recipeImage.alpha=0.4;
        self.recipeTitle.alpha=0.4;
        self.recipeSubtitle.alpha=0.4;
        self.deleteSign.transform=CGAffineTransformMakeRotation(DegreesToRadians(90));
    } completion:^(BOOL finished) {
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleToDeselected)];
        tap.numberOfTapsRequired=1;
        [self addGestureRecognizer:tap];
        if([self.delegate respondsToSelector:@selector(addToRemoveList:)]) {
            [self.delegate addToRemoveList:self.recipe.contentId];
        }
    }];
    
}

-(void) toggleToDeselected {
    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        [self removeGestureRecognizer:gesture];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.recipeImage.alpha=1;
        self.recipeTitle.alpha=1;
        self.recipeSubtitle.alpha=1;
        self.deleteSign.transform=CGAffineTransformMakeRotation(DegreesToRadians(0));
    } completion:^(BOOL finished) {
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleToSelected)];
        tap.numberOfTapsRequired=1;
        [self addGestureRecognizer:tap];
        if([self.delegate respondsToSelector:@selector(removeFromRemoveList:)]) {
            [self.delegate removeFromRemoveList:self.recipe.contentId];
        }
    }];
    
}

@end
