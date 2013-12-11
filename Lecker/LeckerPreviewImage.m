//
//  LeckerPreviewImage.m
//  Lecker
//
//  Created by Naujeck, Marcel on 11.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerPreviewImage.h"

@interface LeckerPreviewImage()
@property UIImageView *recipeImage;
@property UIImageView *border;
@end

@implementation LeckerPreviewImage

- (id)initWithFrame:(CGRect)frame withImage:(UIImage*) image
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame=CGRectMake(frame.origin.x, frame.origin.y, 70, 70);
        self.border=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rahmen2.png"]];
        self.border.frame=self.bounds;
        [self addSubview:self.border];
        self.recipeImage=[[UIImageView alloc] initWithFrame:CGRectMake(3,3, 63, 63)];
        [self.recipeImage setImage:image];
        self.recipeImage.clipsToBounds=YES;
        self.recipeImage.contentMode=UIViewContentModeScaleAspectFill;
        [self addSubview:self.recipeImage];
    }
    return self;
}

-(void) animateToBig {
    if(self.frame.size.height!=300) {
        CGRect frame0=self.frame;
        frame0.origin.y+=60;
        frame0.size.height+=230;
        frame0.size.width+=230;
        CGRect frame1=self.border.frame;
        frame1.size.height=300;
        frame1.size.width=300;
        CGRect frame2=self.recipeImage.frame;
        frame2.origin.x=10;
        frame2.origin.y=9;
        frame2.size.height=277;
        frame2.size.width=277;
        [UIView animateWithDuration:0.3f animations:^{
            self.frame=frame0;
            self.border.frame=frame1;
            self.recipeImage.frame=frame2;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        CGRect frame0=self.frame;
        frame0.origin.y-=60;
        frame0.size.height-=230;
        frame0.size.width-=230;
        CGRect frame1=self.border.frame;
        frame1.size.height=70;
        frame1.size.width=70;
        CGRect frame2=self.recipeImage.frame;
        frame2.origin.x=3;
        frame2.origin.y=3;
        frame2.size.height=63;
        frame2.size.width=63;
        [UIView animateWithDuration:0.3f animations:^{
            self.frame=frame0;
            self.border.frame=frame1;
            self.recipeImage.frame=frame2;
        } completion:^(BOOL finished) {
            
        }];
    }

}






@end
