//
//  LeckerSearchViewController.m
//  Lecker
//
//  Created by Naujeck, Marcel on 14.01.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerSearchViewController.h"
#import "LeckerDailyRecipeMainView.h"
#import "DataManager.h"
#import "LeckerAppDelegate.h"
#import <INFOnlineLibrary/INFOnlineLibrary.h>
#import <Social/Social.h>


@interface LeckerSearchViewController ()
@property LeckerSearchMainView *mainView;
@property LeckerDailyRecipeMainView *resultView;
@property LeckerSingleRecipeDetailModel *actualRecipe;
@property LeckerRecipeDetailView *detailView;
@property NSString *actualSearchString;
@property BOOL initial;
@property int searchResultIndex;
@property BOOL isInResultView;
@property Boolean favLoad;
@property UIImage *actualRecipeImage;
@property Boolean offlineMode;
@property NSString *requestId;
@property LeckerOfflineView *offlineView;
@property Boolean isInAction;
@property SASBannerView *bannerView;
@property NSString *choose;


@end

@implementation LeckerSearchViewController

-(id) init {
    self = [super init];
    if (self) {
        self.requestId=nil;
        CGRect tmpFrame=[UIScreen mainScreen].bounds;
        tmpFrame.size.height-=49;
        self.view.frame=tmpFrame;
        
        self.title = NSLocalizedString(@"Suche", @"Suche");
        UIImage *tmp=[UIImage imageNamed:@"icon_search.png"];
        self.tabBarItem.image = tmp;
        self.initial=YES;
    }
    return self;
}

#pragma mark - UIViewController lifetime
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void) viewDidDisappear:(BOOL)animated {
    [((LeckerAppDelegate *)[[UIApplication sharedApplication] delegate]).tracker trackEventWithCategory:@"Controller" withAction:@"SearchController" withLabel:@"Disappear" withValue:nil];
}

-(void) viewDidAppear:(BOOL)animated {
    [((LeckerAppDelegate *)[[UIApplication sharedApplication] delegate]).tracker trackEventWithCategory:@"Controller" withAction:@"SearchController" withLabel:@"Appear" withValue:nil]; 
    [[IOLSession defaultSession] logEventWithType:IOLEventTypeView state:IOLViewAppeared category:@"SearchViewOpen" comment:@"DailyRecipeViewOpen"];
    if (self.initial) {
        self.mainView=[[LeckerSearchMainView alloc] initWithFrame:self.view.frame andFacetGroupList:[[DataManager getInstance] facetGroupList]];
        self.mainView.delegate=self;
        [self.view insertSubview:self.mainView atIndex:0];
        self.initial=NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) doSearchWithSearchObject:(SearchObject *)so {
    self.requestId=nil;
    self.searchResultIndex=0;
    self.isInResultView=NO;
    self.actualSearchString=[self createSearchMsgStringFromSearchObject:so];
    self.resultView=[[LeckerDailyRecipeMainView alloc] initWithFrame:self.view.frame pinView:NO];
    self.resultView.delegate=self;
    [self.resultView enableBackButton];
    [self pullNextRecipes];
}

-(void) communicationFinishSuccessfulWithJSON:(NSDictionary *)json inStatus:(RSAStatus)status {
    self.isInAction=NO;
    if (status==RSAStatus_SEARCHREQUEST) {
        [(LeckerAppDelegate *)[[UIApplication sharedApplication] delegate] unlockApp];
        NSString *urlString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ImageServerURL"];
        
        int maxIndex=((NSString*)[[json objectForKey:@"CMSContentList"]objectForKey:@"hits"]).intValue;
        [((LeckerAppDelegate *)[[UIApplication sharedApplication] delegate]).tracker trackEventWithCategory:@"Search" withAction:@"Searchresult" withLabel:@"Hits" withValue:[NSNumber numberWithInt:maxIndex]];
        NSLog(@"Resuls Found:%d Actual Index:%d",maxIndex,self.searchResultIndex);
        self.searchResultIndex+=((NSString*)[[json objectForKey:@"CMSContentList"]objectForKey:@"entriesPerPage"]).intValue;
        
        for (NSDictionary *entry in [[json objectForKey:@"CMSContentList"]objectForKey:@"entries"]) {
            LeckerSingleRecipeOverviewModel *tmpModel=[[LeckerSingleRecipeOverviewModel alloc] init];
            [tmpModel setContendId:[entry objectForKey:@"contentId"]];
            [tmpModel setDescription:[entry objectForKey:@"description"]];
            if ([entry objectForKey:@"thumbnail"]!=nil) {
                [tmpModel setThumbnailUrl:[urlString stringByAppendingString:[entry objectForKey:@"thumbnail"]]];
            } else {
                [tmpModel setThumbnailUrl:nil];
            }
            
            [tmpModel setTitle:[entry objectForKey:@"title"]];
            BOOL isFav=[[DataManager getInstance] favAlreadyInDB:tmpModel.contendId];
            [self.resultView addViewWithModel:tmpModel andFav:isFav];
        }
        if (!self.isInResultView) {
            self.isInResultView=YES;
            
            if(maxIndex==0) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Keine Suchergebnisse"
                                                                    message:[NSString stringWithFormat:@"Es wurden leider keine Rezepte zu Ihrer Auswahl gefunden. %@",self.choose]
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
            } else {
                [self.resultView initalSetup];
                [self.resultView setMax:maxIndex];
                [self requestNewAdForBanner];
                [UIView transitionFromView:self.mainView toView:self.resultView duration:0.3 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
                    
                }];
            }
        }
    }
    else if (status==RSAStatus_RECIPEREQUEST)
    {
        [(LeckerAppDelegate *)[[UIApplication sharedApplication] delegate] unlockApp];
        self.actualRecipe=[[LeckerSingleRecipeDetailModel alloc] init];
        [self.actualRecipe parseRecipeFromJson:json];
        if(!self.favLoad) {
            self.detailView=[[LeckerRecipeDetailView alloc] initWithFrame:self.view.bounds];
            self.detailView.delegate=self;
            [self.detailView showRecipe:self.actualRecipe withImage:self.actualRecipeImage];
            [UIView transitionFromView:self.resultView toView:self.detailView duration:0.6f options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
                [((LeckerAppDelegate *)[[UIApplication sharedApplication] delegate]).tracker trackEventWithCategory:@"Controller" withAction:@"SearchController" withLabel:@"RecipeDetailViewOpen" withValue:nil];

            }];
        } else {
            [[DataManager getInstance] insertFavRecipeWithRecipe:self.actualRecipe andImage:self.actualRecipeImage];
            if([self.delegate respondsToSelector:@selector(numberOfFavChanged)]) {
                [self.delegate numberOfFavChanged];
            }
        }
    }
}

