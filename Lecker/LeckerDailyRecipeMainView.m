//
//  LeckerDailyRecipeMainView.m
//  Lecker
//
//  Created by Naujeck, Marcel on 14.01.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LeckerDailyRecipeMainView.h"
#import "LeckerTools.h"
#import "DataManager.h"
#import <INFOnlineLibrary/INFOnlineLibrary.h>
#import "LeckerAppDelegate.h"


@interface LeckerDailyRecipeMainView ()
@property UIView *leckerHeader;
@property UIView *contentView;
@property UIView *backbuttonView;
@property NSMutableArray *dailyRecipeArray;
@property int actualIndex;
@property int xPositionStart;
@property int maxValue;
@property SASBannerView *banner;
@property BOOL bannerActiv;
@property int startPosXForSwipe;
@property int startTimeStamp;
@property BOOL hasPinView;
@property int swipeCounter;
@property UIWebView *infoView;
@end

@implementation LeckerDailyRecipeMainView
@synthesize leckerHeader=_leckerHeader;
@synthesize contentView=_contentView;

- (id)initWithFrame:(CGRect)frame pinView:(BOOL) hasPinView
{
    self = [super initWithFrame:frame];
    if (self) {
        self.swipeCounter=0;
        self.bannerActiv=NO;
        self.actualIndex=0;
        self.dailyRecipeArray=[[NSMutableArray alloc] init];
        self.leckerHeader=[[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 40)];
        [self.leckerHeader.layer insertSublayer:[LeckerTools headerGradientwithFrame:self.leckerHeader.bounds] atIndex:0];
        UIImageView *logo=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lecker-logo.png"]];
        CGRect frame=logo.frame;
        frame.origin.x=self.leckerHeader.frame.size.width/2- frame.size.width/2;
        frame.origin.y=self.leckerHeader.frame.size.height/2- frame.size.height/2;
        logo.frame=frame;
        [self.leckerHeader addSubview:logo];
        [self addSubview:self.leckerHeader];
        
        self.contentView=[[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, self.bounds.size.height-40)];
        UIImageView *bg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"holz.png"]];
        bg.frame=self.contentView.bounds;
        bg.contentMode=UIViewContentModeScaleAspectFill;
        bg.clipsToBounds=YES;
        [self.contentView addSubview:bg];
        [self addSubview:self.contentView];
        self.hasPinView=hasPinView;
        if(hasPinView) {
            UIImageView *pinButton=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ansichtbutton.png"]];
            pinButton.userInteractionEnabled=YES;
            frame=pinButton.frame;
            frame.origin.x=320-frame.size.width;
            frame.origin.y=50;
            pinButton.frame=frame;
            [self addSubview:pinButton];
            
            UITapGestureRecognizer *pinTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchToPinView)];
            pinTap.numberOfTapsRequired=1;
            [pinButton addGestureRecognizer:pinTap];
        }
    }
    return self;
}


// SK unused:
//-(void) infoButtonPressed {
//    NSLog(@"OpenVIew");
//    [self.infoView removeFromSuperview];
//    NSURLRequest *imprintRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://service.bauerdigital.de/mobile/astrowoche/static/"]];
//    [self.infoView loadRequest:imprintRequest];
//}

-(void) switchToPinView {
    if ([self.delegate respondsToSelector:@selector(switchToPinView)]) {
        [self.delegate switchToPinView];
    }
}


-(void) setMax:(int)maxValue {
    self.maxValue=maxValue;
}

-(void) enableBackButton {
    CGRect frame=self.leckerHeader.bounds;
    frame.size.width=40;
    frame.origin.x+=3;
    self.backbuttonView=[[UIView alloc] initWithFrame:frame];
    self.backbuttonView.userInteractionEnabled=YES;
    //self.backbuttonView.backgroundColor=[UIColor grayColor];
    [self.leckerHeader addSubview:self.backbuttonView];
    UIImageView *back=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back.png"]];
    //back.backgroundColor=[UIColor greenColor];
    frame=back.frame;
    frame.origin.y+=3;
    back.frame=frame;
    [self.backbuttonView addSubview:back];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonTapped:)];
    tap.numberOfTapsRequired=1;
    [self.backbuttonView addGestureRecognizer:tap];
    
}

-(void) backButtonTapped:(UITapGestureRecognizer*) tap {
    if([self.delegate respondsToSelector:@selector(optionalBackButtonPressed)]) {
        [self.delegate optionalBackButtonPressed];
    }
}

