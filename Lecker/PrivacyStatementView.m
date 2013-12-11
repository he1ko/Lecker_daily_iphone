//
//  PrivacyStatementView.m
//  bravomobile
//
//  Created by Naujeck, Marcel on 27.02.13.
//
//
#import <QuartzCore/QuartzCore.h>
#import "PrivacyStatementView.h"

@implementation PrivacyStatementView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        UIView *grayView=[[UIView alloc] initWithFrame:frame];
        grayView.backgroundColor=[UIColor blackColor];
        grayView.alpha=0.8f;
        [self addSubview:grayView];
        
        NSString *statement=@"Datenschutzerklärung\nzur Nutzung des Skalierbaren Zentralen Messverfahrens\n\nUnsere Applikation nutzt das 'Skalierbare Zentrale Messverfahren '(SZM) der INFOnline GmbH' (http://www.infonline.de) für die Ermittlung statistischer Kennwerte zur Nutzung unserer Angebote.\n\nDabei werden anonyme Messwerte erhoben. Die SZM- Reichweitenmessung verwendet zur Wiedererkennung von Geräten eindeutige Kennungen des Endgerätes, die ausschließlich anonymisiert übermittelt werden. IP-Adressen werden nur in anonymisierter Form verarbeitet.\n\nWeitere Informationen zum SZM-Verfahren finden Sie auf der Website der INFOnline GmbH (https://www.infonline.de), die das SZM-Verfahren betreibt, der  Datenschutzwebsite der AGOF (http://www.agof.de/datenschutz) und der Datenschutzwebsite der IVW (http://www.ivw.eu).\n\nSie können diese Datenerhebung in den Optionen dieser Applikation im Einstellungscenter Ihres iPhones ausschalten.";
        CGRect tmpFrame=frame;
        tmpFrame.size.height-=30;
        UILabel *statementLabel=[[UILabel alloc] initWithFrame:tmpFrame];
        statementLabel.text=statement;
        statementLabel.contentMode=UIViewContentModeLeft;
        statementLabel.numberOfLines=0;
        statementLabel.lineBreakMode=NSLineBreakByWordWrapping;
        statementLabel.backgroundColor=[UIColor clearColor];
        statementLabel.textColor=[UIColor whiteColor];
        statementLabel.textAlignment=NSTextAlignmentCenter;
        statementLabel.font=[UIFont fontWithName:@"Helvetica" size:11];
        [self addSubview:statementLabel];
        UIButton *okayButton=[UIButton buttonWithType:UIButtonTypeCustom];
        tmpFrame=frame;
        tmpFrame.size.height=30;
        tmpFrame.origin.y=frame.size.height-30;
        
        okayButton.frame=tmpFrame;
        [okayButton setTitle:@"Ich habe die Datenschutzerklärung gelesen" forState:UIControlStateNormal];
        [okayButton addTarget:self action:@selector(closeView:) forControlEvents:(UIControlEventTouchDown)];
        okayButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:12];
        okayButton.backgroundColor = [UIColor clearColor];
        okayButton.layer.borderColor = [UIColor whiteColor].CGColor;
        okayButton.layer.borderWidth = 0.5f;
        okayButton.layer.cornerRadius = 10.0f;
        
        [self addSubview:okayButton];
        
    }
    return self;
}

-(void) closeView:(id)sender {
    if([self.delegate respondsToSelector:@selector(privacyStatementViewClosed)]) {
        [self.delegate privacyStatementViewClosed];
    }
    [self removeFromSuperview];
}

@end

