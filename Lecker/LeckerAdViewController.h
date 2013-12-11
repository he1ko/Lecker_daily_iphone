//
//  LeckerAdViewController.h
//  Lecker
//
//  Created by Naujeck, Marcel on 30.04.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASInterstitialView.h"

@protocol LeckerAdViewControllerProtocol <NSObject>

@required
-(void) adClosed;
-(void) adFailed;
-(void) adLoaded;
@end

@interface LeckerAdViewController : UIViewController <SASAdViewDelegate>
@property (nonatomic,weak) id <LeckerAdViewControllerProtocol> delegate;
-(void) prepareForBanner;
@end
