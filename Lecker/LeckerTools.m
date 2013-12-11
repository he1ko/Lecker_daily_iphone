//
//  LeckerTools.m
//  Lecker
//
//  Created by Naujeck, Marcel on 14.01.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerTools.h"
#import "FacetExpr.h"

@implementation LeckerTools

+ (UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (CAGradientLayer*) headerGradientwithFrame:(CGRect) frame
{
    UIColor *colorOne = [LeckerTools colorFromHexString:@"#81c0c9"];
    UIColor *colorTwo = [LeckerTools colorFromHexString:@"#4ea0af"];
    UIColor *colorThree  = [LeckerTools colorFromHexString:@"#397f8d"];
    UIColor *colorFour = [LeckerTools colorFromHexString:@"#2a626f"];
    
    NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, colorFour.CGColor, nil];
    
    NSNumber *stopOne   = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo   = [NSNumber numberWithFloat:0.49];
    NSNumber *stopThree = [NSNumber numberWithFloat:0.50];
    NSNumber *stopFour  = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, stopThree, stopFour, nil];
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.frame=frame;
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
    
}

+(NSDictionary*) dictionaryFromFacetExprSet:(NSSet*) set
{
    NSMutableDictionary *tmpDict=[[NSMutableDictionary alloc] initWithCapacity:set.count];
    for (FacetExpr *expr in set) {
        [tmpDict setObject:expr.f_id forKey:expr.name];
    }
    return tmpDict;
}

+(NSArray*) sortKeyFromSet:(NSSet*) set
{
    NSDictionary *exprDict=[self dictionaryFromFacetExprSet:set];
    NSArray *sortedArray = [[exprDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return sortedArray;
}

+(UIImage*) scaleImage:(UIImage *)image withFactor:(float) factor
{
    CGSize newSize=CGSizeMake(image.size.width*factor, image.size.height*factor);
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* small = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return small;
}

+(BOOL) isIPhone5
{
    if ([[UIScreen mainScreen] bounds].size.height==568) return YES;
    return NO;
}

@end