-(void) optionalBackButtonPressed {
    [UIView transitionFromView:self.resultView toView:self.mainView duration:0.3 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
        
    }];
    
}

-(void)communicationFailedinStatus:(RSAStatus)status {
    self.isInAction=YES;
    [(LeckerAppDelegate *)[[UIApplication sharedApplication] delegate] unlockApp];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Verbindungsfehler"
                                                        message:@"Versuchen Sie es erneut oder aktivieren Sie den Offlinemodus"
                                                       delegate:self
                                              cancelButtonTitle:@"Erneut Versuchen"
                                              otherButtonTitles:@"Offlinemodus", nil];
    [alertView show];
}

-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex==0) {
            if (self.requestId!=nil) {
                [[RSACommunication getInstance] setDelegate:self];
                [[RSACommunication getInstance] doRecipeRequestForId:self.requestId];
            } else {
                [self pullNextRecipes];
            }
        
    } else {
        [self.resultView updateArrayForFavWithSet:[[DataManager getInstance] getAllRecipeContentIDs]];
        if([self.delegate respondsToSelector:@selector(switchToOffline)]) {
            [self.delegate switchToOffline];
        }
    }
}

-(void) backButtonPressed {
    [UIView transitionFromView:self.detailView toView:self.resultView duration:0.6f options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
    }];
}

