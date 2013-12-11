//
//  LeckerIngLayerView.m
//  Lecker
//
//  Created by Naujeck, Marcel on 28.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerIngLayerView.h"
#import "LeckerTools.h"



@interface LeckerIngLayerView()
@property UIView *contentView;
@property NSArray *ingList;
@property NSDictionary *ingMap;
@property UIScrollView *ingView;
@property NSMutableArray *imageArray;
@property LeckerLetterBar *letterBar;
@property UIImageView *addButton;
@property UILabel *addLabel;
@property UILabel *clearLabel;
@property UIImageView *clearButton;
@end

@implementation LeckerIngLayerView

- (id)initWithFrame:(CGRect)frame andFacetMap:(NSSet*) facetSet
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds=NO;
        UIImageView *bgwood=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"holz.png"]];
        
        CGRect tmp=frame;
        tmp.origin.y=-15;
        bgwood.frame=tmp;
        [self addSubview:bgwood];
        
        self.ingList=[LeckerTools sortKeyFromSet:facetSet];
        self.ingMap=[LeckerTools dictionaryFromFacetExprSet:facetSet];
        self.contentView=[[UIView alloc] initWithFrame:self.bounds];

        [self addSubview:self.contentView];
        
        self.imageArray=[[NSMutableArray alloc] init];
        [self.imageArray addObject:[UIImage imageNamed:@"mt_blau.png"]];
        [self.imageArray addObject:[UIImage imageNamed:@"mt_gruen.png"]];
        [self.imageArray addObject:[UIImage imageNamed:@"mt_lila.png"]];
        self.letterPosMap=[[NSMutableDictionary alloc] init];
        
        [self drawContent:[self returnOffsetFromDrawingHeader]];
        self.letterBar=[[LeckerLetterBar alloc] initWithFrame:CGRectMake(self.bounds.size.width-50,self.ingView.frame.origin.y ,35,self.ingView.frame.size.height )];
        self.letterBar.delegate=self;
        self.selectedItems=[[NSMutableOrderedSet alloc] init];
        [self.contentView addSubview:self.letterBar];

    }
    return self;
}

-(int) returnOffsetFromDrawingHeader {
    UIImageView *bgHeader=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"karopapier_oben.png"]];
    bgHeader.userInteractionEnabled=YES;
    [self.contentView addSubview:bgHeader];
    
    int lastOffcet=bgHeader.frame.origin.y+bgHeader.frame.size.height;
    for(int i=0;i<6;i++) {
        UIImageView *bgmiddle=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"karopapier_mitte.png"]];
        CGRect frame=bgmiddle.frame;
        frame.origin.y=lastOffcet;
        bgmiddle.frame=frame;
        lastOffcet=bgmiddle.frame.origin.y+bgmiddle.frame.size.height;
        [self.contentView addSubview:bgmiddle];
    }
    
    UIImageView *bgBottom=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"karopapier_unten.png"]];
    CGRect frame=bgBottom.frame;
    frame.origin.y=lastOffcet;
    bgBottom.frame=frame;
    [self.contentView addSubview:bgBottom];
    
    self.addButton=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button.png"]];
    frame=self.addButton.frame;
    frame.origin.y+=15;
    frame.origin.x+=40;
    self.addButton.frame=frame;
    [bgHeader addSubview:self.addButton];
    self.addButton.userInteractionEnabled=YES;
    
    self.addLabel=[[UILabel alloc] initWithFrame:self.addButton.bounds];
    self.addLabel.text=@"zurück zur Suche";
    self.addLabel.textColor=[LeckerTools colorFromHexString:@"#54b0c1"];
    self.addLabel.backgroundColor=[UIColor clearColor];
    self.addLabel.textAlignment=NSTextAlignmentCenter;
    self.addLabel.font=[UIFont fontWithName:@"TimesNewRomanPSMT" size:12];
    self.addLabel.numberOfLines=0;
    self.addLabel.userInteractionEnabled=NO;
    frame=self.addLabel.frame;
    frame.size.width-=20;
    frame.origin.x+=10;
    frame.origin.y+=2;
    frame.size.height-=5;
    self.addLabel.frame=frame;
    [self.addButton addSubview:self.addLabel];
    
    UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeLayerTapped:)];
    tap1.numberOfTapsRequired=1;
    [self.addButton addGestureRecognizer:tap1];
    
    self.clearButton=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button.png"] highlightedImage:[UIImage imageNamed:@"button_grau.png"]];
    frame=self.clearButton.frame;
    frame.origin.y+=15;
    frame.origin.x=320-frame.size.width-40;
    self.clearButton.frame=frame;
    self.clearButton.userInteractionEnabled=YES;
    [self.clearButton setHighlighted:YES];
    [bgHeader addSubview:self.clearButton];
    
    self.clearLabel=[[UILabel alloc] initWithFrame:self.addButton.bounds];
    self.clearLabel.text=@"Auswahl aufheben";
    //self.clearLabel.textColor=[LeckerTools colorFromHexString:@"#54b0c1"];
    self.clearLabel.textColor=[LeckerTools colorFromHexString:@"#c7c6c6"];
    self.clearLabel.backgroundColor=[UIColor clearColor];
    self.clearLabel.textAlignment=NSTextAlignmentCenter;
    self.clearLabel.numberOfLines=2;
    self.clearLabel.font=[UIFont fontWithName:@"TimesNewRomanPSMT" size:12];
    frame=self.clearLabel.frame;
    frame.size.width-=20;
    frame.origin.x+=10;
    frame.origin.y+=2;
    frame.size.height-=5;
    self.clearLabel.frame=frame;
    self.clearLabel.userInteractionEnabled=NO;
    [self.clearButton addSubview:self.clearLabel];
    
    UITapGestureRecognizer *tap2=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearAll:)];
    tap2.numberOfTapsRequired=1;
    [self.clearButton addGestureRecognizer:tap2];

    return bgHeader.frame.origin.y+bgHeader.frame.size.height;
}

