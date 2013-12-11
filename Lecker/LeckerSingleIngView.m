//
//  LeckerSingleIngView.m
//  Lecker
//
//  Created by Naujeck, Marcel on 18.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerSingleIngView.h"

@interface LeckerSingleIngView()
@property BOOL isTapped;
@property UIImageView *rake;
@property NSString *ingText;
@end

@implementation LeckerSingleIngView

- (id)initWithFrame:(CGRect)frame andIngredients:(NSString*) ing andOutPutText:(NSString*) outputtext
{
    self = [super initWithFrame:frame];
    if (self) {
        self.ingText=ing;
        CGRect labelFrame=self.bounds;
        labelFrame.origin.x+=20;
        labelFrame.size.width=260;
        self.ingLabel=[[UILabel alloc] initWithFrame:labelFrame];
        self.ingLabel.text=outputtext;
        self.ingLabel.font=[UIFont fontWithName:@"DroidSans" size:14];
        self.ingLabel.adjustsFontSizeToFitWidth=NO;
        self.ingLabel.numberOfLines=0;
        self.ingLabel.lineBreakMode=NSLineBreakByWordWrapping;
        self.ingLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:self.ingLabel];
        [self.ingLabel sizeToFit];
        UIImageView *circle=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kreis.png"]];
        CGRect cFrame=circle.frame;
        cFrame.origin.x=0;
        cFrame.origin.y=2;
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