-(NSString*) createSearchMsgStringFromSearchObject:(SearchObject*) so {
    NSString *resultString=@"RequestType=search";
    NSDictionary *faces=[[DataManager getInstance] getAllFacetsAsHash];
    self.choose=@"";
    
    if(so.searchIngSet.count>0) {
        [((LeckerAppDelegate *)[[UIApplication sharedApplication] delegate]).tracker trackEventWithCategory:@"Search" withAction:@"Searchrequest" withLabel:@"WithIngredients" withValue:nil]; 
        resultString=[resultString stringByAppendingString:@"&ingredients="];
        NSString *fristChar_1=@"";
        NSString *fristChar_2=@"";
        self.choose=[self.choose stringByAppendingString:@"\n\nZutaten:\n"];
        for (NSString *ing in so.searchIngSet) {
            self.choose=[self.choose stringByAppendingFormat:@"%@%@",fristChar_2,[faces objectForKey:ing]];
            resultString=[resultString stringByAppendingFormat:@"%@+%@",fristChar_1,ing];
            fristChar_1=@",";
            fristChar_2=@", ";
        }
    }
    
    if(so.searchRecipePropSet.count>0) {
        [((LeckerAppDelegate *)[[UIApplication sharedApplication] delegate]).tracker trackEventWithCategory:@"Search" withAction:@"Searchrequest" withLabel:@"WithRecipeProperties" withValue:nil];
        resultString=[resultString stringByAppendingString:@"&recipeproperties="];
        NSString *fristChar_1=@"";
        NSString *fristChar_2=@"";
        self.choose=[self.choose stringByAppendingString:@"\n\nRezept-Eigenschaften:\n"];
        for (NSString *prop in so.searchRecipePropSet) {
            self.choose=[self.choose stringByAppendingFormat:@"%@%@",fristChar_2,[faces objectForKey:prop]];
            resultString=[resultString stringByAppendingFormat:@"%@+%@",fristChar_1,prop];
            fristChar_1=@",";
            fristChar_2=@", ";
        }
    }
    
    if(so.searchRecipeTypeSet.count>0) {
        [((LeckerAppDelegate *)[[UIApplication sharedApplication] delegate]).tracker trackEventWithCategory:@"Search" withAction:@"Searchrequest" withLabel:@"WithFoodType" withValue:nil];
        resultString=[resultString stringByAppendingString:@"&foodtype="];
        NSString *fristChar_1=@"";
        NSString *fristChar_2=@"";
        self.choose=[self.choose stringByAppendingString:@"\n\nRezept-Kategorie:\n"];
        for (NSString *type in so.searchRecipeTypeSet) {
            self.choose=[self.choose stringByAppendingFormat:@"%@%@",fristChar_2,[faces objectForKey:type]];
            resultString=[resultString stringByAppendingFormat:@"%@+%@",fristChar_2,type];
            fristChar_1=@",";
            fristChar_2=@", ";
        }
    }
    
    if(so.searchkcal>0) {
        [((LeckerAppDelegate *)[[UIApplication sharedApplication] delegate]).tracker trackEventWithCategory:@"Search" withAction:@"Searchrequest" withLabel:@"WithKCal" withValue:nil];
        resultString=[resultString stringByAppendingFormat:@"&kcal=+[0,%d]",so.searchkcal];
        self.choose=[self.choose stringByAppendingFormat:@"\n\nkcal pro Portion:\nzwischen 0 und %d kcal",so.searchkcal];
    }

    if(so.searchPrepTime>0) {
        [((LeckerAppDelegate *)[[UIApplication sharedApplication] delegate]).tracker trackEventWithCategory:@"Search" withAction:@"Searchrequest" withLabel:@"WithPrepTime" withValue:nil];
        resultString=[resultString stringByAppendingFormat:@"&time=+[0,%d]",so.searchPrepTime];
        self.choose=[self.choose stringByAppendingFormat:@"\n\nZubereitungszeit:\nzwischen 0 und %d Min",so.searchPrepTime];
    }
    
    if(![[so.query stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] && so.query!=nil ) {
        [((LeckerAppDelegate *)[[UIApplication sharedApplication] delegate]).tracker trackEventWithCategory:@"Search" withAction:@"Searchrequest" withLabel:@"WithQueryString" withValue:nil];
        self.choose=[self.choose stringByAppendingFormat:@"\n\nSuchfeld:\n%@",[so.query stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]];
        resultString=[resultString stringByAppendingFormat:@"&query=%@",[so.query stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]];
    }
    
    resultString=[resultString stringByAppendingString:@"&sortby=score&sortdir=desc"];
    NSLog(@"resultString: %@", resultString);
    return resultString;
}

-(void) pullNextRecipes {
    [(LeckerAppDelegate *)[[UIApplication sharedApplication] delegate] lockApp];
    [[RSACommunication getInstance] setDelegate:self];
    [[RSACommunication getInstance] doSearchRequestWithMessage:self.actualSearchString andIndex:self.searchResultIndex];
}

-(void) addToFavPressedWithContentId:(NSString *)contentId andImage:(UIImage *)image {
    self.favLoad=YES;
    if (contentId==self.actualRecipe.contentId) {
        [[DataManager getInstance] insertFavRecipeWithRecipe:self.actualRecipe andImage:image];
        if([self.delegate respondsToSelector:@selector(numberOfFavChanged)]) {
            [self.delegate numberOfFavChanged];
        }
    } else {
        self.actualRecipeImage=image;
        self.requestId=contentId;
        [RSACommunication getInstance].delegate=self;
        [[RSACommunication getInstance] doRecipeRequestForId:contentId];
        
    }
}

-(void) removeFromFavPressedWithContentId:(NSString *)contentId {
    [[DataManager getInstance] deleteRecipeFromFavWithContentId:contentId];
    if([self.delegate respondsToSelector:@selector(numberOfFavChanged)]) {
        [self.delegate numberOfFavChanged];
    }
}

-(void) recipeActivateWithContentId:(NSString *)contentId recipeImage:(UIImage *)image{
    self.favLoad=NO;
    LeckerSingleRecipeDetailModel *recipe=[[DataManager getInstance] getRecipeWithContentId:contentId];
    self.requestId=nil;
    if(recipe==nil) {
        [(LeckerAppDelegate *)[[UIApplication sharedApplication] delegate] lockApp];
        self.actualRecipeImage=image;
        self.requestId=contentId;
        [[RSACommunication getInstance] doRecipeRequestForId:contentId];
    } else {
        self.actualRecipe=recipe;
        self.actualRecipeImage=image;
        self.detailView=[[LeckerRecipeDetailView alloc] initWithFrame:self.view.bounds];
        self.detailView.delegate=self;
        [self.detailView showRecipe:self.actualRecipe withImage:self.actualRecipeImage];
        [UIView transitionFromView:self.resultView toView:self.detailView duration:0.6f options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {}];
    }
}

-(void) updateMainView {
    [self.resultView updateArrayForFavWithSet:[[DataManager getInstance] getAllRecipeContentIDs]];
}

-(void) addIngredientsSet:(NSSet *)ingSet {
    [[DataManager getInstance] addToShoppingCard:ingSet];
    if([self.delegate respondsToSelector:@selector(numberofShoppingListItemsChanged)]) {
        [self.delegate numberofShoppingListItemsChanged];
    }
}

-(void) toggleToOffline {
    if (!self.offlineMode) {
        NSLog(@"Search: %f %f",self.view.bounds.origin.y,self.view.bounds.size.height);
        self.offlineMode=YES;
        self.offlineView=[[LeckerOfflineView alloc] initWithFrame:self.view.bounds];
        self.offlineView.delegate=self;
        [self.view addSubview:self.offlineView];
    }
}

-(void) toggleToOnline {
    [self.offlineView removeFromSuperview];
    self.offlineMode=NO;
    if(self.isInAction) {
        if (self.requestId!=nil) {
            [[RSACommunication getInstance] setDelegate:self];
            [[RSACommunication getInstance] doRecipeRequestForId:self.requestId];
        } else {
            [self pullNextRecipes];
        }
    }
}

-(void) retryConnectionPressed {
    if([self.delegate respondsToSelector:@selector(switchToOnline)]) {
        [self.delegate switchToOnline];
    }
}

-(void) requestNewAdForBanner {
    self.bannerView=[[SASBannerView alloc] initWithFrame:CGRectMake(0, 0, 300, 50) loader:SASLoaderActivityIndicatorStyleWhite];
    self.bannerView.delegate=self;
    [self.bannerView loadFormatId:20355 pageId:@"320701" master:YES target:nil];
}

-(void) adViewDidLoad:(SASAdView *)adView {
    [self.resultView createBanner:(SASBannerView*)adView];
}

-(void) adViewDidFailToLoad:(SASAdView *)adView error:(NSError *)error {
    
}

-(void) facebookShareWithTitle:(NSString *)title Image:(UIImage *)image Id:(NSString *)recipeId {
    SLComposeViewController *test=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [test addURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.lecker.de/rezept/%@/facebook.html",recipeId]]];
    //[test setInitialText:[NSString stringWithFormat:@"",title]];
    //[test addImage:[LeckerTools scaleImage:image withFactor:0.7]];
    
    [self presentViewController:test animated:YES completion:nil];
}


@end
