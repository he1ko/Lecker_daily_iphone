//
//  LeckerSingleRecipeOverview.m
//  Lecker
//
//  Created by Naujeck, Marcel on 05.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerSingleRecipeOverview.h"
#import "LeckerTools.h"
//#import "AsyncImageView.h"

@interface LeckerSingleRecipeOverview()
@property LeckerRecipeImageView *recipeImageView;
@property UIImageView *favIconActive;
@property UIImageView *favIconInactive;
@property UIView *tmpFrame;
@property BOOL isFav;
@property UITapGestureRecognizer *inactiveTap;
@property UITapGestureRecognizer *activeTap;
@property UIImageView *recipeLabelImage;
@property UIImageView *recipeSticker;
@property BOOL bannerMode;
@property int display_offset;
@property UIView *activityView;
@property int recipeLabelImageHeight;
@property int recipeImageHeight;
@property int tmpFrameX;
@property int tmpFrameY;
@end

@implementation LeckerSingleRecipeOverview

@synthesize model=_model;

- (id)initWithFrame:(CGRect)frame recipeData:(LeckerSingleRecipeOverviewModel*) recipe isFav:(Boolean) isFav
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bannerMode=NO;
        self.model=recipe;
        self.display_offset=0;
        if ([LeckerTools isIPhone5]) {
            self.display_offset=35;
        }
        
        
        UITapGestureRecognizer *tap2=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureTapped)];
        tap2.numberOfTapsRequired=1;
        
        UITapGestureRecognizer *tap3=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureTapped)];
        tap3.numberOfTapsRequired=1;
        
        UIImageView *header=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blaueKarte.png"]];
        CGRect frame=header.frame;
        frame.origin.x=10;
        frame.origin.y=10+self.display_offset;
        header.frame=frame;
        header.userInteractionEnabled=YES;
        [self addSubview:header];
        
        [header addGestureRecognizer:tap3];
        
        self.recipeSticker=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rezeptzettel.png"]];
        frame=self.recipeSticker.frame;
        frame.origin.x=10;
        frame.origin.y=347+self.display_offset;
        self.recipeSticker.frame=frame;
        self.recipeSticker.userInteractionEnabled=YES;
        [self addSubview:self.recipeSticker];

        [self.recipeSticker addGestureRecognizer:tap2];
        
        NSString *devider = @"mit";
        NSArray *titleArray=[recipe.title componentsSeparatedByString:devider];
        if (titleArray.count==1)
        {
            devider = @"auf";
            titleArray=[recipe.title componentsSeparatedByString:devider];
        }
        
        UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(18, 16+self.display_offset, 230, 40)];
        title.text=[titleArray objectAtIndex:0];
        title.font=[UIFont fontWithName:@"DroidSans" size:14];
        title.textColor=[UIColor whiteColor];
        title.backgroundColor=[UIColor clearColor];
        title.numberOfLines=2;
        [self addSubview:title];
        
        if (titleArray.count>1) {
            frame=title.frame;
            frame.origin.y-=4;
            title.frame=frame;
            title.numberOfLines=1;
            UILabel *subtitle=[[UILabel alloc] initWithFrame:CGRectMake(18, 35+self.display_offset, 230, 20)];
            subtitle.text=[devider stringByAppendingString:[titleArray objectAtIndex:1]];
            subtitle.font=[UIFont fontWithName:@"DroidSans" size:12];
            subtitle.textColor=[UIColor whiteColor];
            subtitle.backgroundColor=[UIColor clearColor];
            subtitle.numberOfLines=0;
            [self addSubview:subtitle];
        }

        self.recipeLabelImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rahmen2.png"]];
        frame=self.recipeLabelImage.frame;
        frame.origin.x=6;
        frame.origin.y=55+self.display_offset;
        self.recipeLabelImage.frame=frame;
        [self addSubview:self.recipeLabelImage];
        self.recipeLabelImageHeight=frame.size.height;

        
        
