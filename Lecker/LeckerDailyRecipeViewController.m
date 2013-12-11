//
//  LeckerDailyRecipeViewController.m
//  Lecker
//
//  Created by Naujeck, Marcel on 14.01.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerDailyRecipeViewController.h"
#import "LeckerAppDelegate.h"
#import "LeckerSingleRecipeOverviewModel.h"
#import "LeckerSingleRecipeDetailModel.h"
#import "DataManager.h"
#import "LeckerAdView.h"
#import <INFOnlineLibrary/INFOnlineLibrary.h>
#import <Social/Social.h>
#import "LeckerTools.h"

@interface LeckerDailyRecipeViewController ()

@property LeckerDailyRecipeMainView *mainView;
@property LeckerRecipeDetailView *detailView;
@property NSDate *lastPullDate;
@property Boolean initialLoad;
@property LeckerSingleRecipeDetailModel *actualRecipe;
@property LeckerOfflineView *offlineView;
@property UIImage *actualRecipeImage;
@property Boolean favLoad;
@property Boolean offlineMode;
@property Boolean isInAction;
@property NSString *requestId;
@property SASBannerView *bannerView;
@property NSMutableArray *singleRecipeOverviewArray;
@property BOOL bannerActiv;
@property LeckerDailyPinView *dailyPinView;
@property BOOL isInPinVIew;
@property NSMutableDictionary *favImageCache;
@property NSMutableDictionary *favRecipeCache;
@end

@implementation LeckerDailyRecipeViewController



- (id)init
{
    if (self = [super init]) {
        self.favImageCache=[[NSMutableDictionary alloc] init];
        self.favRecipeCache=[[NSMutableDictionary alloc] init];
        self.isInPinVIew=NO;
        self.singleRecipeOverviewArray=[[NSMutableArray alloc] init];
        CGRect tmpFrame=[UIScreen mainScreen].bounds;
        tmpFrame.size.height-=49;
        self.view.frame=tmpFrame;
        
        self.initialStart=YES;
        self.initialLoad=YES;
        self.offlineMode=NO;
        self.title = NSLocalizedString(@"Tagesgericht", @"Tagesgericht");
        UIImage *tmp=[UIImage imageNamed:@"icon_calendar.png"];
        self.tabBarItem.image = tmp;
    }
    NSLog(@"Daily %f %f",[UIScreen mainScreen].bounds.size.height,self.view.bounds.size.height);
    return self;
}

#pragma mark - Lifecycle

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

-(void) viewDidDisappear:(BOOL)animated {
    [((LeckerAppDelegate *)[[UIApplication sharedApplication] delegate]).tracker trackEventWithCategory:@"Controller" withAction:@"DailyRecipeController" withLabel:@"Disappear" withValue:nil];
}

