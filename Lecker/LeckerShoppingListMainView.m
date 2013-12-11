//
//  LeckerShoppingListMainView.m
//  Lecker
//
//  Created by Naujeck, Marcel on 20.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerShoppingListMainView.h"
#import "LeckerTools.h"
#import "ShoppingCard.h"


@interface LeckerShoppingListMainView()
@property UIView *leckerHeader;
@property UIView *contentView;
@property UIScrollView *scrollView;
@property UIView *dynamikView;
@property (nonatomic)  NSMutableSet *shoppingListRemoveSet;
@property int bannerHeight;
@property int contentHeight;
@end

@implementation LeckerShoppingListMainView
@synthesize shoppingListRemoveSet=_shoppingListRemoveSet;

-(NSMutableSet*) shoppingListRemoveSet {
    if(!_shoppingListRemoveSet) _shoppingListRemoveSet=[[NSMutableSet alloc] init];
    return _shoppingListRemoveSet;
}

- (id)initWithFrame:(CGRect)frame andShoppingList:(NSArray*) shoppingList
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bannerHeight=0;
        self.userInteractionEnabled=YES;
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
        
        self.scrollView=[[UIScrollView alloc] initWithFrame:self.contentView.bounds];
        self.scrollView.alwaysBounceVertical = YES;
        [self.contentView addSubview:self.scrollView];
        self.contentView.userInteractionEnabled=YES;
        UIImageView *bgHeader=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"karopapier_unten.png"]];
        frame=bgHeader.frame;
        frame.size.width*=0.95;
        bgHeader.frame=frame;
        bgHeader.center=CGPointMake(160, 45);
        [self.scrollView addSubview:bgHeader];
        
        UILabel *header=[[UILabel alloc] initWithFrame:bgHeader.bounds];
        header.backgroundColor=[UIColor clearColor];
        header.textColor=[UIColor blackColor];
        header.text=@"Einkaufszettel";
        header.font=[UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:20];
        header.textAlignment=NSTextAlignmentCenter;
        [bgHeader addSubview:header];
        
        UIImageView *patch1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"maskingtape5.png"]];
        frame=patch1.frame;
        frame.origin.y+=12;
        frame.origin.x+=225;
        patch1.frame=frame;
        [self.scrollView addSubview:patch1];
        
        UIImageView *patch2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"maskingtape2.png"]];
        frame=patch2.frame;
        frame.origin.y+=58;
        frame.origin.x+=5;
        patch2.frame=frame;
        [self.scrollView addSubview:patch2];
        

        
        self.dynamikView=[[UIView alloc] initWithFrame:CGRectMake(0, patch2.frame.origin.y+patch2.frame.size.height,320,300)];
        self.dynamikView.userInteractionEnabled=YES;
        self.scrollView.userInteractionEnabled=YES;
        [self.scrollView addSubview:self.dynamikView];
        [self addShoppingCardWithList:shoppingList];
        
    }
    return self;
}

-(void) bannerWithHeightSet:(int) height {
    self.bannerHeight=height;
    CGSize size=self.scrollView.contentSize;
    size.height=self.contentHeight+self.bannerHeight;
    self.scrollView.contentSize=size;
}

