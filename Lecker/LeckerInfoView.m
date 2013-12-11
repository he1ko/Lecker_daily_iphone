//
//  LeckerInfoView.m
//  Lecker
//
//  Created by Naujeck, Marcel on 08.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerInfoView.h"
#import "LeckerPreviewImage.h"
#import "LeckerFaceBookLikeButton.h"


@interface LeckerInfoView()
@property UIView *textView;
@property LeckerPreviewImage *prevImage;
@property UIImageView *patch1;
@end

@implementation LeckerInfoView

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
        [self addSubview:self.patch1];
        
        UIImageView *patch2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"maskingtape2.png"]];
        frame=patch2.frame;
        frame.origin.y=70;
        frame.origin.x=237;
        patch2.frame=frame;
        patch2.transform=CGAffineTransformMakeRotation(0.3);
        [self addSubview:patch2];
        
        UIImageView *bgMitte1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"karopapier_mitte.png"]];
        frame=bgMitte1.frame;
        frame.origin.x=bgMitte.frame.origin.x;
        frame.origin.y=bgMitte.frame.origin.y+bgMitte.frame.size.height;
        bgMitte1.frame=frame;
        [self.textView addSubview:bgMitte1];
        
        UIImageView *bgMitte2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"karopapier_mitte.png"]];
        frame=bgMitte2.frame;
        frame.origin.x=bgMitte1.frame.origin.x;
        frame.origin.y=bgMitte1.frame.origin.y+bgMitte1.frame.size.height;
        bgMitte2.frame=frame;
        [self.textView addSubview:bgMitte2];
        
        UIImageView *bgUnten=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"karopapier_unten.png"]];
        frame=bgUnten.frame;
        frame.origin.x=bgMitte2.frame.origin.x;
        frame.origin.y=bgMitte2.frame.origin.y+bgMitte2.frame.size.height;
        bgUnten.frame=frame;
        [self.textView addSubview:bgUnten];
        [self.textView addSubview:breakline];
        
        UIImageView *human=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Mann-klein.png"]];
        frame=human.frame;
        frame.origin.y=240;
        frame.origin.x=50;
        frame.size.height/=2;
        frame.size.width/=2;
        human.frame=frame;
        [self addSubview:human];
        
        UIImageView *watch=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Uhr-Icon-groß.png"]];
        frame=watch.frame;
        frame.origin.y=320;
        frame.origin.x=46;
        frame.size.height/=2;
        frame.size.width/=2;
        watch.frame=frame;
        [self addSubview:watch];
        
        UILabel *proPortion=[[UILabel alloc] init];
        frame=proPortion.frame;
        frame.size.height=20;
        frame.size.width=100;
        frame.origin.y=240;
        frame.origin.x=100;
        proPortion.frame=frame;
        proPortion.text=@"Pro Portion:";
        proPortion.numberOfLines=0;
        proPortion.font=[UIFont fontWithName:@"DroidSans" size:16];
        proPortion.backgroundColor=[UIColor clearColor];
        [self addSubview:proPortion];
        
        UILabel *values=[[UILabel alloc] init];
        frame=values.frame;
        frame.size.height=45;
        frame.size.width=200;
        frame.origin.y=257;
        frame.origin.x=100;
        values.frame=frame;
        values.text=[@"" stringByAppendingFormat:@"ca. %@ kcal • E %@ g\nF %@ g • KH %@ g",recipe.kcal,recipe.protein,recipe.fat,recipe.carbs ];
        values.numberOfLines=0;
        values.font=[UIFont fontWithName:@"DroidSans" size:16];
        values.backgroundColor=[UIColor clearColor];
        [self addSubview:values];
        
        UILabel *time=[[UILabel alloc] init];
        frame=time.frame;
        frame.size.height=45;
        frame.size.width=200;
        frame.origin.y=320;
        frame.origin.x=100;
        time.frame=frame;
        time.text=[@"" stringByAppendingFormat:@"ca. %@ Minuten\n+ Wartezeit",recipe.prepTime];
        time.numberOfLines=0;
        time.font=[UIFont fontWithName:@"DroidSans" size:16];
        time.backgroundColor=[UIColor clearColor];
        [self addSubview:time];
        
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
    if([self.delegate respondsToSelector:@selector(facebookShare)]) {
        [self.delegate facebookShare];
    }
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
