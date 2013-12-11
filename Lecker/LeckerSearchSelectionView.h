//
//  LeckerSearchSelectionView.h
//  Lecker
//
//  Created by Naujeck, Marcel on 25.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeckerIngLayerView.h"
#import "LeckerFacetTextView.h"
#import "LeckerFacetSliderView.h"
#import "SearchObject.h"

@protocol LeckerSearchSelectionViewProtocol;

@interface LeckerSearchSelectionView : UIScrollView <UISearchBarDelegate,UIScrollViewDelegate,LeckerIngLayerViewProtocol,LeckerFacetTextViewProtocol,LeckerFacetSliderViewProtocol>
- (id)initWithFrame:(CGRect)frame andFacetGroupList:(NSArray*) facetGroupList;
@property (nonatomic,weak) id <LeckerSearchSelectionViewProtocol> searchdelegate;
@end

@protocol LeckerSearchSelectionViewProtocol <NSObject>
@required
-(void) doSearchWithSearchObject:(SearchObject*) search;
@end