-(void) viewDidAppear:(BOOL)animated {
    [((LeckerAppDelegate *)[[UIApplication sharedApplication] delegate]).tracker trackEventWithCategory:@"Controller" withAction:@"DailyRecipeController" withLabel:@"Appear" withValue:nil];
    [[IOLSession defaultSession] logEventWithType:IOLEventTypeView state:IOLViewAppeared category:@"DailyRecipeViewOpen" comment:@"DailyRecipeViewOpen"];
    if (self.initialStart && !self.offlineMode) {
        [self reInitializeMainVIew];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL rated = [defaults boolForKey:@"alreadyRated"];
    if(!rated) {
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *components = [cal components:NSWeekdayCalendarUnit fromDate:[[NSDate alloc] init]];
        int currentWeekday = [components weekday]; // Weekday 1-7, Sunday = 1
        int lastReminderWeekday = [defaults integerForKey:@"reminderDay"];
        if(currentWeekday != lastReminderWeekday)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Bitte bewerten Sie die Lecker-Tagesrezepte-App"
                                                                message:@""
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"Jetzt bewerten",@"Später bewerten",@"Nein, danke!", nil];
            [alertView show];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Communications

// get the next (previous) receipes of the last 10 days
-(void) pullNextRecipes
{
    [(LeckerAppDelegate *)[[UIApplication sharedApplication] delegate] lockApp];
    [[RSACommunication getInstance] setDelegate:self];
    [[RSACommunication getInstance] doDailyRequestForDate:self.lastPullDate];
}

-(void) communicationFinishSuccessfulWithJSON:(NSDictionary *)json inStatus:(RSAStatus)status
{
    self.isInAction=NO;
    NSMutableArray *tmpArray=[[NSMutableArray alloc] init];
    if (status==RSAStatus_DAILYREQUEST)
    {
        NSLog(@"communicationFinishSuccessfulWithJSON");
        [(LeckerAppDelegate *)[[UIApplication sharedApplication] delegate] unlockApp];
        NSString *urlString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ImageServerURL"];
        for (NSDictionary *entry in [[json objectForKey:@"CMSContentList"]objectForKey:@"entries"])
        {
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
            [self.mainView addViewWithModel:tmpModel andFav:isFav];
            [self.singleRecipeOverviewArray addObject:tmpModel];
            [tmpArray addObject:tmpModel];
        }
        
        if(self.isInPinVIew) {
            [self.dailyPinView processWithArray:tmpArray];
        }
        
        if(self.initialStart) {
            [self.mainView initalSetup];
            self.initialStart=NO;
            self.initialLoad=NO;
        }
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
        [offsetComponents setDay:-10];
        NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate: self.lastPullDate options:0];
        self.lastPullDate=nextDate;
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
            if (self.isInPinVIew) {
               [UIView transitionFromView:self.dailyPinView toView:self.detailView duration:0.6f options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {}];
            }
            else
            {
               [UIView transitionFromView:self.mainView toView:self.detailView duration:0.6f options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {}]; 
            }
        }
        else
        {
            // Favorite Loaded - Save to DB:
            
            // In diesem Fall ist das Bild schon geladen (und im chache gespeichert), Rezept + Image können in der DB gespeichert werden:
            UIImage *image = [self.favImageCache objectForKey:self.actualRecipe.contentId];
            if (image)
            {
                [[DataManager getInstance] insertFavRecipeWithRecipe:self.actualRecipe andImage:image];
                
                [self.favImageCache removeObjectForKey:self.actualRecipe.contentId];
                
                if([self.delegate respondsToSelector:@selector(numberOfFavChanged)])
                {
                    [self.delegate numberOfFavChanged];
                }
            }
            // ... und hier nur das Rezept (?):
            // In diesem Fall wird das Bild gerade geladen, und später nachträglich das Rezept + Bil in der DB gespeichert.
            else
            {
                [self.favRecipeCache setObject:self.actualRecipe forKey:self.actualRecipe.contentId];
            }
        }
    }
}

-(void) communicationFailedinStatus:(RSAStatus)status {
    self.isInAction=YES;
    [(LeckerAppDelegate *)[[UIApplication sharedApplication] delegate] unlockApp];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Verbindungsfehler"
                                                        message:@"Versuchen Sie es erneut oder aktivieren Sie den Offlinemodus"
                                                       delegate:self
                                              cancelButtonTitle:@"Erneut Versuchen"
                                              otherButtonTitles:@"Offlinemodus", nil];
    [alertView show];
}

