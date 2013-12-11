//
//  LeckerFavoritesMainView.m
//  Lecker
//
//  Created by Naujeck, Marcel on 15.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerFavoritesMainView.h"
#import "LeckerTools.h"



@interface LeckerFavoritesMainView ()
@property UIView *leckerHeader;
@property UIView *contentView;
@property UIScrollView *scrollView;
@property UIImageView *buttonView;
@property UIView *tmpView;
@property BOOL isNormalMode;
@property UILabel *editLabel;
@property (nonatomic)  NSMutableSet *removeList;
@end

@implementation LeckerFavoritesMainView
@synthesize removeList=_removeList;

-(NSMutableSet*) removeList {
    if(!_removeList) _removeList=[[NSMutableSet alloc] init];
    return _removeList;
}

- (id)initWithFrame:(CGRect)frame andRecipeList:(NSArray *)recipeList
{
    self = [super initWithFrame:frame];
    if (self) {
        self.leckerHeader=[[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 40)];
        [self.leckerHeader.layer insertSublayer:[LeckerTools headerGradientwithFrame:self.leckerHeader.bounds] atIndex:0];
        UIImageView *logo=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lecker-logo.png"]];
        CGRect frame=logo.frame;
        frame.origin.x=self.leckerHeader.frame.size.width/2- frame.size.width/2;
        frame.origin.y=self.leckerHeader.frame.size.height/2- frame.size.height/2;
        logo.frame=frame;
        [self.leckerHeader addSubview:logo];
        [self addSubview:self.leckerHeader];
        
        self.contentView=[[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, self.bounds.size.height-87)];
        UIImageView *bg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"holz.png"]];
        bg.frame=self.contentView.bounds;
        bg.contentMode=UIViewContentModeScaleAspectFill;
        bg.clipsToBounds=YES;
        [self.contentView addSubview:bg];
        [self addSubview:self.contentView];
        [self showFavList:recipeList];
        
        self.buttonView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_breit.png"]];
        self.buttonView.userInteractionEnabled=YES;
        frame=self.buttonView.frame;
        frame.size.height*=0.8;
        frame.size.width*=0.8;
        frame.origin.y+=45;
        frame.origin.x+=5;
        self.buttonView.frame=frame;
        [self addSubview:self.buttonView];
        
        self.editLabel=[[UILabel alloc] initWithFrame:self.buttonView.bounds];
        self.editLabel.text=@"Bearbeiten";
        self.editLabel.textColor=[LeckerTools colorFromHexString:@"5cacbd"];;
        self.editLabel.backgroundColor=[UIColor clearColor];
        self.editLabel.textAlignment=NSTextAlignmentCenter;
        self.editLabel.shadowColor=[UIColor colorWithWhite:0 alpha:0.1];
        self.editLabel.shadowOffset=CGSizeMake(1,1);
        self.editLabel.adjustsFontSizeToFitWidth=NO;
        self.editLabel.userInteractionEnabled=NO;
        self.editLabel.font=[UIFont fontWithName:@"TimesNewRomanPSMT" size:16];
        frame=self.editLabel.frame;
        frame.size.width-=20;
        frame.origin.x+=10;
        frame.size.height-=4;
        frame.origin.y+=2;
        self.editLabel.frame=frame;
        [self.buttonView addSubview:self.editLabel];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleMode:)];
        tap.numberOfTapsRequired=1;
        [self.buttonView addGestureRecognizer:tap];
        self.isNormalMode=YES;
        
    }
    return self;
}

-(void) toggleMode:(UITapGestureRecognizer*) tap {
    if(self.isNormalMode) {
       [self.removeList removeAllObjects];
       self.editLabel.text=@"Löschen"; 
    } else {
       self.editLabel.text=@"Bearbeiten";
        if(self.removeList.count>0 && [self.delegate respondsToSelector:@selector(deleteSetFromFavs:)]) {
            [self.delegate deleteSetFromFavs:self.removeList];
        }
    }
    
    
    for (UIView *view in self.tmpView.subviews) {
        if ([view respondsToSelector:@selector(toggleToEdit)]) {
            if(self.isNormalMode) {
               [view performSelector:@selector(toggleToEdit)]; 
            } else {
                if (self.removeList.count==0) {
                   [view performSelector:@selector(toggleToNormal)]; 
                }
            }
            
        }
    }
    self.isNormalMode=!self.isNormalMode;
}

