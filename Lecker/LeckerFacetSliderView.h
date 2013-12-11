//
//  LeckerFacetSliderView.h
//  Lecker
//
//  Created by Naujeck, Marcel on 26.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeckerFacetSliderTouch.h"

@protocol LeckerFacetSliderViewProtocol;

@interface LeckerFacetSliderView : UIView <LeckerFacetSliderTouchProtocol>
- (id)initWithFrame:(CGPoint)point backgroundImage:(UIImage*) image intervalStart:(int) intervalStart intervalEnd:(int) intervalEnd unit:(NSString*) unittext interval:(int) interval slidername:(NSString*) name;
@property (nonatomic,weak) id <LeckerFacetSliderViewProtocol> delegate;
@end

@protocol LeckerFacetSliderViewProtocol <NSObject>
@required
-(void) sliderChangeValueTo:(int) value withName:(NSString*) name;

@end