-(void) drawContent:(int) offset {
    
    self.ingView=[[UIScrollView alloc] initWithFrame:self.contentView.bounds];
    CGRect frame=self.ingView.frame;
    frame.origin.y=offset;
    frame.origin.x+=20;
    frame.size.width-=40;
    frame.size.height=self.contentView.bounds.size.height-offset-20;
    self.ingView.frame=frame;
    int index=0;
    int arrayIndex=0;
    NSString *actualLetter=@"";
    for (NSString *ing in self.ingList) {
        if ([actualLetter isEqualToString:[ing substringToIndex:1]]) {
            LeckerSingleFacetView *facet=[[LeckerSingleFacetView alloc] initWithFrame:CGRectMake(40,index*30, 320, 20) andDataValue:[self.ingMap objectForKey:ing] andOutPutText:ing];
            facet.delegate=self;
            [self.ingView addSubview:facet];
        } else {
            if (arrayIndex==3) arrayIndex=0;
            NSLog(@"%@",((UIImage*)[self.imageArray objectAtIndex:arrayIndex]));
            UIImageView *patchView=[[UIImageView alloc] initWithImage:[self.imageArray objectAtIndex:arrayIndex]];

            CGRect frame=patchView.frame;
            frame.origin.y=(index*30)-3;
            frame.origin.x=-30;
            patchView.frame=frame;
            [self.ingView addSubview:patchView];
            int letterOffset=0;
            switch (arrayIndex) {
                case 0:
                    letterOffset=4;
                    break;
                case 1:
                    letterOffset=0;
                    break;
                case 2:
                   letterOffset=4;
                    break;

            }
            
            UILabel *letterLabel=[[UILabel alloc] initWithFrame:CGRectMake(20,(index*30)+letterOffset, 20, 20)];
            letterLabel.backgroundColor=[UIColor clearColor];
            letterLabel.textColor=[UIColor whiteColor];
            letterLabel.text=[ing substringToIndex:1];
            [self.ingView addSubview:letterLabel];
            
            [self.letterPosMap setObject:[NSNumber numberWithInt:(index*30)+letterOffset] forKey:[ing substringToIndex:1]];
            arrayIndex++;
            index++;
            LeckerSingleFacetView *facet=[[LeckerSingleFacetView alloc] initWithFrame:CGRectMake(40,index*30, 320, 20) andDataValue:[self.ingMap objectForKey:ing] andOutPutText:ing];
            facet.delegate=self;
            [self.ingView addSubview:facet];
            actualLetter=[ing substringToIndex:1];
        }
        
        index++;
    }
    
    self.ingView.contentSize=CGSizeMake(240, index*30);
    self.ingView.clipsToBounds=YES;
    [self.contentView addSubview:self.ingView];
}

-(void) letterTouched:(int)letterIndex {
    CGRect frame=self.ingView.frame;
    NSNumber *num=[self.letterPosMap objectForKey:[NSString stringWithFormat:@"%c", letterIndex]];
    while (num==nil) {
        letterIndex--;
        num=[self.letterPosMap objectForKey:[NSString stringWithFormat:@"%c", letterIndex]];
    }
    frame.origin.y=num.intValue;
    [self.ingView scrollRectToVisible:frame animated:NO];
}

-(void) closeLayerTapped:(UITapGestureRecognizer*) tap {
    if([self.delegate respondsToSelector:@selector(addIngredientsSetToSearch:)]) {
        [self.delegate addIngredientsSetToSearch:self.selectedItems.copy];
    }
    if([self.delegate respondsToSelector:@selector(closeLayer)]) {
        [self.delegate closeLayer];
    }
}

-(void) ingredientsAddToList:(NSString *)ing {
    [self.selectedItems addObject:ing];
    self.addLabel.text=@"hinzufügen";
    self.clearButton.highlighted=NO;
    self.clearLabel.textColor=[LeckerTools colorFromHexString:@"#54b0c1"];
}

-(void) ingredientsRemoveFromList:(NSString *)ing {
    [self.selectedItems removeObject:ing];
    if (self.selectedItems.count==0) {
        self.clearLabel.textColor=[LeckerTools colorFromHexString:@"#c7c6c6"];
        self.clearButton.highlighted=YES;
        self.addLabel.text=@"zurück zur Suche";
    }
}


-(void) clearAll:(UITapGestureRecognizer*) tap {
    for (UIView *view in self.ingView.subviews) {
        if([view respondsToSelector:@selector(unTap)]) {
            [view performSelector:@selector(unTap)];
        }
    }
    self.clearLabel.textColor=[LeckerTools colorFromHexString:@"#c7c6c6"];
    [self.selectedItems removeAllObjects];
    self.clearButton.highlighted=YES;
    self.addLabel.text=@"zurück zur Suche";
}



@end
