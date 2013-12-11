//
//  LeckerAdView.m
//  Lecker
//
//  Created by Naujeck, Marcel on 11.04.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerAdView.h"




@interface LeckerAdView()
@property SASBannerView *bannerView;

@end

@implementation LeckerAdView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *header=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blaueKarte.png"]];
        CGRect frame=header.frame;
        frame.origin.x=10;
        frame.origin.y=10;
        header.frame=frame;
        [self addSubview:header];
        
        UIImageView *recipeSticker=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rezeptzettel.png"]];
        frame=recipeSticker.frame;
        frame.origin.x=10;
        frame.origin.y=347;
        recipeSticker.frame=frame;
        recipeSticker.userInteractionEnabled=YES;
        [self addSubview:recipeSticker];
        UITapGestureRecognizer *tap2=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureTapped:)];
        tap2.numberOfTapsRequired=1;
        [recipeSticker addGestureRecognizer:tap2];
        

        UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(18, 16, 230, 40)];
        title.text=@"Werbung";
        title.font=[UIFont fontWithName:@"DroidSans" size:14];
        title.textColor=[UIColor whiteColor];
        title.backgroundColor=[UIColor clearColor];
        title.numberOfLines=1;
        [self addSubview:title];
 
        UIImageView *recipeLabelImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rahmen2.png"]];
        frame=recipeLabelImage.frame;
        frame.origin.x=6;
        frame.origin.y=55;
        recipeLabelImage.frame=frame;
        [self addSubview:recipeLabelImage];
        self.userInteractionEnabled=YES;
        
    }
    return self;
}

-(void) addBannerToView:(SASBannerView*) bannerView {
    self.bannerView=bannerView;
    self.bannerView.userInteractionEnabled=NO;
    [self addSubview:self.bannerView];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touched");
}




@end
