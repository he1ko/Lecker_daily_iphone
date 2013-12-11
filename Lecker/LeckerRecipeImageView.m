//
//  LeckerRecipeImageView.m
//  Lecker
//
//  Created by Naujeck, Marcel on 15.04.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerRecipeImageView.h"

@interface LeckerRecipeImageView()
@property int xPos;
@property int yPos;
@end

@implementation LeckerRecipeImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled=YES;
    }
    return self;
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *tmpTouch = [[touches allObjects] objectAtIndex:0];
    self.xPos=[tmpTouch locationInView:tmpTouch.window].x;
    self.yPos=[tmpTouch locationInView:tmpTouch.window].y;
    NSLog(@"Touch Start %d %d",self.xPos,self.yPos);
    [self.superview.superview.nextResponder touchesBegan:touches withEvent:event];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.superview.superview.nextResponder touchesMoved:touches withEvent:event];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *tmpTouch = [[touches allObjects] objectAtIndex:0];
    NSLog(@"Touch End %d %d",abs(self.xPos-[tmpTouch locationInView:tmpTouch.window].x),abs(self.yPos-[tmpTouch locationInView:tmpTouch.window].y));
    if(abs(self.xPos-[tmpTouch locationInView:tmpTouch.window].x)<20 && abs(self.yPos-[tmpTouch locationInView:tmpTouch.window].y)<20) {
        NSLog(@"Touch Fire %d %d",abs(self.xPos-[tmpTouch locationInView:tmpTouch.window].x),abs(self.yPos-[tmpTouch locationInView:tmpTouch.window].y));
        if([self.delegate respondsToSelector:@selector(pictureTapped)]) {
            [self.delegate pictureTapped];
            [self.superview.superview.nextResponder touchesEnded:touches withEvent:event];
        }
    } else {
        [self.superview.superview.nextResponder touchesEnded:touches withEvent:event];
    }
}




@end
