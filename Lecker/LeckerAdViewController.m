//
//  LeckerAdViewController.m
//  Lecker
//
//  Created by Naujeck, Marcel on 30.04.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerAdViewController.h"
#import "LeckerTools.h"
#import <QuartzCore/QuartzCore.h>
#import "LeckerAppDelegate.h"


@interface LeckerAdViewController ()
@property SASInterstitialView *bannerView;
@property UIActivityIndicatorView *activityView;
@end

@implementation LeckerAdViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIImageView *background;
        if([LeckerTools isIPhone5]) {
            background=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SplashScreenRetina4.png"]];
        } else {
            background=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SplashScreen.png"]];
        }
        
        background.frame=self.view.bounds;
        [self.view addSubview:background];
    }
    return self;
}

-(void) prepareForBanner {
    CGRect frame=CGRectMake(self.view.bounds.size.width/2-150, self.view.bounds.size.height/2-200, 300, 400);
    self.bannerView=[[SASInterstitialView alloc] initWithFrame:frame loader:SASLoaderLaunchImage];
    self.bannerView.delegate=self;
    self.bannerView.layer.borderColor=[UIColor blackColor].CGColor;
    self.bannerView.layer.borderWidth=1;
    [self.bannerView loadFormatId:20121 pageId:@"320699" master:YES target:nil];
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityView.center = CGPointMake((int)(self.view.bounds.size.width / 2), (int)(self.view.bounds.size.height / 2));
    self.activityView.hidesWhenStopped = YES;
    [self.activityView startAnimating];
    [self.view addSubview:self.activityView];
}

-(void) adViewDidLoad:(SASAdView *)adView {
    [self.view addSubview:self.bannerView];
    [self.activityView stopAnimating];
    if ([self.delegate respondsToSelector:@selector(adLoaded)]) {
        [self.delegate adLoaded];
    }
}

-(void) adViewDidFailToLoad:(SASAdView *)adView error:(NSError *)error {
    [self.activityView stopAnimating];
    if ([self.delegate respondsToSelector:@selector(adFailed)])
    {
        [self.delegate adFailed];
    }
}

-(void) adViewDidCollapse:(SASAdView *)adView
{
    if ([self.delegate respondsToSelector:@selector(adClosed)])
    {
        [self.delegate adClosed];
    }
}

-(void) adViewDidDisappear:(SASAdView *)adView
{
    if ([self.delegate respondsToSelector:@selector(adClosed)])
    {
        [self.delegate adClosed];
    }
}

-(void) adViewWillDismissModalView:(SASAdView *)adView
{
    if ([self.delegate respondsToSelector:@selector(adClosed)])
    {
        [self.delegate adClosed];
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

@end
