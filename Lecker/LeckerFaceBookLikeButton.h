//
//  LeckerFaceBookLikeButton.h
//  Lecker
//
//  Created by Naujeck, Marcel on 10.04.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeckerFaceBookLikeButton : UIWebView <UIWebViewDelegate,UIAlertViewDelegate>
- (id)initWithFrame:(CGRect)frame withContentId:(NSString*) contentId;
@end
