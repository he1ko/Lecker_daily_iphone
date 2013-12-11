//
//  FacetExpr.h
//  Lecker
//
//  Created by Naujeck, Marcel on 26.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FacetGroup;

@interface FacetExpr : NSManagedObject

@property (nonatomic, retain) NSString * f_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) FacetGroup *facetgroup;

@end
