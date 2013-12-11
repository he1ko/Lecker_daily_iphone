//
//  LeckerFaceBookLikeButton.m
//  Lecker
//
//  Created by Naujeck, Marcel on 10.04.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LeckerFaceBookLikeButton.h"

@interface LeckerFaceBookLikeButton()
@property NSString *likeButtonHtml;
@property NSURLRequest *urlRequest;
@property BOOL requestFlag;
@property CGRect orgFrame;
@end

@implementation LeckerFaceBookLikeButton

- (id)initWithFrame:(CGRect)frame withContentId:(NSString*) contentId
{
    self = [super initWithFrame:frame];
    if (self) {
        self.orgFrame=frame;
        self.requestFlag=NO;
        NSString *likeButtonIframe = [NSString stringWithFormat:@"<iframe scrolling=\"no\" frameborder=\"0\" allowtransparency=\"true\"  src=\"http://www.facebook.com/plugins/like.php?href=http://www.lecker.de/rezept/%@/facebook.html&send=false&connections=0&stream=false&layout=button_count&width=125&show_faces=false&font=lucida+grande&colorscheme=light&action=like&height=18\">",contentId];
        self.likeButtonHtml = [NSString stringWithFormat:@"<HTML><BODY>%@</BODY></HTML>", likeButtonIframe];
        [self loadHTMLString:self.likeButtonHtml baseURL:[NSURL URLWithString:@""]];
        //self.frame=CGRectMake(100, 40, 130, 35);
        self.opaque = NO;
        self.scrollView.scrollEnabled=NO;
        self.backgroundColor = [UIColor clearColor];
        self.delegate=self;
        
    }
    return self;
}



- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *URL = [request URL];
    NSString *tmp=[URL path];
    
    
    NSRange range1 = [tmp rangeOfString : @"login.php"];
    NSRange range2 = [tmp rangeOfString : @"close_popup.php"];
    
    if (range1.location != NSNotFound && !self.requestFlag) {
        self.urlRequest=request;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Facebook Anmeldung"
                                                            message:@"Sie müssen sich erst bei Facebook anmelden bevor Sie diese Funktion nutzen können"
                                                           delegate:self
                                                  cancelButtonTitle:@"Anmelden"
                                                  otherButtonTitles:@"Abbrechen",nil];
        [alertView show];
        return NO;
        
    }
    
    if (range2.location != NSNotFound) {
        self.requestFlag=NO;
        self.layer.borderWidth=0;
        self.layer.cornerRadius=0;
        self.scrollView.scrollEnabled=NO;
        self.frame=self.orgFrame;
        [self loadHTMLString:self.likeButtonHtml baseURL:[NSURL URLWithString:@""]];
    }
    return YES;
}

-(void) closeFaceBookView {
    self.requestFlag=NO;
    self.layer.borderWidth=0;
    self.layer.cornerRadius=0;
    self.scrollView.scrollEnabled=NO;

    self.frame=self.orgFrame;
    [self loadHTMLString:self.likeButtonHtml baseURL:[NSURL URLWithString:@""]];
}

-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(buttonIndex==0) {
        self.requestFlag=YES;
        CGRect frame=self.superview.bounds;
        frame.origin.x+=20;
        frame.size.width-=40;
        frame.origin.y+=50;
        frame.size.height=350;
        self.frame=frame;
        self.layer.borderWidth=1;
        self.layer.cornerRadius=5;
        self.scrollView.scrollEnabled=YES;
        self.scrollView.bounces=NO;
        self.clipsToBounds=YES;

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self
                   action:@selector(closeFaceBookView)
         forControlEvents:UIControlEventTouchDown];
        button.backgroundColor = [UIColor clearColor];
        [button setBackgroundImage:[UIImage imageNamed:@"timer-dialog-close.png"] forState:UIControlStateNormal];
        button.frame = CGRectMake(self.bounds.size.width-32, 2, 30, 30);
        [self addSubview:button];
        
        
        [self loadRequest:self.urlRequest];;
    }
}

@end
