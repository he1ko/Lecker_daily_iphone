//
//  LeckerOfflineView.h
//  Lecker
//
//  Created by Naujeck, Marcel on 09.04.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeckerOfflineViewProtocol;

@interface LeckerOfflineView : UIView
@property (nonatomic,weak) id <LeckerOfflineViewProtocol> delegate;
@end

@protocol LeckerOfflineViewProtocol <NSObject>

@optional
-(void) retryConnectionPressed;


@end