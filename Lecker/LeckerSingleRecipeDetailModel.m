//
//  LeckerSingleRecipeDetailModel.m
//  Lecker
//
//  Created by Naujeck, Marcel on 08.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerSingleRecipeDetailModel.h"

@implementation LeckerSingleRecipeDetailModel

-(void) warpFromDB:(Recipe*) recipe {
    self.title=recipe.title;
    self.carbs=recipe.carbs;
    self.protein=recipe.protein;
    self.fat=recipe.fat;
    self.prepTime=recipe.prepTime;
    self.kcal=recipe.kcal;
    
    NSArray* tmp = [recipe.ingredients componentsSeparatedByString: @"||"];
    self.ingList=[[NSMutableArray alloc] init];
    for (NSString *entry in tmp) {
        if(![[entry stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""] ) {
            if ([entry rangeOfString:@"Zutaten"].location!=NSNotFound) {
                self.ingHeadline=entry;
            } else {
                [self.ingList addObject:entry];
            }
        }
    }
    self.ingConcat=recipe.ingredients;
    self.prepSteps=recipe.prepSteps;
    self.contentId=recipe.contentId;
    self.image=recipe.image;
    
}

-(void) parseRecipeFromJson:(NSDictionary*) json {
    NSArray *additionalContent=[[json objectForKey:@"CMSArticle"] objectForKey:@"AdditionalContent"];
    NSDictionary *baseContent=[[json objectForKey:@"CMSArticle"] objectForKey:@"BaseContent"];
    for (NSDictionary *tmpDict in additionalContent) {
        NSString *contentName=[tmpDict objectForKey:@"ContentName"];
        NSString *contentValue=[tmpDict objectForKey:@"ContentValue"];
        
        if ([contentName isEqualToString:@"rcp_foodType"]) {
            self.type=contentValue;
        }
        if ([contentName isEqualToString:@"rcp_fv_carbs"]) {
            self.carbs=contentValue;
        }
        if ([contentName isEqualToString:@"rcp_fv_fat"]) {
            self.fat=contentValue;
        }
        if ([contentName isEqualToString:@"rcp_fv_kcal"]) {
            self.kcal=contentValue;
        }
        
        if ([contentName isEqualToString:@"rcp_fv_kj"]) {
            self.kj=contentValue;
        }
        if ([contentName isEqualToString:@"rcp_fv_protein"]) {
            self.protein=contentValue;
        }
        if ([contentName isEqualToString:@"rcp_ingredientsOrig"]) {
            NSArray* tmp = [contentValue componentsSeparatedByString: @"||"];
            self.ingList=[[NSMutableArray alloc] init];
            for (NSString *entry in tmp) {
                if(![[entry stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""] ) {                    
                    if ([entry rangeOfString:@"Zutaten"].location!=NSNotFound) {
                        self.ingHeadline=entry;
                    } else {
                       [self.ingList addObject:entry];   
                    }
                }
            }
            self.ingConcat=contentValue;
        }
    
        if ([contentName isEqualToString:@"rcp_prepTime"]) {
           self.prepTime=contentValue;
        }
    }
    
    self.title=[baseContent objectForKey:@"Headline"];

    NSDictionary *tmpImage=[[baseContent objectForKey:@"Images"] objectAtIndex:0];
    NSString *urlString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ImageServerURL"];
    if([tmpImage objectForKey:@"ImageSource"]!=nil) {
        self.imageUrl= [urlString stringByAppendingString:[tmpImage objectForKey:@"ImageSource"]];
    }
    if ([tmpImage objectForKey:@"ThumbnailSource"]!=nil) {
        self.thumbUrl= [urlString stringByAppendingString:[tmpImage objectForKey:@"ThumbnailSource"]];
    }
    NSString *tmp1=[[baseContent objectForKey:@"MainText"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *tmp2=[tmp1 stringByReplacingOccurrencesOfString:@"\n" withString:@""] ;
    self.prepSteps=[tmp2 stringByReplacingOccurrencesOfString:@"||" withString:@"\n\n"] ;
    self.contentId=[[[json objectForKey:@"CMSArticle"] objectForKey:@"Metadata"] objectForKey:@"ContentId"];
}

@end