//        AsyncImageView *aiv = [[AsyncImageView alloc] initWithUrl:[NSURL URLWithString:recipe.thumbnailUrl] frame:CGRectMake(17, 64+self.display_offset, 285, 286) contentMode:UIViewContentModeScaleAspectFill activityIndicatorType:UIActivityIndicatorViewStyleGray];
//        [aiv startLoadImage];
//        [self addSubview:aiv];
//        UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureTapped)];
//        [aiv addGestureRecognizer:gr];
        
        
        
        self.recipeImageView=[[LeckerRecipeImageView alloc] initWithFrame:CGRectMake(17, 64+self.display_offset, 285, 286)];
        self.recipeImageView.delegate=self;
        [self addSubview:self.recipeImageView];
        self.recipeImageHeight=self.recipeImageView.frame.size.height;
        
        self.activityView=[[UIView alloc] initWithFrame:CGRectMake(17, 64+self.display_offset, 285, 286)];
        UIActivityIndicatorView *test=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        test.frame=self.activityView.bounds;
        [test startAnimating];
        [self.activityView addSubview:test];
        [self addSubview:self.activityView];
        
        AsycImageLoader *loader=[[AsycImageLoader alloc] initWithURL:recipe.thumbnailUrl];
        loader.delegate=self;
        [loader doRequest];
        
        
        
        
        
        self.favIconActive=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zumeinenrezepten-blau.png"]];
        self.favIconActive.userInteractionEnabled=YES;
        self.favIconInactive=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zumeinenrezepten-grau.png"]];
        self.favIconInactive.userInteractionEnabled=YES;
        
        frame=self.favIconActive.frame;
        frame.size.height/=1.5;
        frame.size.width/=1.5;
        frame.origin.x=255;
        frame.origin.y=325+self.display_offset;
        
        self.tmpFrame=[[UIView alloc] initWithFrame:frame];
        
        self.favIconActive.frame=self.tmpFrame.bounds;
        self.favIconInactive.frame=self.tmpFrame.bounds;
        
        self.isFav=isFav;
        if(isFav) {
            [self.tmpFrame addSubview:self.favIconInactive];
             self.inactiveTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inactiveTapped:)];
            self.inactiveTap.numberOfTapsRequired=1;
            [self.favIconInactive addGestureRecognizer:self.inactiveTap];
        } else {
            [self.tmpFrame addSubview:self.favIconActive];
            self.activeTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(activeTapped:)];
            self.activeTap.numberOfTapsRequired=1;
            [self.favIconActive addGestureRecognizer:self.activeTap];
        }
        [self addSubview:self.tmpFrame];
        self.tmpFrameX=self.tmpFrame.frame.origin.x;
        self.tmpFrameY=self.tmpFrame.frame.origin.y;
    }
    return self;
}



-(void) activeTapped:(UITapGestureRecognizer*) tap {
    NSLog(@"Enter");
    NSLog(@"ContentID %@",self.model.contendId);
    self.isFav=YES;
    [self.favIconActive removeGestureRecognizer:self.activeTap];
    [UIView transitionFromView:self.favIconActive toView:self.favIconInactive duration:0.5f options:UIViewAnimationOptionTransitionFlipFromBottom completion:^(BOOL finished) {
        self.userInteractionEnabled=YES;
        self.inactiveTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inactiveTapped:)];
        self.inactiveTap.numberOfTapsRequired=1;
        [self.favIconInactive addGestureRecognizer:self.inactiveTap];
        NSLog(@"->ContentID %@",self.model.contendId);
        if([self.delegate respondsToSelector:@selector(addToFavPressedWithContentId:andImage:)]) {
            [self.delegate addToFavPressedWithContentId:self.model.contendId andImage:self.recipeImageView.image];
        }
    }];
}

-(void) getFocus {
    self.recipeImageView.userInteractionEnabled=YES;
    self.userInteractionEnabled=YES;
    [self.recipeImageView becomeFirstResponder];
}

-(void) inactiveTapped:(UITapGestureRecognizer*) tap {
    self.isFav=NO;
    [self.favIconInactive removeGestureRecognizer:self.inactiveTap];
    [UIView transitionFromView:self.favIconInactive toView:self.favIconActive duration:0.5f options:UIViewAnimationOptionTransitionFlipFromTop completion:^(BOOL finished) {
        self.userInteractionEnabled=YES;
        self.activeTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(activeTapped:)];
        self.activeTap.numberOfTapsRequired=1;
        [self.favIconActive addGestureRecognizer:self.activeTap];
        if([self.delegate respondsToSelector:@selector(removeFromFavPressedWithContentId:)]) {
            [self.delegate removeFromFavPressedWithContentId:self.model.contendId];
        }
    }];
}

