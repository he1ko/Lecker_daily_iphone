//
//  LeckerFacetTextView.h
//  Lecker
//
//  Created by Naujeck, Marcel on 25.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeckerSingleFacetView.h"

@protocol LeckerFacetTextViewProtocol;

@interface LeckerFacetTextView : UIView <LeckerSingleFacetViewProtocol>
- (id)initWithPoint:(CGPoint)point withImage:(UIImage*) background  facet:(NSString*) facet andFacetMap:(NSSet*) facetSet;
@property (nonatomic,weak) id <LeckerFacetTextViewProtocol> delegate;
@end

@protocol LeckerFacetTextViewProtocol <NSObject>
@required
-(void) addFacetToSelectionList:(NSString*) facet intoGroup:(NSString*) facetGroup;
-(void) removeFacetFromSelectionList:(NSString*) facet fromGroup:(NSString*) facetGroup;
@end