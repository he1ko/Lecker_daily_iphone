//
//  LeckerSingleFacetView.m
//  Lecker
//
//  Created by Naujeck, Marcel on 26.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerSingleFacetView.h"

@interface LeckerSingleFacetView()
@property BOOL isTapped;
@property UIImageView *rake;
@property NSString *ingText;
@end

@implementation LeckerSingleFacetView

- (id)initWithFrame:(CGRect)frame andDataValue:(NSString*) value andOutPutText:(NSString*) outputtext
{
    self = [super initWithFrame:frame];
    if (self) {
        self.ingText=value;
        CGRect labelFrame=self.bounds;
        labelFrame.origin.x+=20;
        labelFrame.size.width=frame.size.width-20;
        self.ingLabel=[[UILabel alloc] initWithFrame:labelFrame];
        self.ingLabel.text=outputtext;
        self.ingLabel.font=[UIFont fontWithName:@"DroidSans" size:15];
        self.ingLabel.adjustsFontSizeToFitWidth=NO;
        self.ingLabel.numberOfLines=0;
        self.ingLabel.lineBreakMode=NSLineBreakByWordWrapping;
        self.ingLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:self.ingLabel];
        
        UIImageView *circle=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kreis.png"]];
        CGRect cFrame=circle.frame;
        cFrame.origin.x=0;
        cFrame.origin.y=3;
        circle.frame=cFrame;
        circle.userInteractionEnabled=YES;
        [self addSubview:circle];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(isTapped:)];
        tap.numberOfTapsRequired=1;
        [self addGestureRecognizer:tap];
        
        self.rake=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"haken.png"]];
        cFrame=self.rake.frame;
        cFrame.origin.x=0;
        cFrame.origin.y=-2;
        self.rake.frame=cFrame;
        self.rake.userInteractionEnabled=NO;
        
        self.isTapped=NO;

    }
    return self;
}




-(void) isTapped:(UITapGestureRecognizer*) tap {
    if(self.isTapped) {
        [self.rake removeFromSuperview];
        if([self.delegate respondsToSelector:@selector(ingredientsRemoveFromList:)]) {
            [self.delegate ingredientsRemoveFromList:self.ingText];
        }
    } else {
        [self addSubview:self.rake];
        if([self.delegate respondsToSelector:@selector(ingredientsAddToList:)]) {
            [self.delegate ingredientsAddToList:self.ingText];
        }
    }
    self.isTapped=!self.isTapped;
}

-(void) unTap {
    [self.rake removeFromSuperview];
    self.isTapped=NO;
    
}

@end
