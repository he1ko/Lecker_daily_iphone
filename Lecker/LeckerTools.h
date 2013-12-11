//
//  LeckerTools.h
//  Lecker
//
//  Created by Naujeck, Marcel on 14.01.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface LeckerTools : NSObject

+ (UIColor *)colorFromHexString:(NSString *)hexString;

+ (CAGradientLayer*)headerGradientwithFrame:(CGRect)frame;

+ (NSArray*)sortKeyFromSet:(NSSet*)set;

+ (NSDictionary*)dictionaryFromFacetExprSet:(NSSet*)set;

+ (UIImage*)scaleImage:(UIImage *)image withFactor:(float)factor;

+ (BOOL)isIPhone5;

@end
