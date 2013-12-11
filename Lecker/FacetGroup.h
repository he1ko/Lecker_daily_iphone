//
//  FacetGroup.h
//  Lecker
//
//  Created by Naujeck, Marcel on 26.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FacetExpr;

@interface FacetGroup : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *facetexpr;
@end

@interface FacetGroup (CoreDataGeneratedAccessors)

- (void)addFacetexprObject:(FacetExpr *)value;
- (void)removeFacetexprObject:(FacetExpr *)value;
- (void)addFacetexpr:(NSSet *)values;
- (void)removeFacetexpr:(NSSet *)values;

@end
