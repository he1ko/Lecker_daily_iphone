//
//  LeckerSingleFacetView.h
//  Lecker
//
//  Created by Naujeck, Marcel on 26.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeckerSingleFacetViewProtocol;

@interface LeckerSingleFacetView : UIView
- (id)initWithFrame:(CGRect)frame andDataValue:(NSString*) value andOutPutText:(NSString*) outputtext;
@property (nonatomic,weak) id <LeckerSingleFacetViewProtocol> delegate;
@property UILabel *ingLabel;
-(void) unTap;
@end

@protocol LeckerSingleFacetViewProtocol <NSObject>
@optional
-(void) ingredientsAddToList:(NSString*) ing;
-(void) ingredientsRemoveFromList:(NSString*) ing;
@end





