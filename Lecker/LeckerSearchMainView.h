//
//  LeckerSearchMainView.h
//  Lecker
//
//  Created by Naujeck, Marcel on 22.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeckerSearchSelectionView.h"
#import "SearchObject.h"

@protocol LeckerSearchMainViewProtocol;

@interface LeckerSearchMainView : UIView <LeckerSearchSelectionViewProtocol>
- (id)initWithFrame:(CGRect)frame andFacetGroupList:(NSArray*) facetList;
@property (nonatomic,weak) id <LeckerSearchMainViewProtocol> delegate;
@end

@protocol LeckerSearchMainViewProtocol <NSObject>
@required
-(void) doSearchWithSearchObject:(SearchObject*) so;
@end