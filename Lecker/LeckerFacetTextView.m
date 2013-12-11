//
//  LeckerFacetTextView.m
//  Lecker
//
//  Created by Naujeck, Marcel on 25.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerFacetTextView.h"
#import "LeckerSingleFacetView.h"
#import "FacetExpr.h"

@interface LeckerFacetTextView()
@property NSString* facetGroup;

@end

@implementation LeckerFacetTextView


- (id)initWithPoint:(CGPoint)point withImage:(UIImage*) background  facet:(NSString*) facet andFacetMap:(NSSet*) facetSet
{
    self = [super init];
    if (self) {
        self.facetGroup=facet;
        UIImageView *bgView=[[UIImageView alloc] initWithImage:background];
        CGRect frame=self.frame;
        frame.origin.x=point.x;
        frame.origin.y=point.y;
        frame.size.height=background.size.height;
        frame.size.width=background.size.width;
        self.frame=frame;
        [self addSubview:bgView];
        
        NSLog(@"FacetTextView: %f %f",frame.size.width,frame.size.height);
        
        for (FacetExpr *tuple in facetSet) {
            LeckerSingleFacetView *tmp=[[LeckerSingleFacetView alloc] initWithFrame:CGRectMake(100,40+([tuple.index intValue]*27), self.bounds.size.width-100, 20) andDataValue:tuple.f_id andOutPutText:tuple.name];
            [self addSubview:tmp];
            tmp.delegate=self;
        }
    }
    return self;
}

-(void) ingredientsAddToList:(NSString *)ing {
    if ([self.delegate respondsToSelector:@selector(addFacetToSelectionList:intoGroup:)]) {
        [self.delegate addFacetToSelectionList:ing intoGroup:self.facetGroup];
    }
    
}

-(void) ingredientsRemoveFromList:(NSString *)ing {
    if ([self.delegate respondsToSelector:@selector(removeFacetFromSelectionList:fromGroup:)]) {
        [self.delegate removeFacetFromSelectionList:ing fromGroup:self.facetGroup];
    }
}

@end
