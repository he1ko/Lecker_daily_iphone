//
//  LeckerOfflineView.m
//  Lecker
//
//  Created by Naujeck, Marcel on 09.04.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerOfflineView.h"

@implementation LeckerOfflineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled=YES;
        
        UIView *bgView=[[UIView alloc] initWithFrame:frame];
        bgView.backgroundColor=[UIColor blackColor];
        bgView.alpha=0.7f;
        [self addSubview:bgView];
        
        CGRect tmp=frame;
        tmp.origin.x+=20;
        tmp.size.width-=40;
        
        UILabel *label=[[UILabel alloc] initWithFrame:tmp];
        label.text=@"Sie befinden sich zur Zeit im Offline Modus. Tagesgerichte und Suche sind in diesem Modus nicht nutzbar.";
        label.font=[UIFont fontWithName:@"DroidSans" size:24];
        label.textAlignment=NSTextAlignmentCenter;
        label.numberOfLines=0;
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.textColor=[UIColor whiteColor];
        label.backgroundColor=[UIColor clearColor];
        [self addSubview:label];
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:@"Versuche Verbindung wieder herzustellen..." forState:UIControlStateNormal];
        tmp=self.bounds;
        //NSLog(@"-> %f",tmp.size.height);
        tmp.origin.y=tmp.size.height-30;
        tmp.size.height=30;
        button.frame=tmp;
        [self addSubview:button];
        
        [button addTarget:self action:@selector(reconnect) forControlEvents:UIControlEventTouchDown];
        
        
        
    }
    return self;
}

-(void) reconnect {
    if ([self.delegate respondsToSelector:@selector(retryConnectionPressed)]) {
        [self.delegate retryConnectionPressed];
    }
}

@end
