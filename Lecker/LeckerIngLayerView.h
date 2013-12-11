//
//  LeckerIngLayerView.h
//  Lecker
//
//  Created by Naujeck, Marcel on 28.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeckerLetterBar.h"
#import "LeckerSingleFacetView.h"

@protocol LeckerIngLayerViewProtocol;

@interface LeckerIngLayerView : UIView <LeckerLetterBarProtocol,LeckerSingleFacetViewProtocol>
- (id)initWithFrame:(CGRect)frame andFacetMap:(NSSet*) facetSet;
@property (nonatomic,weak) id <LeckerIngLayerViewProtocol> delegate;
@property NSMutableDictionary *letterPosMap;
@property NSMutableOrderedSet *selectedItems;
@end

@protocol LeckerIngLayerViewProtocol <NSObject>

-(void) closeLayer;
-(void) addIngredientsSetToSearch:(NSSet*) ingSet;

@end
