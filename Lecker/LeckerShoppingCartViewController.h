//
//  LeckerShoppingCartViewController.h
//  Lecker
//
//  Created by Naujeck, Marcel on 14.01.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeckerShoppingListMainView.h"
#import "SASBannerView.h"

@interface LeckerShoppingCartViewController : UIViewController <LeckerShoppingListMainViewProtocol,UIAlertViewDelegate,SASAdViewDelegate>
-(void) updateMainView;
@end