-(void) addViewWithModel:(LeckerSingleRecipeOverviewModel*) recipe andFav:(BOOL)isFav{
    LeckerSingleRecipeOverview *newView=[[LeckerSingleRecipeOverview alloc] initWithFrame:self.contentView.bounds recipeData:recipe isFav:isFav];
    newView.delegate=self;
    if (self.bannerActiv && ![LeckerTools isIPhone5]) {
        [newView switchToAdView];
    }
    [self.dailyRecipeArray addObject:newView];
    
}

-(void) initalSetup {
    if (self.dailyRecipeArray.count>0) {
        ((LeckerSingleRecipeOverview*)[self.dailyRecipeArray objectAtIndex:0]).frame=self.contentView.bounds;
        [self.contentView addSubview:[self.dailyRecipeArray objectAtIndex:0]];
    }
    
    if (self.dailyRecipeArray.count>1) {
        CGRect frame=self.contentView.bounds;
        frame.origin.x+=320;
        ((LeckerSingleRecipeOverview*)[self.dailyRecipeArray objectAtIndex:1]).frame=frame;
        [self.contentView addSubview:[self.dailyRecipeArray objectAtIndex:1]];
    }
    
}

-(void) initViewFromIndex:(int) from_index toIndex:(int) to_index {
    if (from_index<to_index) {
        if (from_index>0) {
            [[self.dailyRecipeArray objectAtIndex:from_index-1] removeFromSuperview];
        }
        if (to_index<self.dailyRecipeArray.count && to_index+1<self.maxValue) {
            CGRect frame=self.contentView.bounds;
            frame.origin.x+=320;
            ((LeckerSingleRecipeOverview*)[self.dailyRecipeArray objectAtIndex:to_index+1]).frame=frame;
            [self.contentView addSubview:[self.dailyRecipeArray objectAtIndex:to_index+1]];
        }
    }
    
    if (from_index>to_index) {
        if(from_index+1<self.dailyRecipeArray.count) {
           [[self.dailyRecipeArray objectAtIndex:from_index+1] removeFromSuperview]; 
        }
        if(to_index>0) {
            CGRect frame=self.contentView.bounds;
            frame.origin.x-=320;
            ((LeckerSingleRecipeOverview*)[self.dailyRecipeArray objectAtIndex:to_index-1]).frame=frame;
            [self.contentView addSubview:[self.dailyRecipeArray objectAtIndex:to_index-1]];
        }
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    ((LeckerSingleRecipeOverview*)[self.dailyRecipeArray objectAtIndex:self.actualIndex]).userInteractionEnabled=NO; // SK wozu?
    UITouch *tmpTouch = [[touches allObjects] objectAtIndex:0];
    self.xPositionStart=[tmpTouch locationInView:tmpTouch.window].x;
    self.startPosXForSwipe=self.xPositionStart;
    self.startTimeStamp=CACurrentMediaTime();
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    ((LeckerSingleRecipeOverview*)[self.dailyRecipeArray objectAtIndex:self.actualIndex]).userInteractionEnabled=YES; // SK wozu?
    UITouch *tmpTouch = [[touches allObjects] objectAtIndex:0];
    
    int actualPosXForSwipe=[tmpTouch locationInView:tmpTouch.window].x;
    double actualTimeStamp=CACurrentMediaTime();
    double swipeIntervalStart=0.1;
    double swipeIntervalEnd=1.2;
    BOOL swipeTimeMatch=(actualTimeStamp-self.startTimeStamp>swipeIntervalStart && actualTimeStamp-self.startTimeStamp<swipeIntervalEnd)?YES:NO;
    BOOL swipeToLeft=NO;
    BOOL swipeToRight=NO;
    float acc=1;
    
    if (swipeTimeMatch && abs(self.startPosXForSwipe-actualPosXForSwipe)>20) {
        acc=(actualTimeStamp-self.startTimeStamp);
        if (self.startPosXForSwipe<actualPosXForSwipe && self.actualIndex!=0) {
            swipeToLeft=YES;
        } else if (self.startPosXForSwipe>actualPosXForSwipe && self.actualIndex+1<self.dailyRecipeArray.count) {
            swipeToRight=YES;
        }
    }
    
    CGRect frame1=((UIView*)[self.dailyRecipeArray objectAtIndex:self.actualIndex]).frame;
    if (frame1.origin.x>-160 && frame1.origin.x<160 && !(swipeToLeft|swipeToRight)) {
        frame1.origin.x=0;
        CGRect frame2=frame1;
        frame2.origin.x=320;
        CGRect frame3=frame1;
        frame3.origin.x=-320;
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationCurveEaseIn animations:^{
            ((LeckerSingleRecipeOverview*)[self.dailyRecipeArray objectAtIndex:self.actualIndex]).frame=frame1;
            if(self.actualIndex>0) {
                ((LeckerSingleRecipeOverview*)[self.dailyRecipeArray objectAtIndex:self.actualIndex-1]).frame=frame3;
            }
            if(self.actualIndex+1<self.dailyRecipeArray.count) {
                ((LeckerSingleRecipeOverview*)[self.dailyRecipeArray objectAtIndex:self.actualIndex+1]).frame=frame2;
            }
        } completion:^(BOOL finished) {
            
        }];
    } else {
        CGRect frame2;
        
        if((frame1.origin.x>160 || swipeToLeft) ) {
            frame1.origin.x=320;
            frame2=frame1;
            frame2.origin.x=0;
            [UIView animateWithDuration:0.3f*acc delay:0 options:UIViewAnimationCurveEaseIn animations:^{
                ((UIView*)[self.dailyRecipeArray objectAtIndex:self.actualIndex]).frame=frame1;
                ((UIView*)[self.dailyRecipeArray objectAtIndex:self.actualIndex-1]).frame=frame2;
            } completion:^(BOOL finished) {
                [[IOLSession defaultSession] logEventWithType:IOLEventTypeView state:IOLViewAppeared category:@"RecipeViewChangend" comment:@"RecipeViewChangend"];
                [self initViewFromIndex:self.actualIndex toIndex:self.actualIndex-1];
                [self decActualIndex];
            }];
        } else if (frame1.origin.x<160 || swipeToRight){
            frame1.origin.x=-320;
            frame2=frame1;
            frame2.origin.x=0;
            [UIView animateWithDuration:0.3f*acc delay:0 options:UIViewAnimationCurveEaseIn animations:^{
                ((UIView*)[self.dailyRecipeArray objectAtIndex:self.actualIndex]).frame=frame1;
                if(self.actualIndex+1!=self.maxValue) {
                   ((UIView*)[self.dailyRecipeArray objectAtIndex:self.actualIndex+1]).frame=frame2;
                }
            } completion:^(BOOL finished) {
                [[IOLSession defaultSession] logEventWithType:IOLEventTypeView state:IOLViewAppeared category:@"RecipeViewChangend" comment:@"RecipeViewChangend"];
                [self initViewFromIndex:self.actualIndex toIndex:self.actualIndex+1];
                [self incActualIndex];
            }];
        }
    }
}


