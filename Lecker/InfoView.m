//
//  InfoView.m
//  Lecker
//
//  Created by Naujeck, Marcel on 15.05.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "InfoView.h"
#import "LeckerTools.h"

@interface InfoView()
@property UIView *leckerHeader;
@property UIView *contentView;
@property UIWebView *infoWebView;

@end
@implementation InfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.leckerHeader=[[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 40)];
        [self.leckerHeader.layer insertSublayer:[LeckerTools headerGradientwithFrame:self.leckerHeader.bounds] atIndex:0];
        UIImageView *logo=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lecker-logo.png"]];
        CGRect frame=logo.frame;
        frame.origin.x=self.leckerHeader.frame.size.width/2- frame.size.width/2;
        frame.origin.y=self.leckerHeader.frame.size.height/2- frame.size.height/2;
        logo.frame=frame;
        [self.leckerHeader addSubview:logo];
        [self addSubview:self.leckerHeader];
        
        self.contentView=[[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, self.bounds.size.height-87)];
        UIImageView *bg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"holz.png"]];
        bg.frame=self.contentView.bounds;
        bg.contentMode=UIViewContentModeScaleAspectFill;
        bg.clipsToBounds=YES;
        [self.contentView addSubview:bg];
        [self addSubview:self.contentView];
        
        
        frame=self.contentView.bounds;
        self.infoWebView=[[UIWebView alloc] initWithFrame:frame];
        self.infoWebView.delegate=self;
        NSURLRequest *imprintRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://service.bauerdigital.de/mobile/lecker/"]];
        [self.infoWebView loadRequest:imprintRequest];
        self.infoWebView.backgroundColor=[UIColor clearColor];
        self.infoWebView.scrollView.bounces=NO;
        self.infoWebView.scrollView.backgroundColor=[UIColor clearColor];
        
        self.opaque = NO;
        [self.contentView addSubview:self.infoWebView];
    }
    return self;
}



-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"-- > %@",request.URL.lastPathComponent);
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
