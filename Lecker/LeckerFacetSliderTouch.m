//
//  LeckerFacetSliderTouch.m
//  Lecker
//
//  Created by Naujeck, Marcel on 27.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerFacetSliderTouch.h"

@interface LeckerFacetSliderTouch()
@property UIImageView *touchButton;
@property int maxValue;
@property int minValue;
@property int minX;
@property int maxX;
@property int intervall;
@end

@implementation LeckerFacetSliderTouch


- (id)initWithFrame:(CGRect)frame minX:(int) minX maxX:(int) maxX minValue:(int) minValue maxValue:(int) maxValue intervall:(int)
intervall{
    self = [super initWithFrame:frame];
    if (self) {
        self.maxValue=maxValue;
        self.minValue=minValue;
        self.minX=minX;
        self.maxX=maxX;
        self.intervall=intervall;
        self.userInteractionEnabled=YES;
        self.touchButton=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"schieberegler_anfasser.png"]];
        self.touchButton.center=CGPointMake(self.minX,frame.size.height/2);
        [self addSubview:self.touchButton];
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self doTouchWithTouch: [[touches allObjects] objectAtIndex:0]];
    if([self.delegate respondsToSelector:@selector(disableScrolling)]) {
        [self.delegate disableScrolling];
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [self doTouchWithTouch: [[touches allObjects] objectAtIndex:0]];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
   [self doTouchWithTouch: [[touches allObjects] objectAtIndex:0]];
    if([self.delegate respondsToSelector:@selector(enableScrolling)]) {
        [self.delegate enableScrolling];
    }
}

-(void) doTouchWithTouch:(UITouch*) touch {
    CGPoint center=self.touchButton.center;
    int pointX=[touch locationInView:self].x;
    
    if(pointX>=self.minX && pointX<=self.maxX) {
        NSLog(@"%d",pointX);
        center.x=pointX;
        self.touchButton.center=center;
        
        int actualValue=((pointX-10.0)/floor((self.maxX-10.0)-((self.maxX-10.0)/self.intervall)))*(self.maxValue-self.minValue)+self.minValue;
        if (actualValue>self.maxValue) actualValue=self.maxValue;
        if([self.delegate respondsToSelector:@selector(sliderChangeValue:onXPositon:)]) {
            [self.delegate sliderChangeValue:((int)(actualValue/self.intervall))*self.intervall onXPositon:pointX];
        }
    }
}


@end