-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *tmpTouch = [[touches allObjects] objectAtIndex:0];
    int newXPosition=[tmpTouch locationInView:tmpTouch.window].x;
    int difXPosition=newXPosition-self.xPositionStart;
    CGRect frame=((UIView*)[self.dailyRecipeArray objectAtIndex:self.actualIndex]).frame;
    if (!(frame.origin.x+difXPosition>0 && self.actualIndex==0) && !(frame.origin.x+difXPosition<0 && self.actualIndex+1==self.maxValue)) {
        frame.origin.x+=difXPosition;
        ((UIView*)[self.dailyRecipeArray objectAtIndex:self.actualIndex]).frame=frame;
        
        if(self.actualIndex>0) {
            frame=((UIView*)[self.dailyRecipeArray objectAtIndex:self.actualIndex-1]).frame;
            frame.origin.x+=difXPosition;
            ((UIView*)[self.dailyRecipeArray objectAtIndex:self.actualIndex-1]).frame=frame;
        }
        
        if(self.actualIndex+1<self.dailyRecipeArray.count) {
            frame=((UIView*)[self.dailyRecipeArray objectAtIndex:self.actualIndex+1]).frame;
            frame.origin.x+=difXPosition;
            ((UIView*)[self.dailyRecipeArray objectAtIndex:self.actualIndex+1]).frame=frame;
        }
    }
    self.xPositionStart=newXPosition;

}

-(void)recipePressedWithContentId:(NSString *)contentId recipeImage:(UIImage *)image{
    if([self.delegate respondsToSelector:@selector(recipeActivateWithContentId:recipeImage:)]) {
        [self.delegate recipeActivateWithContentId:contentId recipeImage:image];
    }
}

-(void) getFocus {
    [((LeckerSingleRecipeOverview*)[self.dailyRecipeArray objectAtIndex:self.actualIndex]) getFocus];
}