-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // Rating Alert
    if ([alertView.title isEqualToString:@"Bitte bewerten Sie die Lecker-Tagesrezepte-App"])
    {
        // Rate now
        if (buttonIndex==0)
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:@"alreadyRated"];
            [defaults synchronize];
            NSString *templateReviewURL = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=APP_ID";
            NSString *reviewURL = [templateReviewURL stringByReplacingOccurrencesOfString:@"APP_ID" withString:@"545648266"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
        }
        // Rate later
        else if (buttonIndex==1)
        {
            NSCalendar *cal = [NSCalendar currentCalendar];
            NSDateComponents *components = [cal components:NSWeekdayCalendarUnit fromDate:[[NSDate alloc] init]];
            int currentWeekday = [components weekday];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:currentWeekday forKey:@"reminderDay"];
            [defaults synchronize];
        }
        // No Rating please
        else if (buttonIndex==2)
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:@"alreadyRated"];
            [defaults synchronize];
        }
    }
    // Communication Failed: retry
    else if (buttonIndex==0)
    {
        if (self.initialLoad)
        {
            [self initialLoading];
        }
        else
        {
            if (self.requestId!=nil)
            {
                [[RSACommunication getInstance] setDelegate:self];
                [[RSACommunication getInstance] doRecipeRequestForId:self.requestId];
            }
            else
            {
               [self pullNextRecipes]; 
            }
        }
    }
    // Communication Failed: offline
    else
    {
        [self.mainView updateArrayForFavWithSet:[[DataManager getInstance] getAllRecipeContentIDs]]; 
        if([self.delegate respondsToSelector:@selector(switchToOffline)])
        {
            [self.delegate switchToOffline];
        }
    }
}

-(void) toggleToOffline {
    if (!self.offlineMode) {
        self.offlineMode=YES;
        NSLog(@"Daily: %f %f",self.view.bounds.origin.y,self.view.bounds.size.height);
        self.offlineView=[[LeckerOfflineView alloc] initWithFrame:self.view.bounds];
        self.offlineView.delegate=self;
        [self.view addSubview:self.offlineView];
    }
}

-(void) toggleToOnline {
    [self.offlineView removeFromSuperview];
    self.offlineMode=NO;
    if(self.isInAction) {
        if (self.initialLoad) {
            [self initialLoading];
        } else {
            if (self.requestId!=nil) {
                [[RSACommunication getInstance] setDelegate:self];
                [[RSACommunication getInstance] doRecipeRequestForId:self.requestId];
            } else {
                [self pullNextRecipes];
            }
        }
    }
}

-(void) retryConnectionPressed {
    if([self.delegate respondsToSelector:@selector(switchToOnline)]) {
        [self.delegate switchToOnline];
    }
}


-(void) initialLoading {
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:1];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    self.lastPullDate = [gregorian dateByAddingComponents:offsetComponents toDate: [NSDate date] options:0];
    [(LeckerAppDelegate *)[[UIApplication sharedApplication] delegate] lockApp];
    [[RSACommunication getInstance] setDelegate:self];
    [[RSACommunication getInstance] doDailyRequestForDate:self.lastPullDate];
}


-(void) reInitializeMainVIew
{
    self.initialLoad=YES;
    self.isInPinVIew=NO;
    [self.singleRecipeOverviewArray removeAllObjects];
    [self.mainView removeFromSuperview];
    [self.dailyPinView removeFromSuperview];
    self.mainView=[[LeckerDailyRecipeMainView alloc] initWithFrame:self.view.frame pinView:YES];
    self.mainView.delegate=self;
    [self.mainView setMax:365];
    [self.view addSubview:self.mainView];
    [self requestNewAdForBanner];
    [self initialLoading];
}


-(void) recipeActivateWithContentId:(NSString *)contentId recipeImage:(UIImage *)image{
    self.favLoad=NO;
    LeckerSingleRecipeDetailModel *recipe=[[DataManager getInstance] getRecipeWithContentId:contentId];
    self.requestId=nil;
    if(recipe==nil) {
        [(LeckerAppDelegate *)[[UIApplication sharedApplication] delegate] lockApp];
        self.actualRecipeImage=image;
        self.requestId=contentId;
        [[RSACommunication getInstance] setDelegate:self];
        [[RSACommunication getInstance] doRecipeRequestForId:contentId];
    } else {
        self.actualRecipe=recipe;
        self.actualRecipeImage=image;
        self.detailView=[[LeckerRecipeDetailView alloc] initWithFrame:self.view.bounds];
        self.detailView.delegate=self;
        [self.detailView showRecipe:self.actualRecipe withImage:self.actualRecipeImage];
        [[IOLSession defaultSession] logEventWithType:IOLEventTypeView state:IOLViewAppeared category:@"RecipeDetailViewOpen" comment:@"RecipeDetailViewOpen"];
        [((LeckerAppDelegate *)[[UIApplication sharedApplication] delegate]).tracker trackEventWithCategory:@"Controller" withAction:@"DailyRecipeController" withLabel:@"RecipeDetailViewOpen" withValue:nil]; 
        if(self.isInPinVIew) {
            [UIView transitionFromView:self.dailyPinView toView:self.detailView duration:0.6f options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {}];
        } else {
            [UIView transitionFromView:self.mainView toView:self.detailView duration:0.6f options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {}];
        }
        
    }
}

