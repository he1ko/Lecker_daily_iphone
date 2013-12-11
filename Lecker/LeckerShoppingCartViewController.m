//
//  LeckerShoppingCartViewController.m
//  Lecker
//
//  Created by Naujeck, Marcel on 14.01.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerShoppingCartViewController.h"
#import "LeckerShoppingListMainView.h"
#import "DataManager.h"
#import <QuartzCore/QuartzCore.h>
#import <INFOnlineLibrary/INFOnlineLibrary.h>
#import "LeckerAppDelegate.h"

@interface LeckerShoppingCartViewController ()
@property LeckerShoppingListMainView *mainView;
@property UITextField *textField;
@property SASBannerView *banner;
@end

@implementation LeckerShoppingCartViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(id) init {
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Einkaufszettel", @"Einkaufszettel");
        UIImage *tmp=[UIImage imageNamed:@"icon_cart.png"];
        self.tabBarItem.image = tmp;
        
        self.mainView=[[LeckerShoppingListMainView alloc] initWithFrame:self.view.frame andShoppingList:[[DataManager getInstance] getAllShoppingListItems]];
        self.mainView.delegate=self;
        [self.view addSubview:self.mainView];
        

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void) viewDidDisappear:(BOOL)animated {
    [((LeckerAppDelegate *)[[UIApplication sharedApplication] delegate]).tracker trackEventWithCategory:@"Controller" withAction:@"ShoppinglistController" withLabel:@"Disappear" withValue:nil]; 
}

-(void) viewDidAppear:(BOOL)animated {
    [((LeckerAppDelegate *)[[UIApplication sharedApplication] delegate]).tracker trackEventWithCategory:@"Controller" withAction:@"ShoppinglistController" withLabel:@"Appear" withValue:nil]; 
    [[IOLSession defaultSession] logEventWithType:IOLEventTypeView state:IOLViewAppeared category:@"ShoppinglistViewOpen" comment:@"ShoppinglistViewOpen"];
    CGRect frame=self.view.bounds;
    
    [self.banner removeFromSuperview];
    self.banner=[[SASBannerView alloc] initWithFrame:CGRectMake(10,frame.size.height-60, 300, 50)
                                              loader:SASLoaderActivityIndicatorStyleWhite];
    self.banner.delegate=self;
    self.banner.layer.cornerRadius=5;
    self.banner.layer.borderWidth=1.5;
    self.banner.layer.borderColor=[UIColor blackColor].CGColor;
    self.banner.clipsToBounds=YES;
    [self.banner loadFormatId:20355 pageId:@"320703" master:YES target:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) removeFromShoppingList:(NSSet *)itemSet {
    [[DataManager getInstance] removeFromShoppingCard:itemSet];
    [self.mainView addShoppingCardWithList:[[DataManager getInstance] getAllShoppingListItems]];
    int num=[[DataManager getInstance] numberOfShoppingCardItems];
    if (num!=0) {
        self.tabBarItem.badgeValue=[NSString stringWithFormat:@"%d", num];
    } else {
        self.tabBarItem.badgeValue=nil;
    }
}

-(void) addingItemByUser{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Neuer Eintrag" message:@"\n\n\n" delegate:self cancelButtonTitle:@"Abbrechen" otherButtonTitles:@"Ok", nil];
    
    self.textField = [[UITextField alloc] init];
    self.textField.BackgroundColor=[UIColor whiteColor];
    self.textField.borderStyle = UITextBorderStyleLine;
    self.textField.frame = CGRectMake(15, 75, 255, 30);
    self.textField.font = [UIFont fontWithName:@"ArialMT" size:20];
    self.textField.placeholder = @"Zutat eingeben...";
    self.textField.textAlignment=NSTextAlignmentCenter;
    self.textField.keyboardAppearance = UIKeyboardAppearanceAlert;
    [self.textField becomeFirstResponder];
    [alert addSubview:self.textField];
    [alert show];
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex==1) {
        NSSet *newSet=[NSSet setWithObjects:self.textField.text, nil];
        [[DataManager getInstance] addToShoppingCard:newSet];
        [self.mainView addShoppingCardWithList:[[DataManager getInstance] getAllShoppingListItems]];
        int num=[[DataManager getInstance] numberOfShoppingCardItems];
        if (num!=0) {
            self.tabBarItem.badgeValue=[NSString stringWithFormat:@"%d", num];
        } else {
            self.tabBarItem.badgeValue=nil;
        }
    }
}


-(void) adViewDidLoad:(SASAdView *)adView {
    [self.view addSubview:self.banner];
    [self.mainView bannerWithHeightSet:self.view.bounds.size.height-self.banner.frame.origin.y];
}

-(void) updateMainView {
 [self.mainView addShoppingCardWithList:[[DataManager getInstance] getAllShoppingListItems]];
}

@end
