//
//  LeckerFacetSliderView.m
//  Lecker
//
//  Created by Naujeck, Marcel on 26.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerFacetSliderView.h"
#import "LeckerTools.h"

@interface LeckerFacetSliderView()
@property UIImageView *slider;
@property LeckerFacetSliderTouch *sliderTouch;
@property UILabel *sliderlabel;
@property NSString *name;
@property int intervalMin;
@property int intervalMax;
@property int lastValue;
@property UIView *bgCover;

@end

@implementation LeckerFacetSliderView

- (id)initWithFrame:(CGPoint)point backgroundImage:(UIImage*) image intervalStart:(int) intervalStart intervalEnd:(int) intervalEnd unit:(NSString*) unittext interval:(int) interval slidername:(NSString*) name
{
    self = [super init];
    if (self) {
        self.intervalMin=intervalStart;
        self.intervalMax=intervalEnd;
        self.name=name;
        self.userInteractionEnabled=YES;
        UIImageView *bgView=[[UIImageView alloc] initWithImage:image];
        CGRect frame=self.frame;
        frame.origin.x=point.x;
        frame.origin.y=point.y;
        frame.size.height=image.size.height;
        frame.size.width=image.size.width;
        self.frame=frame;
        [self addSubview:bgView];
        
        self.bgCover=[[UIView alloc] initWithFrame:bgView.frame];
        self.bgCover.backgroundColor=[UIColor whiteColor];
        self.bgCover.alpha=0.8;
        [self addSubview:self.bgCover];
        
        
        self.slider=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"schieberegler.png"]];
        self.slider.userInteractionEnabled=YES;
        self.slider.contentMode=UIViewContentModeCenter;
        frame=self.slider.frame;
        frame.origin.x=(self.frame.size.width/2-frame.size.width/2)-10;
        frame.origin.y+=40;
        frame.size.height+=40;
        frame.size.width+=20;
        self.slider.frame=frame;
        [self addSubview:self.slider];
        
        UILabel *minLabel=[[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x, self.slider.frame.origin.y-15, 60, 15)];
        minLabel.center=CGPointMake(self.slider.frame.origin.x+10, self.slider.frame.origin.y+5);
        minLabel.backgroundColor=[UIColor clearColor];
        minLabel.textColor=[UIColor grayColor];
        minLabel.text=[NSString stringWithFormat:@"%d",intervalStart];
        minLabel.textAlignment=NSTextAlignmentCenter;
        minLabel.font=[UIFont fontWithName:@"DroidSans" size:15];
        [self addSubview:minLabel];
        
        UILabel *maxLabel=[[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x, self.bounds.size.height-30, frame.size.width, 20)];
        maxLabel.center=CGPointMake(self.slider.frame.origin.x+self.slider.frame.size.width-10, self.slider.frame.origin.y+5);
        maxLabel.backgroundColor=[UIColor clearColor];
        maxLabel.textColor=[UIColor grayColor];
        maxLabel.text=[NSString stringWithFormat:@"%d",intervalEnd];
        maxLabel.textAlignment=NSTextAlignmentCenter;
        maxLabel.font=[UIFont fontWithName:@"DroidSans" size:15];
        [self addSubview:maxLabel];
        

        
        UILabel *unit=[[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x, self.bounds.size.height-30, frame.size.width, 20)];
        unit.backgroundColor=[UIColor clearColor];
        unit.textColor=[UIColor grayColor];
        unit.text=unittext;
        unit.textAlignment=NSTextAlignmentRight;
        unit.font=[UIFont fontWithName:@"DroidSans" size:15];
        [self addSubview:unit];
        
        frame=self.slider.bounds;
        frame.origin.x+=10;
        frame.size.width-=10;
        
        self.sliderTouch=[[LeckerFacetSliderTouch alloc] initWithFrame:self.slider.bounds minX:frame.origin.x maxX:frame.size.width minValue:intervalStart maxValue:intervalEnd intervall:interval];
        [self.slider addSubview:self.sliderTouch];
        self.sliderTouch.delegate=self;
        
        self.sliderlabel=[[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x, self.bounds.size.height-30, 40, 20)];
        self.sliderlabel.center=CGPointMake(self.sliderTouch.frame.origin.x+12, self.slider.frame.origin.y+5);
        self.sliderlabel.backgroundColor=[UIColor clearColor];
        self.sliderlabel.textColor=[LeckerTools colorFromHexString:@"#48a6ba"];
        self.sliderlabel.text=[NSString stringWithFormat:@"%d",intervalStart];
        self.sliderlabel.textAlignment=NSTextAlignmentCenter;
        self.sliderlabel.alpha=0;
        self.lastValue=intervalStart;
        [self addSubview:self.sliderlabel];
    }
    return self;
}

-(void) sliderChangeValue:(int)value onXPositon:(int)posX
{
    if(value>self.intervalMin) {
        [UIView animateWithDuration:0.2 animations:^{
            self.bgCover.alpha=0;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.bgCover.alpha=0.8;
        } completion:^(BOOL finished) {
            
        }];
    }
    
    if(value==self.intervalMin) {
        [UIView animateWithDuration:0.2 animations:^{
            self.sliderlabel.alpha=0;
        } completion:^(BOOL finished) {
            
        }];
    } else if (value==self.intervalMax) {
        [UIView animateWithDuration:0.2 animations:^{
            self.sliderlabel.alpha=0;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        if (posX<=50) {
            self.sliderlabel.alpha=((float)posX)/50.0;
        } else if(posX>=(self.sliderTouch.frame.origin.x+self.sliderTouch.frame.size.width-50)) {
            self.sliderlabel.alpha=((self.sliderTouch.frame.origin.x+self.sliderTouch.frame.size.width)-(float)posX)/50.0;
        } else {
            self.sliderlabel.alpha=1;
        }
    }
    
    self.sliderlabel.text=[NSString stringWithFormat:@"%d",value];
    self.sliderlabel.center=CGPointMake(self.sliderTouch.frame.origin.x+posX+12, self.slider.frame.origin.y+5);
    

    
    if([self.delegate respondsToSelector:@selector(sliderChangeValueTo:withName:)]) {
        [self.delegate sliderChangeValueTo:value withName:self.name];
    }
 
}

-(void) disableScrolling {
    ((UIScrollView*)self.superview).scrollEnabled=NO;
}

-(void) enableScrolling {
    ((UIScrollView*)self.superview).scrollEnabled=YES;
}

@end
