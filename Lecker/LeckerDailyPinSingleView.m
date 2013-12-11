//
//  LeckerDailyPinSingleView.m
//  Lecker
//
//  Created by Naujeck, Marcel on 16.04.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerDailyPinSingleView.h"
#import <QuartzCore/QuartzCore.h>
#include <stdlib.h>

@interface LeckerDailyPinSingleView()
@property LeckerSingleRecipeOverviewModel *model;
@property int pos;
@end

@implementation LeckerDailyPinSingleView


- (id)initWithFrame:(CGRect)frame andDetailData:(LeckerSingleRecipeOverviewModel*) model andPos:(int) pos
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pos=pos;
        self.userInteractionEnabled=YES;
        self.backgroundColor=[UIColor whiteColor];
        /*self.layer.shadowColor=[UIColor blackColor].CGColor;
        self.layer.shadowOffset=CGSizeMake(1, 1);
        self.layer.shadowRadius=2;
        self.layer.shadowOpacity=0.5;*/
        
        self.model=model;
        model.delegate=self;
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed)];
        tap.numberOfTapsRequired=1;
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void) processInit {
    if(self.model.thumbnail==nil) {
        [self.model loadThumbnail];
    } else {
        [self loadingFinished];
    }
}

-(void) loadingFinished {
    UIImageView *imageView=[[UIImageView alloc] initWithImage:self.model.thumbnail];
    imageView.userInteractionEnabled=NO;
    CGRect frame=imageView.frame;
    frame.origin.x=self.bounds.size.width/2-frame.size.width/2;
    frame.origin.y=self.bounds.origin.y+3;
    imageView.frame=frame;
    frame=self.frame;
    frame.size.height=imageView.frame.size.height+6;
    self.frame=frame;
    [self addSubview:imageView];
    
    switch (self.pos) {
        case 0: {
            UIImageView *tape=[[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"maskingtape1.png"].CGImage scale:3.0f orientation:nil]];
            CGRect tmp=tape.frame;
            tmp.origin.x-=5;
            tmp.origin.y=self.bounds.size.height-tmp.size.height+5;
            tape.frame=tmp;
            [self addSubview:tape];
        }
        break;
        case 1: {
            UIImageView *tape=[[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"maskingtape2.png"].CGImage scale:3.0f orientation:nil]];
            CGRect tmp=tape.frame;
            tmp.origin.x=self.bounds.size.width-tmp.size.width+5;
            tmp.origin.y-=5;
            tape.frame=tmp;
            [self addSubview:tape];
        }
        break;
        case 2: {
            UIImageView *tape=[[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"maskingtape4.png"].CGImage scale:3.0f orientation:nil]];
            CGRect tmp=tape.frame;
            tmp.origin.x=self.bounds.size.width-tmp.size.width+5;
            tmp.origin.y=self.bounds.size.height-tmp.size.height+8;
            tape.frame=tmp;
            [self addSubview:tape];
        }
        break;
        case 3: {
            UIImageView *tape=[[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"maskingtape3.png"].CGImage scale:3.0f orientation:nil]];
            CGRect tmp=tape.frame;
            tmp.origin.x-=5;
            tmp.origin.y-=7;
            tape.frame=tmp;
            [self addSubview:tape];
        }
            break;
        default: {
            
        }
        break;
    }
    
    if([self.delegate respondsToSelector:@selector(viewReady:)]) {
        [self.delegate viewReady:self];
    }
}

-(void) imagePressed {
    if([self.delegate respondsToSelector:@selector(recipePressedWithId:andImage:)]) {
        [self.delegate recipePressedWithId:self.model.contendId andImage:self.model.thumbnail];
    }
}


@end