#pragma mark - Actions

-(void) backButtonPressed {
    if (self.isInPinVIew) {
        [UIView transitionFromView:self.detailView toView:self.dailyPinView duration:0.6f options:UIViewAnimationOptionTransitionFlipFromRight
                        completion:^(BOOL finished) {
                            [[IOLSession defaultSession] logEventWithType:IOLEventTypeView state:IOLViewAppeared category:@"PinterestViewOpen" comment:@"PinterestViewOpen"];
                            [((LeckerAppDelegate *)[[UIApplication sharedApplication] delegate]).tracker
                             trackEventWithCategory:@"Controller"
                             withAction:@"DailyRecipeController"
                             withLabel:@"PinterestViewOpen"
                             withValue:nil];
        }];
    } else {
        [UIView transitionFromView:self.detailView toView:self.mainView duration:0.6f options:UIViewAnimationOptionTransitionFlipFromRight
                        completion:^(BOOL finished) {
                            [[IOLSession defaultSession] logEventWithType:IOLEventTypeView state:IOLViewAppeared category:@"RecipeSwipeViewOpen" comment:@"RecipeSwipeViewOpen"];
                            [((LeckerAppDelegate *)[[UIApplication sharedApplication] delegate]).tracker
                             trackEventWithCategory:@"Controller"
                             withAction:@"DailyRecipeController"
                             withLabel:@"RecipeSwipeViewOpen"
                             withValue:nil];
        }];
    }

}

-(void) addToFavPressedWithContentId:(NSString *)contentId andImage:(UIImage *)image
{
    // Tracking
    [((LeckerAppDelegate *)[[UIApplication sharedApplication] delegate]).tracker trackEventWithCategory:@"Controller"
                                                                                             withAction:@"DailyRecipeController"
                                                                                              withLabel:@"RecipeAddToFavorites"
                                                                                              withValue:nil];
    self.favLoad=YES;
    if (contentId==self.actualRecipe.contentId)
    {
        NSLog(@"LeckerDailyRecipe_3_1");
        [[DataManager getInstance] insertFavRecipeWithRecipe:self.actualRecipe andImage:image];
        if([self.delegate respondsToSelector:@selector(numberOfFavChanged)])
        {
            [self.delegate numberOfFavChanged];
        }
    }
    else
    {
        NSLog(@"LeckerDailyRecipe_3_2");
        self.requestId=contentId;
        self.actualRecipeImage=image;
        if (image!=nil)
        {
            [self.favImageCache setObject:image forKey:contentId];            
        }
        NSLog(@"LeckerDailyRecipe_3_3");
        [RSACommunication getInstance].delegate=self;
        [[RSACommunication getInstance] doRecipeRequestForId:contentId];
    }
}

