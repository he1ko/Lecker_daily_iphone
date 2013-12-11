//
//  Recipe.h
//  Lecker
//
//  Created by Naujeck, Marcel on 26.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Recipe : NSManagedObject

@property (nonatomic, retain) NSString * carbs;
@property (nonatomic, retain) NSString * contentId;
@property (nonatomic, retain) NSString * fat;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * ingredients;
@property (nonatomic, retain) NSString * kcal;
@property (nonatomic, retain) NSString * prepSteps;
@property (nonatomic, retain) NSString * prepTime;
@property (nonatomic, retain) NSString * protein;
@property (nonatomic, retain) NSString * title;

@end
