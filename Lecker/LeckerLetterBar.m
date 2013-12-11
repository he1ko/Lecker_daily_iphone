//
//  LeckerLetterBar.m
//  Lecker
//
//  Created by Naujeck, Marcel on 02.04.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerLetterBar.h"
#import <QuartzCore/QuartzCore.h>

@implementation LeckerLetterBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        float distanz=(self.bounds.size.height-6.0)/26.0;
        for (int i=65;i<=90;i++) {
            self.layer.borderColor=[UIColor blackColor].CGColor;
            self.layer.borderWidth=1;
            self.layer.cornerRadius=5;
            self.layer.shadowColor=[UIColor blackColor].CGColor;
            self.layer.shadowOpacity=0.8;
            self.layer.shadowRadius=2;
            self.layer.shadowOffset=CGSizeMake(1, 1);
            self.backgroundColor=[UIColor whiteColor];
            UILabel *charLabel=[[UILabel alloc] initWithFrame:CGRectMake(3, 3.0+(distanz*(((float)i)-65.0)), frame.size.width-6, distanz)];
            charLabel.text=[NSString stringWithFormat:@"%c", i];
            charLabel.backgroundColor=[UIColor clearColor];
            charLabel.font=[UIFont fontWithName:@"DroidSans" size:9];
            charLabel.textAlignment=NSTextAlignmentCenter;
            
            [self addSubview:charLabel];
        }
        
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self doTouchWithTouch:[[touches allObjects] objectAtIndex:0]];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch=[[touches allObjects] objectAtIndex:0];
    float yPosition=[touch locationInView:self].y;
    if (yPosition>3 && yPosition<self.bounds.size.height-6) {
        [self doTouchWithTouch:[[touches allObjects] objectAtIndex:0]];
    }
}

-(void) doTouchWithTouch:(UITouch*) touch {
    float yPosition=[touch locationInView:self].y;
    int interval=(yPosition-3.0)/((self.bounds.size.height-6.0)/26.0);
    if([self.delegate respondsToSelector:@selector(letterTouched:)]) {
        [self.delegate letterTouched:65+interval];
    }
    
}

@end
