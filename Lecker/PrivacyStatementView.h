//
//  PrivacyStatementView.h
//  Lecker
//
//  Created by Naujeck, Marcel on 17.04.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PrivacyStatementViewProtocol <NSObject>

@required
-(void) privacyStatementViewClosed;

@end

@interface PrivacyStatementView : UIView
@property (nonatomic,weak) id <PrivacyStatementViewProtocol> delegate;
@end