-(void) addShoppingCardWithList:(NSArray*) shoppingList {
    for (UIView *view in self.dynamikView.subviews) {
        [view removeFromSuperview];
    }
    [self.shoppingListRemoveSet removeAllObjects];
    
    UIImageView *bgHeader=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"karopapier_oben.png"]];
    [self.dynamikView addSubview:bgHeader];
    bgHeader.userInteractionEnabled=YES;
    
    UIImageView *addButton=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_hinzufuegen_gruen.png"]];
    CGRect frame=addButton.frame;
    frame.origin.y+=15;
    frame.origin.x+=40;
    frame.size.height*=0.8;
    //frame.size.width*=0.8;
    addButton.frame=frame;
    [bgHeader addSubview:addButton];
    addButton.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap0=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addingItems:)];
    tap0.numberOfTapsRequired=1;
    [addButton addGestureRecognizer:tap0];
    
    UILabel *addLabel=[[UILabel alloc] initWithFrame:addButton.bounds];
    addLabel.text=@"hinzufügen";
    addLabel.textColor=[LeckerTools colorFromHexString:@"#629354"];
    addLabel.backgroundColor=[UIColor clearColor];
    addLabel.textAlignment=NSTextAlignmentCenter;
    //addLabel.shadowColor=[UIColor blackColor];
    //addLabel.shadowOffset=CGSizeMake(1,1);
    addLabel.font=[UIFont fontWithName:@"TimesNewRomanPSMT" size:16];
    addLabel.userInteractionEnabled=NO;
    frame=addLabel.frame;
    frame.size.width-=20;
    frame.origin.x+=10;
    frame.origin.y+=2;
    frame.size.height-=5;
    addLabel.frame=frame;
    [addButton addSubview:addLabel];
    
    UIImageView *deleteButton=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_loeschen_rot.png"]];
    frame=deleteButton.frame;
    frame.origin.y+=15;
    frame.origin.x=320-frame.size.width-40;
    frame.size.height*=0.8;
    //frame.size.width*=0.8;
    deleteButton.frame=frame;
    deleteButton.userInteractionEnabled=YES;
    [bgHeader addSubview:deleteButton];
    
    UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteMarketItems:)];
    tap1.numberOfTapsRequired=1;
    [deleteButton addGestureRecognizer:tap1];
    
    UILabel *deleteLabel=[[UILabel alloc] initWithFrame:addButton.bounds];
    deleteLabel.text=@"löschen";
    deleteLabel.textColor=[LeckerTools colorFromHexString:@"#db3b3a"];
    deleteLabel.backgroundColor=[UIColor clearColor];
    deleteLabel.textAlignment=NSTextAlignmentCenter;
    
    //deleteLabel.shadowColor=[UIColor blackColor];
    //deleteLabel.shadowOffset=CGSizeMake(1,1);
    deleteLabel.font=[UIFont fontWithName:@"TimesNewRomanPSMT" size:16];
    frame=deleteLabel.frame;
    frame.size.width-=20;
    frame.origin.x+=10;
    frame.origin.y+=2;
    frame.size.height-=5;
    deleteLabel.frame=frame;
    deleteLabel.userInteractionEnabled=NO;
    [deleteButton addSubview:deleteLabel];
    

    
    UIImageView *ruler=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dottedKategorie.png"]];
    frame=ruler.frame;
    frame.origin.y+=43;
    frame.origin.x=160-frame.size.width/2;
    ruler.frame=frame;
    
    
    int index=0;
    UIView *tmpView=[[UIView alloc] initWithFrame:CGRectMake(0, bgHeader.frame.origin.y+bgHeader.frame.size.height, 320, 1)];
    for (ShoppingCard *item in shoppingList) {
        LeckerSingleIngView *ingView=[[LeckerSingleIngView alloc] initWithFrame:CGRectMake(30, index*30,260, 22) andIngredients:item.ingredients andOutPutText:[NSString stringWithFormat:@"%@ x %@",item.value,item.ingredients]];
        ingView.delegate=self;
        [tmpView addSubview:ingView];
        index++;
    }
    frame=tmpView.frame;
    frame.size.height=index*30;
    tmpView.frame=frame;
    int offset=bgHeader.frame.origin.y+bgHeader.frame.size.height;
    UIImage *image=[UIImage imageNamed:@"karopapier_mitte.png"];

    UIImageView *bgfooder=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"karopapier_unten.png"]];
    int counter=((index*30)-bgfooder.frame.size.height)/image.size.height;
    if ((counter*image.size.height)+bgfooder.frame.size.height<(index*30)) counter++;
    
    for (int i=0;i<counter;i++) {
        UIImageView *tmpImgView=[[UIImageView alloc] initWithImage:image];
        frame=tmpImgView.frame;
        frame.origin.y=offset;
        tmpImgView.frame=frame;
        [self.dynamikView addSubview:tmpImgView];
        offset=tmpImgView.frame.origin.y+tmpImgView.frame.size.height;
    }
    
    frame=bgfooder.frame;
    frame.origin.y=offset;
    bgfooder.frame=frame;
    [self.dynamikView addSubview:bgfooder];
    [self.dynamikView addSubview:tmpView];
    frame=self.dynamikView.frame;
    frame.size.height=bgfooder.frame.origin.y+bgfooder.frame.size.height;
    self.dynamikView.frame=frame;
    
    self.scrollView.contentSize=CGSizeMake(320, self.dynamikView.frame.origin.y+self.dynamikView.frame.size.height);
    self.contentHeight=self.scrollView.contentSize.height;
    [self.dynamikView addSubview:ruler];

}

-(void) addingItems:(UITapGestureRecognizer*) tap {
    if ([self.delegate respondsToSelector:@selector(addingItemByUser)]) {
        [self.delegate addingItemByUser];
    }
}

-(void) deleteMarketItems:(UITapGestureRecognizer*) tap {
    if ([self.delegate respondsToSelector:@selector(addingItemByUser)]) {
        [self.delegate removeFromShoppingList:self.shoppingListRemoveSet];
    }
}

-(void) ingredientsAddToList:(NSString *)ing {
    [self.shoppingListRemoveSet addObject:ing];
}

-(void) ingredientsRemoveFromList:(NSString *)ing {
    [self.shoppingListRemoveSet removeObject:ing];
}

@end