-(void) incActualIndex {
    self.actualIndex++;
    NSLog(@"SwipeNr:%d -> %@",self.actualIndex,[NSNumber numberWithInt:self.actualIndex]);
    NSString *withActionText=self.hasPinView?@"DailyRecipeSwipeView":@"SearchResultSwipeView";
    [((LeckerAppDelegate *)[[UIApplication sharedApplication] delegate]).tracker trackEventWithCategory:@"Controller" withAction:withActionText withLabel:@"SwipeTo" withValue:[NSNumber numberWithInt:self.actualIndex]];
    if (self.actualIndex+2>=self.dailyRecipeArray.count && self.actualIndex+2<self.maxValue) {
        if ([self.delegate respondsToSelector:@selector(pullNextRecipes)]) {
            [self.delegate pullNextRecipes];
        }
    } 
    
    if (self.swipeCounter==5) {
        self.swipeCounter=0;
        if ([self.delegate respondsToSelector:@selector(requestNewAdForBanner)]) {
            [self.delegate requestNewAdForBanner];
        }
    }
    
    self.swipeCounter++;
    
}

-(void) decActualIndex {
    self.actualIndex--;
    NSString *withActionText=self.hasPinView?@"DailyRecipeSwipeView":@"SearchResultSwipeView";
    [((LeckerAppDelegate *)[[UIApplication sharedApplication] delegate]).tracker trackEventWithCategory:@"Controller" withAction:withActionText withLabel:@"SwipeTo" withValue:[NSNumber numberWithInt:self.actualIndex]];
    if (self.swipeCounter==5) {
        self.swipeCounter=0;
        if ([self.delegate respondsToSelector:@selector(requestNewAdForBanner)]) {
            [self.delegate requestNewAdForBanner];
        }
    }
    
    self.swipeCounter++;
}

-(void) addToFavPressedWithContentId:(NSString *)contentId andImage:(UIImage *)image{
    if ([self.delegate respondsToSelector:@selector(addToFavPressedWithContentId:andImage:)]) {
        [self.delegate addToFavPressedWithContentId:contentId andImage:image];
    }
}

-(void) removeFromFavPressedWithContentId:(NSString *)contentId {
    if ([self.delegate respondsToSelector:@selector(removeFromFavPressedWithContentId:)]) {
        [self.delegate removeFromFavPressedWithContentId:contentId];
    }
}

-(void) updateArrayForFavWithSet:(NSSet*) contentIdSet {
    for (UIView *view in self.dailyRecipeArray) {
        if([view respondsToSelector:@selector(isFavorite)]) {
            if([contentIdSet containsObject:( (LeckerSingleRecipeOverview*)view).model.contendId]) {
                [view performSelector:@selector(isFavorite)];
            } else {
                [view performSelector:@selector(isNotFavorite)];
            }
        }
    }
}

-(void) updateArrayToAdView {
    for (UIView *view in self.dailyRecipeArray) {
        if([view respondsToSelector:@selector(switchToAdView)]) {
            [view performSelector:@selector(switchToAdView)];
        }
    }
}

-(void) updateArrayToNormalView {
    for (UIView *view in self.dailyRecipeArray) {
        if([view respondsToSelector:@selector(switchToNormalView)]) {
            [view performSelector:@selector(switchToNormalView)];
        }
    }
}

-(void) recipeImageLoadedWithContentId:(NSString *)contentId andRecipeImage:(UIImage *)image {
    if([self.delegate respondsToSelector:@selector(recipeImageLoadedWithContentId:andRecipeImage:)]) {
        [self.delegate recipeImageLoadedWithContentId:contentId andRecipeImage:image];
    }
}

-(void) tapped:(UIGestureRecognizer*) tap {
    [self.banner removeFromSuperview];
    self.banner=nil;
    self.bannerActiv=NO;
}

-(void) createBanner:(SASBannerView*) bannerView {
    [self.banner removeFromSuperview];
    self.bannerActiv=YES;
    self.banner=bannerView;
    self.banner.layer.borderWidth=1;
    self.banner.layer.borderColor=[UIColor blackColor].CGColor;
    self.banner.layer.cornerRadius=5;
    self.banner.clipsToBounds=YES;
    
    CGRect frame=bannerView.frame;
    frame.origin.x=self.bounds.size.width/2-bannerView.frame.size.width/2;
    frame.origin.y=self.bounds.size.height-bannerView.frame.size.height;
    self.banner.frame=frame;
    [self addSubview:self.banner];
    
    if(![LeckerTools isIPhone5])[self updateArrayToAdView];
}

-(void) removeBanner {
    self.bannerActiv=NO;
    [self.banner removeFromSuperview];
    if(![LeckerTools isIPhone5])[self updateArrayToNormalView];
}


@end
