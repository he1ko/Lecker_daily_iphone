//
//  AsyncImageView.h
//  Lecker
//
//  Created by Koegler, Stefan on 26.06.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AsyncImageView : UIImageView <NSURLConnectionDelegate>

@property (nonatomic, retain) NSURL *url;

// Init
- (id)init;
- (id)initWithUrl:(NSURL*)aUrl;
- (id)initWithUrl:(NSURL*)aUrl frame:(CGRect)frame contentMode:(UIViewContentMode)contentMode;
- (id)initWithUrl:(NSURL*)aUrl frame:(CGRect)frame contentMode:(UIViewContentMode)contentMode activityIndicatorType:(UIActivityIndicatorViewStyle)indicatorStyle;

// Start Loading
- (void)stopLoadImage;
- (void)startLoadImage;
- (void)startLoadImageAfterDelay:(float)delay;


@end
