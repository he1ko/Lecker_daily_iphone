//
//  LeckerPrepStepsView.m
//  Lecker
//
//  Created by Naujeck, Marcel on 08.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerPrepStepsView.h"
#import "LeckerPreviewImage.h"
#import "LeckerFaceBookLikeButton.h"

@interface LeckerPrepStepsView()
@property UIView *textView;
@property LeckerPreviewImage *prevImage;
@property UIImageView *patch1;
@end

@implementation LeckerPrepStepsView

- (id)initWithFrame:(CGRect)frame recipe:(LeckerSingleRecipeDetailModel*) recipe andImage:(UIImage*) image
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textView=[[UIView alloc] init];
        UIImageView *bgHeader=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"karopapier_oben.png"]];
        CGRect frame=bgHeader.frame;
        [self.textView addSubview:bgHeader];
        UIImageView *bgMitte=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"karopapier_mitte.png"]];
        frame.origin.y+=frame.size.height;
        frame.size.height=bgMitte.frame.size.height;
        bgMitte.frame=frame;
        [self.textView addSubview:bgMitte];
        UILabel *recipeTitle=[[UILabel alloc] init];
        recipeTitle.text=recipe.title;
        recipeTitle.font=[UIFont fontWithName:@"DroidSans" size:16];
        recipeTitle.adjustsFontSizeToFitWidth=NO;
        recipeTitle.numberOfLines=0;
        recipeTitle.lineBreakMode=NSLineBreakByWordWrapping;
        recipeTitle.backgroundColor=[UIColor clearColor];
        CGSize stringSize = [recipeTitle.text sizeWithFont:recipeTitle.font constrainedToSize:CGSizeMake(280, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        frame=CGRectMake(15, 65, 280, 0);
        frame.size=stringSize;
        recipeTitle.frame=frame;
        [self.textView addSubview:recipeTitle];
        UIImageView *breakline=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trennlinie.png"]];
        frame=breakline.frame;
        frame.origin.y=recipeTitle.frame.origin.y+recipeTitle.frame.size.height;
        frame.origin.x=13;
        breakline.frame=frame;
        
        frame=self.textView.frame;
        frame.size.width=314;
        frame.origin.x=2;
        frame.size.height=100;
        frame.origin.y=70;
        self.textView.frame=frame;
        [self addSubview:self.textView];
        self.prevImage=[[LeckerPreviewImage alloc] initWithFrame:CGRectMake(6, 45, 70, 70) withImage:image];
        
        
        self.prevImage.userInteractionEnabled=YES;
        UITapGestureRecognizer *imageTapped=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
        imageTapped.numberOfTapsRequired=1;
        [self.prevImage addGestureRecognizer:imageTapped];
        
        self.patch1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"maskingtape3.png"]];
        frame=self.patch1.frame;
        frame.origin.y=100;
        frame.origin.x=-50;
        self.patch1.frame=frame;
        
        
        UIImageView *patch2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"maskingtape2.png"]];
        frame=patch2.frame;
        frame.origin.y=70;
        frame.origin.x=237;
        patch2.frame=frame;
        patch2.transform=CGAffineTransformMakeRotation(0.3);
        [self addSubview:patch2];
        
        [self addSteps:recipe.prepSteps onOffset:bgMitte.frame.origin.y+bgMitte.frame.size.height];
        [self.textView addSubview:breakline];
        
        frame=breakline.frame;
        frame.size.height=30;
        frame.origin.y+=3;
        frame.origin.x+=61;
        
        UIButton *facebook=[UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image=[UIImage imageNamed:@"Facebook_teilen.png"];
        [facebook setImage:image forState:UIControlStateNormal];
        frame=facebook.frame;
        frame.size.height=image.size.height;
        frame.size.width=image.size.width;
        frame.origin.x=self.prevImage.frame.origin.x+self.prevImage.frame.size.width+5;
        frame.origin.y=self.prevImage.frame.origin.y+self.prevImage.frame.size.height-frame.size.height;
        facebook.frame=frame;
        [self addSubview:facebook];
        [facebook addTarget:self action:@selector(facebookPressed) forControlEvents:UIControlEventTouchDown];
        
        [self addSubview:self.prevImage];
        [self addSubview:self.patch1];
        
    }
    return self;
}

-(void) facebookPressed {
    if([self.face_delegate respondsToSelector:@selector(facebookShare)]) {
        [self.face_delegate facebookShare];
    }
}


-(void) addSteps:(NSString*)prep onOffset:(int)offset {

    UIView *tmpView=[[UIView alloc] initWithFrame:CGRectMake(self.textView.frame.origin.x,offset, self.textView.frame.size.width, 0)];
    NSString *replaceString=[@"\n" stringByAppendingString:[prep stringByReplacingOccurrencesOfString:@"|| " withString:@"\n\n"]];
    UILabel *tmpLabel=[[UILabel alloc] init];
    tmpLabel.text=replaceString;
    tmpLabel.font=[UIFont fontWithName:@"DroidSans" size:14];
    tmpLabel.adjustsFontSizeToFitWidth=NO;
    tmpLabel.numberOfLines=0;
    tmpLabel.lineBreakMode=NSLineBreakByWordWrapping;
    tmpLabel.backgroundColor=[UIColor clearColor];
    CGSize stringSize = [tmpLabel.text sizeWithFont:tmpLabel.font constrainedToSize:CGSizeMake(280, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    //CGSize stringSize = [tmpLabel.text sizeWithFont:tmpLabel.font constrainedToSize:CGSizeMake(260.0f, 999999.0f)];
    tmpLabel.frame=CGRectMake(20, 0, 280, stringSize.height);
    [tmpView addSubview:tmpLabel];
    CGRect frame=tmpView.frame;
    frame.size.height=stringSize.height;
    tmpView.frame=frame;
    
    
    UIImageView *bgMitte=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"karopapier_mitte.png"]];
    int counter=(int)(frame.size.height/bgMitte.frame.size.height);
    for (int i=0; i<counter; i++) {
        UIImageView *tmpMitte=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"karopapier_mitte.png"]];
        tmpMitte.frame=CGRectMake(0, offset+(bgMitte.frame.size.height*i), bgMitte.frame.size.width, bgMitte.frame.size.height);
        [self.textView addSubview:tmpMitte];
    }
    
    UIImageView *tmpMitte=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"karopapier_unten.png"]];
    tmpMitte.frame=CGRectMake(0, offset+(bgMitte.frame.size.height*(counter)), tmpMitte.frame.size.width, tmpMitte.frame.size.height);
    [self.textView addSubview:tmpMitte];
    
    [self.textView addSubview:tmpView];
    [self.textView sizeToFit];
    frame=self.textView.frame;
    frame.size.height=offset+tmpView.frame.size.height+10;
    self.textView.frame=frame;
    self.contentSize=CGSizeMake(320, self.textView.frame.origin.y+self.textView.frame.size.height);
    NSLog(@"PrepStepsView %f %f",self.textView.frame.origin.y,self.textView.frame.size.height);
}


-(void) imageTapped:(UITapGestureRecognizer*) tap {
    [self.prevImage animateToBig];
    if (self.patch1.frame.origin.x==-50) {
        CGRect frame=self.patch1.frame;
        frame.origin.x=115;
        frame.origin.y=92;
        [UIView animateWithDuration:0.3f animations:^{
            self.patch1.frame=frame;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        CGRect frame=self.patch1.frame;
        frame.origin.x=-50;
        frame.origin.y=100;
        [UIView animateWithDuration:0.3f animations:^{
            self.patch1.frame=frame;
        } completion:^(BOOL finished) {
            
        }];
    }
}

@end
