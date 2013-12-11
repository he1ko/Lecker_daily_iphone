//
//  LeckerSearchSelectionView.m
//  Lecker
//
//  Created by Naujeck, Marcel on 25.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerSearchSelectionView.h"
#import <QuartzCore/QuartzCore.h>
#import "FacetGroup.h"



@interface LeckerSearchSelectionView()
@property UIImageView *searchFieldImage;
@property UISearchBar *searchFieldText;
@property LeckerFacetTextView *categoryFacets;
@property LeckerFacetTextView *propFacets;
@property UIImageView *ingChooser;
@property LeckerFacetSliderView *prepTimeSlider;
@property LeckerFacetSliderView *kcalSlider;
@property LeckerIngLayerView *ingChooserLayer;

@property NSOrderedSet *searchIngSet;
@property NSMutableOrderedSet *searchRecipePropSet;
@property NSMutableOrderedSet *searchRecipeTypeSet;
@property int searchPrepTime;
@property int searchkcal;

@property UILabel *countBubble;
@end


@implementation LeckerSearchSelectionView
@synthesize searchRecipePropSet=_searchRecipePropSet;
@synthesize searchRecipeTypeSet=_searchRecipeTypeSet;

-(void)setSearchRecipePropSet:(NSMutableOrderedSet *) s  {
    _searchRecipePropSet=s;
}

-(NSMutableOrderedSet *)searchRecipePropSet {
    if(!_searchRecipePropSet) _searchRecipePropSet=[[NSMutableOrderedSet alloc] init];
    return _searchRecipePropSet;
}

-(void) setSearchRecipeTypeSet:(NSMutableOrderedSet *)s{
    _searchRecipeTypeSet=s;
}

-(NSMutableOrderedSet *) searchRecipeTypeSet {
    if(!_searchRecipeTypeSet) _searchRecipeTypeSet=[[NSMutableOrderedSet alloc] init];
    return _searchRecipeTypeSet;
}

- (id)initWithFrame:(CGRect)frame andFacetGroupList:(NSArray*) facetGroupList
{
    self = [super initWithFrame:frame];
    if (self) {
        self.alwaysBounceVertical = YES;
        self.delegate=self;
        self.searchFieldImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Suchfeld.png"]];
        CGRect frame=self.searchFieldImage.frame;
        frame.origin.x+=10;
        self.searchFieldImage.frame=frame;
        self.searchFieldImage.userInteractionEnabled=YES;
        [self addSubview:self.searchFieldImage];
        
        self.searchFieldText = [[UISearchBar alloc] init];
        self.searchFieldText.userInteractionEnabled=YES;
        self.searchFieldText.BackgroundColor=[UIColor whiteColor];
        self.searchFieldText.frame = CGRectMake(17, 67, 230, 29); // SK width was 255 but textfield over loupe image
        //self.searchFieldText.backgroundColor = [UIColor orangeColor];
        self.searchFieldText.placeholder = @"Suchbegriff...";
        self.searchFieldText.keyboardType=UIKeyboardTypeDefault;
        self.searchFieldText.tintColor=[UIColor whiteColor];
        self.searchFieldText.showsScopeBar=NO;
        [[[self.searchFieldText subviews] objectAtIndex:0] setAlpha:0.0];
        for (UIView *view in self.searchFieldText.subviews)
        { 
            if ([view isKindOfClass:[UITextField class]]) {
                UITextField *tmp=(UITextField *)view;
                tmp.background=nil;
                tmp.borderStyle=UITextBorderStyleNone;
                tmp.font = [UIFont fontWithName:@"DroidSans" size:20];
                break;
            } else {
                view.hidden=YES;
            }
        }
        [self.searchFieldImage addSubview:self.searchFieldText];
        self.searchFieldText.delegate=self;
        self.contentSize=CGSizeMake(320, 910);
        for (FacetGroup *group in facetGroupList) {
            if([group.name isEqualToString:@"Rezept-Typ"]) {
                self.categoryFacets=[[LeckerFacetTextView alloc] initWithPoint:CGPointMake(11,120) withImage:[UIImage imageNamed:@"Suchfeld_kategorie.png"] facet:@"Rezept-Typ" andFacetMap:group.facetexpr];
                [self addSubview:self.categoryFacets];
                self.categoryFacets.delegate=self;
            }
            
            if([group.name isEqualToString:@"Rezept-Eigenschaften"]) {
                self.propFacets=[[LeckerFacetTextView alloc] initWithPoint:CGPointMake(11,655) withImage:[UIImage imageNamed:@"Suchfeld_eigenschaften.png"] facet:@"Rezept-Eigenschaften" andFacetMap:group.facetexpr];
                [self addSubview:self.propFacets];
                self.propFacets.delegate=self;
            }
            
            if([group.name isEqualToString:@"Zutaten"]) {
                self.ingChooserLayer=[[LeckerIngLayerView alloc] initWithFrame:self.bounds andFacetMap:group.facetexpr];
                self.ingChooserLayer.delegate=self;
            }
        }
        
        self.ingChooser=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zutaten_waehlen2.png"]];
        frame=self.ingChooser.frame;
        frame.origin.y+=365;
        frame.origin.x+=160-frame.size.width/2;
        self.ingChooser.frame=frame;
        self.ingChooser.userInteractionEnabled=YES;
        [self addSubview:self.ingChooser];
        
        self.countBubble=[[UILabel alloc] initWithFrame:self.ingChooser.bounds];
        self.countBubble.text=@"0";
        self.countBubble.textColor=[UIColor whiteColor];
        self.countBubble.backgroundColor=[UIColor redColor];
        self.countBubble.textAlignment=NSTextAlignmentCenter;
        self.countBubble.numberOfLines=1;
        self.countBubble.font=[UIFont fontWithName:@"DroidSans" size:11];
        self.countBubble.layer.borderColor=[UIColor whiteColor].CGColor;
        self.countBubble.layer.borderWidth=0.5;

        
        self.countBubble.layer.cornerRadius=5;
        frame=self.countBubble.frame;
        frame.size.height=16;
        frame.size.width=15;
        frame.origin.x+=1;
        frame.origin.y+=1;
        
        self.countBubble.frame=frame;
        [self.ingChooser addSubview:self.countBubble];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openIngLayer:)];
        tap.numberOfTapsRequired=1;
        [self.ingChooser addGestureRecognizer:tap];
        
        self.prepTimeSlider=[[LeckerFacetSliderView alloc] initWithFrame:CGPointMake(11, 420) backgroundImage:[UIImage imageNamed:@"Suchfeld_zeit.png"] intervalStart:0 intervalEnd:120 unit:@"(in Minuten)" interval:10 slidername:@"prepTime"];
        [self addSubview:self.prepTimeSlider];
        self.prepTimeSlider.delegate=self;
        
        self.kcalSlider=[[LeckerFacetSliderView alloc] initWithFrame:CGPointMake(11, 537) backgroundImage:[UIImage imageNamed:@"Suchfeld_kalorien.png"] intervalStart:0 intervalEnd:2000 unit:@"" interval:50 slidername:@"kcal"];
        [self addSubview:self.kcalSlider];
        self.kcalSlider.delegate=self;
        
        UIImageView *searchButton=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Suchen-Button.png"]];
        frame=searchButton.frame;
        frame.origin.y=self.propFacets.frame.origin.y+self.propFacets.frame.size.height+15;
        frame.origin.x=160-frame.size.width/2;
        searchButton.frame=frame;
        
        UITapGestureRecognizer *searchTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchTapped:)];
        searchTap.numberOfTapsRequired=1;
        [searchButton addGestureRecognizer:searchTap];
        searchButton.userInteractionEnabled=YES;
        [self addSubview:searchButton];
  
    }
    return self;
}

