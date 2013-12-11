//
//  LeckerShoppingListMainView.h
//  Lecker
//
//  Created by Naujeck, Marcel on 20.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeckerSingleIngView.h"


@protocol LeckerShoppingListMainViewProtocol <NSObject>
-(void) removeFromShoppingList:(NSSet*) itemSet;
-(void) updateMainView;
-(void) addingItemByUser;
@end


@interface LeckerShoppingListMainView : UIView <LeckerSingleIngProtocol>
- (id)initWithFrame:(CGRect)frame andShoppingList:(NSArray*) shoppingList;
@property (nonatomic,weak) id <LeckerShoppingListMainViewProtocol> delegate;
-(void) addShoppingCardWithList:(NSArray*) shoppingList;
-(void) bannerWithHeightSet:(int) height;
@end



