//
//  LeckerLetterBar.h
//  Lecker
//
//  Created by Naujeck, Marcel on 02.04.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeckerLetterBarProtocol;

@interface LeckerLetterBar : UIView
@property (nonatomic,weak) id <LeckerLetterBarProtocol> delegate;
@end

@protocol LeckerLetterBarProtocol <NSObject>

@required
-(void) letterTouched:(int) asciiIndex;

@end