-(void) showFavList:(NSArray*) recipeList {
    [self.scrollView removeFromSuperview];
    
    self.scrollView=[[UIScrollView alloc] initWithFrame:self.contentView.bounds];
    self.scrollView.alwaysBounceVertical = YES;
    [self.contentView addSubview:self.scrollView];
    UIImageView *bgHeader=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"karopapier_oben.png"]];
    CGRect frame=bgHeader.frame;
    frame.origin.y+=50;
    bgHeader.frame=frame;
    [self.scrollView addSubview:bgHeader];
    
    UIImageView *headerLogo=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"meinerezepte.png"]];
    frame=headerLogo.frame;
    frame.origin.x=self.bounds.size.width/2-(frame.size.width/1.5)/2;
    frame.origin.y+=10;
    frame.size.height/=1.5;
    frame.size.width/=1.5;
    headerLogo.frame=frame;
    [self.scrollView addSubview:headerLogo];
    
    self.tmpView=[[UIView alloc] initWithFrame:self.scrollView.bounds];
    frame=self.tmpView.frame;
    frame.origin.y=100;
    self.tmpView.frame=frame;
    
    int index=0;
    for (LeckerSingleRecipeDetailModel *recipe in recipeList) {
        if(index>0) {
            UIImageView *ruler=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dottedHeader.png"]];
            frame=ruler.frame;
            frame.origin.x=160-frame.size.width/2;
            frame.origin.y=(100*(index-1))+84;
            ruler.frame=frame;
            ruler.alpha=0.3;
            [self.tmpView addSubview:ruler];
        }
        LeckerFavEntryView *tmp=[[LeckerFavEntryView alloc]
                                 initWithFrame:CGRectMake(self.scrollView.bounds.origin.x+10, 100*index, self.scrollView.frame.size.width-20, 80)
                                 andRecipe:recipe];
        tmp.delegate=self;
        [self.tmpView addSubview:tmp];
        index++;
    }
    
    frame=self.tmpView.frame;
    frame.size.height=100*(index);
    self.tmpView.frame=frame;
    
    int counter=(int)(self.tmpView.frame.size.height/67);
    int lastOffcet=bgHeader.frame.origin.y+bgHeader.frame.size.height;
    for(int i=0;i<counter;i++) {
        UIImageView *bgmiddle=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"karopapier_mitte.png"]];
        frame=bgmiddle.frame;
        frame.origin.y=lastOffcet;
        bgmiddle.frame=frame;
        lastOffcet=bgmiddle.frame.origin.y+bgmiddle.frame.size.height;
        [self.scrollView addSubview:bgmiddle];
    }
    
    UIImageView *bgBottom=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"karopapier_unten.png"]];
    frame=bgBottom.frame;
    frame.origin.y=lastOffcet;
    bgBottom.frame=frame;
    [self.scrollView addSubview:bgBottom];
    
    [self.scrollView addSubview:self.tmpView];
    self.scrollView.contentSize=CGSizeMake(320, bgBottom.frame.origin.y+bgBottom.frame.size.height);
    
    UIImageView *bottomLine=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"meine_rezepte_bottom.png"]];
    frame=bottomLine.frame;
    frame.origin.y=bgBottom.frame.origin.y+bgBottom.frame.size.height-frame.size.height-7;
    frame.origin.x=160-frame.size.width/2;
    bottomLine.frame=frame;
    [self.scrollView addSubview:bottomLine];

}

-(void) recipeRemoveFromFav:(NSString *)contentId {
    if([self.delegate respondsToSelector:@selector(recipeRemoveFromFav:)]) {
        [self.delegate recipeRemoveFromFav:contentId];
    }
}

-(void) recipePressedWithRecipe:(LeckerSingleRecipeDetailModel *)recipe {
    if([self.delegate respondsToSelector:@selector(recipePressedWithRecipe:)]) {
        [self.delegate recipePressedWithRecipe:recipe];
    }
}

-(void) addToRemoveList:(NSString *)contentId {
    [self.removeList addObject:contentId];
}

-(void) removeFromRemoveList:(NSString *)contentId {
    [self.removeList removeObject:contentId];
}

@end
