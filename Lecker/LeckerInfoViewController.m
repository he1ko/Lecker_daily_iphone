//
//  LeckerInfoViewController.m
//  Lecker
//
//  Created by Naujeck, Marcel on 15.05.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerInfoViewController.h"
#import "InfoView.h"
#import <INFOnlineLibrary/INFOnlineLibrary.h>
#import "LeckerAppDelegate.h"

@interface LeckerInfoViewController ()
@property InfoView *mainView;
@end

@implementation LeckerInfoViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Info", @"Info");
        UIImage *tmp=[UIImage imageNamed:@"icon_info.png"];
        self.tabBarItem.image = tmp;
        
        self.mainView=[[InfoView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:self.mainView];
    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated {
    [((LeckerAppDelegate *)[[UIApplication sharedApplication] delegate]).tracker trackEventWithCategory:@"Controller" withAction:@"InfoViewController" withLabel:@"Appear" withValue:nil];
    [[IOLSession defaultSession] logEventWithType:IOLEventTypeView state:IOLViewAppeared category:@"InfoViewOpen" comment:@"InfoViewOpen"];
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