-(void) imageLoadingComplettWithImage:(UIImage *)image {
    [self.activityView removeFromSuperview];
    [self.recipeImageView setImage:image];
    self.recipeImageView.clipsToBounds=YES;
    self.recipeImageView.contentMode=UIViewContentModeScaleAspectFill;
    if([self.delegate respondsToSelector:@selector(recipeImageLoadedWithContentId:andRecipeImage:)]) {
        [self.delegate recipeImageLoadedWithContentId:self.model.contendId andRecipeImage:image];
    }
}

-(void) pictureTapped {
    if([self.delegate respondsToSelector:@selector(recipePressedWithContentId:recipeImage:)]) {
        [self.delegate recipePressedWithContentId:self.model.contendId recipeImage:self.recipeImageView.image];
    }
}

-(void) isFavorite {
    if (!self.isFav) {
        self.isFav=YES;
        [self.favIconInactive removeGestureRecognizer:self.inactiveTap];
        [self.favIconActive removeGestureRecognizer:self.activeTap];
        [self.favIconActive removeFromSuperview];
        [self.tmpFrame addSubview:self.favIconInactive];
        self.inactiveTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inactiveTapped:)];
        self.inactiveTap.numberOfTapsRequired=1;
        [self.favIconInactive addGestureRecognizer:self.inactiveTap];
    }
}

-(void) isNotFavorite {
    if(self.isFav) {
        self.isFav=NO;
        [self.favIconInactive removeGestureRecognizer:self.inactiveTap];
        [self.favIconActive removeGestureRecognizer:self.activeTap];
        [self.favIconInactive removeFromSuperview];
        [self.tmpFrame addSubview:self.favIconActive];
        self.activeTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(activeTapped:)];
        self.activeTap.numberOfTapsRequired=1;
        [self.favIconActive addGestureRecognizer:self.activeTap];
    }
}

-(void) imageLoadingFailed {
    [self.activityView removeFromSuperview];
    [self.recipeImageView setImage:[UIImage imageNamed:@"no_image.png"]];
    self.recipeImageView.clipsToBounds=YES;
    self.recipeImageView.contentMode=UIViewContentModeScaleAspectFill;
}

-(void) switchToAdView {
    if(!self.bannerMode) {
        CGRect frame=self.recipeLabelImage.frame;
        frame.size.height-=20;
        self.recipeLabelImage.frame=frame;
        
        frame=self.recipeImageView.frame;
        frame.size.height-=20;
        self.recipeImageView.frame=frame;
        
        frame=self.tmpFrame.frame;
        frame.origin.y-=48;
        frame.origin.x+=7;
        self.tmpFrame.frame=frame;
        
        [self.recipeSticker removeFromSuperview];
        self.recipeSticker=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rezeptzettelneu.png"]];
        frame=self.recipeSticker.frame;
        frame.origin.x=12;
        frame.origin.y=self.recipeLabelImage.frame.origin.y+self.recipeLabelImage.frame.size.height-37;
        frame.size.height/=1.4;
        frame.size.width/=1.4;
        self.recipeSticker.frame=frame;
        self.recipeSticker.userInteractionEnabled=NO;
        [self addSubview:self.recipeSticker];
        self.bannerMode=YES;
    }
}

-(void) switchToNormalView {
    if(self.bannerMode) {
        CGRect frame=self.recipeLabelImage.frame;
        frame.size.height=self.recipeLabelImageHeight;
        self.recipeLabelImage.frame=frame;
        
        frame=self.recipeImageView.frame;
        frame.size.height=self.recipeImageHeight;
        self.recipeImageView.frame=frame;
        
        frame=self.tmpFrame.frame;
        frame.origin.y=self.tmpFrameY;
        frame.origin.x=self.tmpFrameX;
        self.tmpFrame.frame=frame;
        
        [self.recipeSticker removeFromSuperview];
 
        self.recipeSticker=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rezeptzettel.png"]];
        frame=self.recipeSticker.frame;
        frame.origin.x=10;
        frame.origin.y=347+self.display_offset;
        self.recipeSticker.frame=frame;
        self.recipeSticker.userInteractionEnabled=YES;
        [self insertSubview:self.recipeSticker atIndex:0];
        
        UITapGestureRecognizer *tap2=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureTapped)];
        tap2.numberOfTapsRequired=1;
        
        [self.recipeSticker addGestureRecognizer:tap2];
        
        self.bannerMode=NO;
    }
}


@end
