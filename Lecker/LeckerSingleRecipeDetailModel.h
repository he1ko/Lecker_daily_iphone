//
//  LeckerSingleRecipeDetailModel.h
//  Lecker
//
//  Created by Naujeck, Marcel on 08.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recipe.h"

@interface LeckerSingleRecipeDetailModel : NSObject
@property NSString* contentId;
@property NSString* title;
@property NSString* type;
@property NSString* carbs;
@property NSString* fat;
@property NSString* kcal;
@property NSString* kj;
@property NSString* protein;
@property NSString* ingHeadline;
@property NSMutableArray* ingList;
@property NSString* ingConcat;
@property NSString* prepTime;
@property NSString* imageUrl;
@property NSString* thumbUrl;
@property NSString* prepSteps;
@property NSData *image;

-(void) parseRecipeFromJson:(NSDictionary*) json;

-(void) warpFromDB:(Recipe*) recipe;

@end