-(void) searchTapped:(UITapGestureRecognizer*) tap {
    SearchObject *so=[[SearchObject alloc] init];
    so.searchIngSet=self.searchIngSet;
    so.searchkcal=self.searchkcal;
    so.searchPrepTime=self.searchPrepTime;
    so.searchRecipePropSet=self.searchRecipePropSet;
    so.searchRecipeTypeSet=self.searchRecipeTypeSet;
    so.query=self.searchFieldText.text;
    
    if([self.searchdelegate respondsToSelector:@selector(doSearchWithSearchObject:)]) {
        [self.searchdelegate doSearchWithSearchObject:so];
    }
}

-(void) openIngLayer:(UITapGestureRecognizer*) tap {
    CGRect frame1=self.superview.bounds;
    CGRect frame2=self.ingChooser.frame;
    self.ingChooserLayer.alpha=0;
    self.ingChooserLayer.frame=frame2;
    self.ingChooserLayer.clipsToBounds=YES;
    [self.superview addSubview:self.ingChooserLayer];
    [UIView animateWithDuration:0.5 animations:^{
        self.ingChooserLayer.frame=frame1;
        self.ingChooserLayer.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

-(void) closeLayer {

    CGRect frame2=self.ingChooser.frame;

    [UIView animateWithDuration:0.5 animations:^{
        self.ingChooserLayer.frame=frame2;
        self.ingChooserLayer.alpha=0;
    } completion:^(BOOL finished) {
        [self.ingChooserLayer removeFromSuperview];
        self.ingChooserLayer.frame=self.bounds;
    }];
}


-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.searchFieldText resignFirstResponder];
}

-(void) addIngredientsSetToSearch:(NSOrderedSet *)ingSet {
    self.searchIngSet=[[NSOrderedSet alloc] initWithOrderedSet:ingSet];
    self.countBubble.text=[NSString stringWithFormat:@"%d",self.searchIngSet.count];
}

-(void) addFacetToSelectionList:(NSString *)facet intoGroup:(NSString *)facetGroup {
    if ([facetGroup isEqualToString:@"Rezept-Typ"]) {
        [self.searchRecipeTypeSet addObject:facet];
        
    } else if ([facetGroup isEqualToString:@"Rezept-Eigenschaften"]) {
        [self.searchRecipePropSet addObject:facet];
    }
}

-(void) removeFacetFromSelectionList:(NSString *)facet fromGroup:(NSString *)facetGroup {
    if ([facetGroup isEqualToString:@"Rezept-Typ"]) {
        [self.searchRecipeTypeSet removeObject:facet];
        
    } else if ([facetGroup isEqualToString:@"Rezept-Eigenschaften"]) {
        [self.searchRecipePropSet removeObject:facet];
    }
}


-(void) sliderChangeValueTo:(int)value withName:(NSString *)name{
    if ([name isEqualToString:@"prepTime"]) {
        self.searchPrepTime=value;
        
    } else if ([name isEqualToString:@"kcal"]) {
        self.searchkcal=value;
    }
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchFieldText resignFirstResponder];
    [self searchTapped:nil];
}

#pragma mark - UIScrollViewDelegate

// SK: Remove Keyboard when user scrolls
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.searchFieldText isFirstResponder])
    {
        [self.searchFieldText resignFirstResponder];        
    }
}

@end
