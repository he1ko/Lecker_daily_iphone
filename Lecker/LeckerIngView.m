//
//  LeckerIngView.m
//  Lecker
//
//  Created by Naujeck, Marcel on 08.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerIngView.h"
#import "LeckerPreviewImage.h"
#import "LeckerTools.h"
#import "LeckerFaceBookLikeButton.h"
#import <Social/Social.h>


@interface LeckerIngView()
@property UIView *textView;
@property LeckerPreviewImage *prevImage;
@property UIImageView *patch1;
@property (nonatomic)  NSMutableSet *toBasketSet;
@property UIScrollView *contentScrollView;
@property UIImageView *addButtonView;
@property UIView *tmpView;
@end

@implementation LeckerIngView
@synthesize toBasketSet=_toBasketSet;

-(NSMutableSet*) toBasketSet {
    if(!_toBasketSet) _toBasketSet=[[NSMutableSet alloc] init];
    return _toBasketSet;
}

- (id)initWithFrame:(CGRect)frame recipe:(LeckerSingleRecipeDetailModel*) recipe andImage:(UIImage*) image
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentScrollView=[[UIScrollView alloc] initWithFrame:self.bounds];
        
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
        frame.origin.y=bgMitte.frame.origin.y+bgMitte.frame.size.height-frame.size.height;
        frame.origin.x=13;
        breakline.frame=frame;
        
        frame=self.textView.frame;
        frame.size.width=314;
        frame.origin.x=2;
        frame.size.height=100;
        frame.origin.y=70;
        self.textView.frame=frame;
        [self.contentScrollView addSubview:self.textView];
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
        [self.contentScrollView addSubview:patch2];
        
        [self addList:recipe.ingList onOffset:bgMitte.frame.origin.y+bgMitte.frame.size.height];
        [self.textView addSubview:breakline];
        [self addSubview:self.contentScrollView];
        
        self.addButtonView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"auf_einkaufszettel.png"]];
        frame=self.addButtonView.frame;
        frame.origin.x=320;
        frame.origin.y=self.bounds.size.height-frame.size.height-10;
        self.addButtonView.frame=frame;
        self.addButtonView.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addtoShoppingList:)];
        tap.numberOfTapsRequired=1;
        [self.addButtonView addGestureRecognizer:tap];
        
        UILabel *buttonText=[[UILabel alloc] initWithFrame:self.addButtonView.bounds];
        buttonText.font=[UIFont fontWithName:@"TimesNewRomanPSMT" size:9];
        buttonText.numberOfLines=3;
        buttonText.text=@"Auswahl zum Einkaufszettel hinzufügen";
        buttonText.backgroundColor=[UIColor clearColor];
        buttonText.textColor=[LeckerTools colorFromHexString:@"5cacbd"];
        frame=buttonText.frame;
        frame.origin.x+=35;
        frame.size.width-=38;
        buttonText.frame=frame;
        [self.addButtonView addSubview:buttonText];
        
        UIButton *facebook=[UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image=[UIImage imageNamed:@"Facebook_teilen.png"];
        [facebook setImage:image forState:UIControlStateNormal];
        frame=facebook.frame;
        frame.size.height=image.size.height;
        frame.size.width=image.size.width;
        frame.origin.x=self.prevImage.frame.origin.x+self.prevImage.frame.size.width+5;
        frame.origin.y=self.prevImage.frame.origin.y+self.prevImage.frame.size.height-frame.size.height;
        facebook.frame=frame;
        [self.contentScrollView addSubview:facebook];
        [facebook addTarget:self action:@selector(facebookPressed) forControlEvents:UIControlEventTouchDown];

        
        [self.contentScrollView addSubview:self.prevImage];
        [self.contentScrollView addSubview:self.patch1];
        
    }
    return self;
}

-(void) facebookPressed {
    if([self.delegate respondsToSelector:@selector(facebookShare)]) {
        [self.delegate facebookShare];
    }
}


