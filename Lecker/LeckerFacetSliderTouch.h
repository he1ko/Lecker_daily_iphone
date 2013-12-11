//
//  LeckerFacetSliderTouch.h
//  Lecker
//
//  Created by Naujeck, Marcel on 27.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeckerFacetSliderTouchProtocol;

@interface LeckerFacetSliderTouch : UIView
- (id)initWithFrame:(CGRect)frame minX:(int) minX maxX:(int) maxX minValue:(int) minValue maxValue:(int) maxValue intervall:(int)
intervall;
@property (nonatomic,weak) id <LeckerFacetSliderTouchProtocol> delegate;
@end

@protocol LeckerFacetSliderTouchProtocol <NSObject>

-(void) sliderChangeValue:(int) value onXPositon:(int) posX;
-(void) disableScrolling;
-(void) enableScrolling;

@end
