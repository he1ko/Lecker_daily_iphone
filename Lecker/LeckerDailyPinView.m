//
//  LeckerDailyPinView.m
//  Lecker
//
//  Created by Naujeck, Marcel on 12.04.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerDailyPinView.h"
#import "LeckerSingleRecipeOverviewModel.h"
#import "LeckerTools.h"

@interface LeckerDailyPinView ()
@property (nonatomic)  NSMutableArray *recipeArray;
@property UIView *leckerHeader;
@property UIView *contentView;
@property UIScrollView *scrollView;
@property (nonatomic)  NSMutableArray *viewArray;
@property int actualViewIndex;
@property BOOL locked;
@property int offsetLeft;
@property int offsetRight;
@property BOOL actualLeft;
@property int pos;
@end

@implementation LeckerDailyPinView

-(NSMutableArray*) viewArray {
    if(_viewArray==nil) _viewArray=[[NSMutableArray alloc] init];
    return _viewArray;
}


-(NSMutableArray*) recipeArray {
    if(_recipeArray==nil) _recipeArray=[[NSMutableArray alloc] init];
    return _recipeArray;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pos=0;
        self.offsetLeft=10;
        self.offsetRight=10;
        self.locked=NO;
        self.actualViewIndex=0;
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
        
        self.scrollView=[[UIScrollView alloc] initWithFrame:self.contentView.bounds];
        self.scrollView.delegate=self;
        //self.scrollView.bounces=NO;
        [self.contentView addSubview:self.scrollView];
        
        
        UIImageView *pinButton=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ansichtbutton.png"]];
        pinButton.userInteractionEnabled=YES;
        frame=pinButton.frame;
        frame.origin.x=320-frame.size.width;
        frame.origin.y=50;
        pinButton.frame=frame;
        [self addSubview:pinButton];
        
        UITapGestureRecognizer *pinTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchToSwipe)];
        pinTap.numberOfTapsRequired=1;
        [pinButton addGestureRecognizer:pinTap];
        
        
        
    }
    return self;
}

-(void) switchToSwipe {
    if([self.delegate respondsToSelector:@selector(backToSwipeView)]) {
        [self.delegate backToSwipeView];
    }
}

-(void) processWithArray:(NSArray*) initArray {
    self.locked=YES;
    [self.recipeArray addObjectsFromArray:initArray];
    [self prepareForView];
    
}

-(void) prepareForView {
    CGRect frame;
    if (self.offsetLeft<=self.offsetRight) {
        frame=CGRectMake(10, self.offsetLeft,140, 140);
    } else {
        frame=CGRectMake(160, self.offsetRight,140, 140);
    }
    
    LeckerDailyPinSingleView *singleView=[[LeckerDailyPinSingleView alloc] initWithFrame:frame andDetailData:((LeckerSingleRecipeOverviewModel*)[self.recipeArray objectAtIndex:self.actualViewIndex]) andPos:self.pos];
    self.pos++;
    if (self.pos>3)self.pos=0;
    singleView.delegate=self;
    [singleView processInit];
    [self.viewArray addObject:singleView];
    
}

-(void) viewReady:(LeckerDailyPinSingleView *)view {
    view.alpha=0;
    [self.scrollView addSubview:view];
    if(view.frame.origin.x==10) {
        self.offsetLeft=view.frame.origin.y+view.frame.size.height+20;
    } else {
        self.offsetRight=view.frame.origin.y+view.frame.size.height+20;
    }
    if (self.scrollView.contentSize.height<view.frame.origin.y+view.frame.size.height) {
         self.scrollView.contentSize=CGSizeMake(320, view.frame.origin.y+view.frame.size.height);
    }
   
    if(self.actualViewIndex+1<self.recipeArray.count) {
        self.actualViewIndex++;
        [self prepareForView];
        //[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(prepareForView) userInfo:nil repeats:NO];
    } else {
        self.actualViewIndex++;
        self.locked=NO;
        if((self.scrollView.contentOffset.y+self.scrollView.frame.size.height)>self.scrollView.contentSize.height-100 && !self.locked) {
            if([self.delegate respondsToSelector:@selector(pullNextRecipes)]) {
                NSLog(@"Lock");
                self.locked=YES;
                [self.delegate pullNextRecipes];
            }
        }
    }
    
    view.transform = CGAffineTransformIdentity;
    CGAffineTransform trans = CGAffineTransformScale(view.transform, 0.01, 0.01);
    view.transform = trans;
    
    [UIView animateWithDuration:1.0 animations:^{
        view.alpha=1;
        view.transform = CGAffineTransformScale(view.transform, 100.0, 100.0);
    } completion:^(BOOL finished) {
        
    }];
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%f",scrollView.contentOffset.y);
    if((scrollView.contentOffset.y+scrollView.frame.size.height)>scrollView.contentSize.height-100 && !self.locked) {
        if([self.delegate respondsToSelector:@selector(pullNextRecipes)]) {
            NSLog(@"Lock");
            self.locked=YES;
            [self.delegate pullNextRecipes];
        }
        CGSize size=self.scrollView.contentSize;
        size.height+=self.scrollView.frame.size.height/1.3;
        self.scrollView.contentSize=size;
    }
}

-(void) recipePressedWithId:(NSString *)recipeId andImage:(UIImage *)image{
    if([self.delegate respondsToSelector:@selector(recipeActivateWithContentId:recipeImage:)]) {
        [self.delegate recipeActivateWithContentId:recipeId recipeImage:image];
    }
}



@end