-(void) addList:(NSArray*)list onOffset:(int)offset {
    int startIndex=0;
    self.tmpView=[[UIView alloc] initWithFrame:CGRectMake(self.textView.frame.origin.x,offset, self.textView.frame.size.width, 0)];
    for (NSString *ing in list) {
        CGSize stringSize = [ing
                             sizeWithFont:[UIFont fontWithName:@"DroidSans" size:14]
                             constrainedToSize:CGSizeMake(280, CGFLOAT_MAX)
                             lineBreakMode:NSLineBreakByWordWrapping];
        LeckerSingleIngView *tmpLabel=[[LeckerSingleIngView alloc] initWithFrame:CGRectMake(30, startIndex, 260, stringSize.height*1.7) andIngredients:ing andOutPutText:ing];
        startIndex=tmpLabel.frame.origin.y+tmpLabel.frame.size.height;
        tmpLabel.delegate=self;
        [self.tmpView addSubview:tmpLabel];
    }
    CGRect frame=self.tmpView.frame;
    frame.size.height=startIndex;
    self.tmpView.frame=frame;
    
    UIImageView *bgMitte=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"karopapier_mitte.png"]];
    UIImageView *tmpUnten=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"karopapier_unten.png"]];
    int counter=(startIndex-tmpUnten.frame.size.height)/bgMitte.frame.size.height;
    for (int i=0; i<=counter; i++) {
        UIImageView *tmpMitte=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"karopapier_mitte.png"]];
        tmpMitte.frame=CGRectMake(0, offset+(bgMitte.frame.size.height*i), bgMitte.frame.size.width, bgMitte.frame.size.height);
        [self.textView addSubview:tmpMitte];
    }
    
    tmpUnten.frame=CGRectMake(0, offset+(bgMitte.frame.size.height*(counter+1)), tmpUnten.frame.size.width, tmpUnten.frame.size.height);
    [self.textView addSubview:tmpUnten];
    
    [self.textView addSubview:self.tmpView];
    [self.textView sizeToFit];
    frame=self.textView.frame;
    frame.size.height=offset+self.tmpView.frame.size.height+10;
    self.textView.frame=frame;
    self.contentScrollView.contentSize=CGSizeMake(320, self.textView.frame.origin.y+self.textView.frame.size.height);
    NSLog(@"LeckerIngView %f %f",self.textView.frame.origin.y,self.textView.frame.size.height);
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

-(void) ingredientsAddToList:(NSString *)ing {
    [self.toBasketSet addObject:ing];
    if(![self.addButtonView isDescendantOfView:self]) {
        CGRect frame=self.addButtonView.frame;
        frame.origin.x=320;
        self.addButtonView.frame=frame;
        [self addSubview:self.addButtonView];
        frame.origin.x=320-frame.size.width;
        [UIView animateWithDuration:0.4f animations:^{
            self.addButtonView.frame=frame;
        } completion:^(BOOL finished) {

        }];
    }
}

-(void) ingredientsRemoveFromList:(NSString *)ing {
    [self.toBasketSet removeObject:ing];
    if(self.toBasketSet.count==0) {
        CGRect frame=self.addButtonView.frame;
        frame.origin.x=320;
        [UIView animateWithDuration:0.4f animations:^{
            self.addButtonView.frame=frame;
        } completion:^(BOOL finished) {
            [self.addButtonView removeFromSuperview];
        }];
        
    }
}

-(void) addtoShoppingList:(UITapGestureRecognizer*) tap {
    
    for (UIView *view in self.tmpView.subviews) {
        if([view respondsToSelector:@selector(unTap)]) {
            [view performSelector:@selector(unTap)];
        }
    }
    if([self.delegate respondsToSelector:@selector(addIngredientsSet:)]) {
        [self.delegate addIngredientsSet:self.toBasketSet.copy];
    }
    [self.toBasketSet removeAllObjects];
    
    CGRect frame=self.addButtonView.frame;
    frame.origin.x=320;
    [UIView animateWithDuration:0.4f animations:^{
        self.addButtonView.frame=frame;
    } completion:^(BOOL finished) {
        [self.addButtonView removeFromSuperview];
    }];
}


@end
