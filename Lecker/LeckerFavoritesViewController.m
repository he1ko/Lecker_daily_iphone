//
//  LeckerFavoritesViewController.m
//  Lecker
//
//  Created by Naujeck, Marcel on 14.01.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerFavoritesViewController.h"
#import "DataManager.h"
#import <QuartzCore/QuartzCore.h>
#import <INFOnlineLibrary/INFOnlineLibrary.h>
#import "LeckerAppDelegate.h"


@interface LeckerFavoritesViewController ()
@property LeckerFavoritesMainView *mainView;
@property LeckerRecipeDetailView *recipeDetail;
@property SASBannerView *banner;
@end

@implementation LeckerFavoritesViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(id) init {
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Meine Rezepte", @"Meine Rezepte");
        UIImage *tmp=[UIImage imageNamed:@"icon_heart.png"];
        self.tabBarItem.image = tmp;
        self.mainView=[[LeckerFavoritesMainView alloc] initWithFrame:self.view.frame andRecipeList:[[DataManager getInstance] getAllFavRecipes]];
        self.mainView.delegate=self;
        [self.view addSubview:self.mainView];

        
    }
    return self;
}

-(void) recipePressedWithRecipe:(LeckerSingleRecipeDetailModel *)recipe {
    self.recipeDetail=[[LeckerRecipeDetailView alloc] initWithFrame:self.view.bounds];
    self.recipeDetail.delegate=self;
    [self.recipeDetail showRecipe:recipe withImage:[UIImage imageWithData:recipe.image]];
    [UIView transitionFromView:self.mainView toView:self.recipeDetail duration:0.6f options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:^(BOOL finished) {
                        [((LeckerAppDelegate *)[[UIApplication sharedApplication] delegate]).tracker trackEventWithCategory:@"Controller" withAction:@"FavoritesController" withLabel:@"RecipeDetailViewOpen" withValue:nil];

                        [[IOLSession defaultSession] logEventWithType:IOLEventTypeView state:IOLViewAppeared category:@"RecipeDetailViewOpen" comment:@"RecipeDetailViewOpen"];
                        [self.banner removeFromSuperview];
                    }];
}

-(void) backButtonPressed {
    [UIView transitionFromView:self.recipeDetail toView:self.mainView duration:0.6f options:UIViewAnimationOptionTransitionFlipFromRight
                    completion:^(BOOL finished) {
                        [self initBanner];
                    }];
}

-(void) updateFavView {
    [self.mainView showFavList:[[DataManager getInstance] getAllFavRecipes]];
}

-(void) recipeRemoveFromFav:(NSString *)contentId {
    [[DataManager getInstance] deleteRecipeFromFavWithContentId:contentId];
    if([self.delegate respondsToSelector:@selector(numberOfFavChanged)]) {
        [self.delegate numberOfFavChanged];
    }
}

-(void) deleteSetFromFavs:(NSSet *)removeSet {
    for (NSString *contentId in removeSet) {
        [[DataManager getInstance] deleteRecipeFromFavWithContentId:contentId];
    }
    if([self.delegate respondsToSelector:@selector(numberOfFavChanged)]) {
        [self.delegate numberOfFavChanged];
    }
}

-(void) addIngredientsSet:(NSSet *)ingSet {
    [[DataManager getInstance] addToShoppingCard:ingSet];
    if([self.delegate respondsToSelector:@selector(numberofShoppingListItemsChanged)]) {
        [self.delegate numberofShoppingListItemsChanged];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void) viewDidDisappear:(BOOL)animated {
     [((LeckerAppDelegate *)[[UIApplication sharedApplication] delegate]).tracker trackEventWithCategory:@"Controller" withAction:@"FavoritesController" withLabel:@"Disappear" withValue:nil]; 
}

-(void) viewDidAppear:(BOOL)animated {
    [((LeckerAppDelegate *)[[UIApplication sharedApplication] delegate]).tracker trackEventWithCategory:@"Controller" withAction:@"FavoritesController" withLabel:@"Appear" withValue:nil]; 
    [[IOLSession defaultSession] logEventWithType:IOLEventTypeView state:IOLViewAppeared category:@"FavoriteViewOpen" comment:@"DailyRecipeViewOpen"];
    [self initBanner];
}

-(void) initBanner {
    CGRect frame=self.view.bounds;
    
    [self.banner removeFromSuperview];
    self.banner=[[SASBannerView alloc] initWithFrame:CGRectMake(10,frame.size.height-60, 300, 50)
                                              loader:SASLoaderActivityIndicatorStyleWhite];
    self.banner.delegate=self;
    self.banner.layer.cornerRadius=5;
    self.banner.layer.borderWidth=1.5;
    self.banner.layer.borderColor=[UIColor blackColor].CGColor;
    self.banner.clipsToBounds=YES;
    [self.banner loadFormatId:20355 pageId:@"320702" master:YES target:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) adViewDidLoad:(SASAdView *)adView {
    [self.mainView addSubview:self.banner];
}

@end
