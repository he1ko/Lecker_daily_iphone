//
//  SearchObject.h
//  Lecker
//
//  Created by Naujeck, Marcel on 04.04.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchObject : NSObject

@property NSOrderedSet *searchIngSet;
@property NSMutableOrderedSet *searchRecipePropSet;
@property NSMutableOrderedSet *searchRecipeTypeSet;
@property int searchPrepTime;
@property int searchkcal;
@property NSString *query;

@end