-(void) removeFromFavPressedWithContentId:(NSString *)contentId {
    [((LeckerAppDelegate *)[[UIApplication sharedApplication] delegate]).tracker
     trackEventWithCategory:@"Controller"
     withAction:@"DailyRecipeController"
     withLabel:@"RecipeRemovedFromFavorites"
     withValue:nil];
    [[DataManager getInstance] deleteRecipeFromFavWithContentId:contentId];
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

-(void) updateMainView {
    [self.mainView updateArrayForFavWithSet:[[DataManager getInstance] getAllRecipeContentIDs]];    
}

-(void) switchToPinView {
    self.isInPinVIew=YES;
    self.dailyPinView=[[LeckerDailyPinView alloc] initWithFrame:self.mainView.frame];
    [self.dailyPinView processWithArray:self.singleRecipeOverviewArray];
    self.dailyPinView.delegate=self;
    [UIView transitionFromView:self.mainView toView:self.dailyPinView duration:0.6f options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:^(BOOL finished) {
                        [((LeckerAppDelegate *)[[UIApplication sharedApplication] delegate]).tracker
                         trackEventWithCategory:@"Controller"
                         withAction:@"DailyRecipeController"
                         withLabel:@"PinterestViewOpen"
                         withValue:nil];
                        [[IOLSession defaultSession] logEventWithType:IOLEventTypeView state:IOLViewAppeared category:@"PinterestViewOpen" comment:@"PinterestViewOpen"];
                    }];
}

-(void) backToSwipeView {
    self.isInPinVIew=NO;
    [UIView transitionFromView:self.dailyPinView toView:self.mainView duration:0.6f options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:^(BOOL finished) {
                        [((LeckerAppDelegate *)[[UIApplication sharedApplication] delegate]).tracker
                         trackEventWithCategory:@"Controller"
                         withAction:@"DailyRecipeController"
                         withLabel:@"RecipeSwipeViewOpen"
                         withValue:nil];
                        [[IOLSession defaultSession] logEventWithType:IOLEventTypeView state:IOLViewAppeared category:@"RecipeSwipeViewOpen" comment:@"RecipeSwipeViewOpen"];
                        [self.dailyPinView removeFromSuperview];
                        [self.mainView becomeFirstResponder];
                        self.mainView.userInteractionEnabled=YES;
                        [self.mainView getFocus];
                    }];
}

-(void) facebookShareWithTitle:(NSString *)title Image:(UIImage *)image Id:(NSString *)recipeId {
    
    SLComposeViewController *test=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    //[test setInitialText:[NSString stringWithFormat:@"Ich habe dieses schöne Rezept bei Lecker gefunden: %@\n\n",title]];
    [test addURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.lecker.de/rezept/%@/facebook.html",recipeId]]];
    //[test addImage:[LeckerTools scaleImage:image withFactor:0.7]];
    
    [self presentViewController:test animated:YES completion:nil];
}

#pragma mark - Ads

-(void) requestNewAdForBanner {
    self.bannerView=[[SASBannerView alloc] initWithFrame:CGRectMake(0, 0, 300, 50) loader:SASLoaderActivityIndicatorStyleWhite];
    self.bannerView.delegate=self;
    [self.bannerView loadFormatId:20355 pageId:@"320702" master:YES target:nil];
}

-(void) adViewDidLoad:(SASAdView *)adView {
    self.bannerActiv=YES;
    [self.mainView createBanner:(SASBannerView*)adView]; 
}
-(void) adViewDidFailToLoad:(SASAdView *)adView error:(NSError *)error {
    self.bannerActiv=NO;
    [self.bannerView removeFromSuperview];
    self.bannerView=nil;
    [self.mainView removeBanner];
}

#pragma mark - Async Image Loader Delegate

// Wenn das Bild zu einem Rezept geladen wurde: Speichere das Rezept inkl. Image in der DB
// und lösche das Element im Chache.
-(void) recipeImageLoadedWithContentId:(NSString *)contentId andRecipeImage:(UIImage *)image
{
    if ([self.favRecipeCache objectForKey:contentId]!=nil)
    {
        [[DataManager getInstance] insertFavRecipeWithRecipe:[self.favRecipeCache objectForKey:contentId] andImage:image];
        [self.favRecipeCache removeObjectForKey:contentId];
        if([self.delegate respondsToSelector:@selector(numberOfFavChanged)]) {
            [self.delegate numberOfFavChanged];
        }
    }
    for (LeckerSingleRecipeOverviewModel *model in self.singleRecipeOverviewArray)
    {
        if([model.contendId isEqualToString:contentId])
        {
            model.image=image;
        }
    }
}



@end
