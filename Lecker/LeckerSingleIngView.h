//
//  LeckerSingleIngView.h
//  Lecker
//
//  Created by Naujeck, Marcel on 18.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeckerSingleIngProtocol;

@interface LeckerSingleIngView : UIView
- (id)initWithFrame:(CGRect)frame andIngredients:(NSString*) ing andOutPutText:(NSString*) outputtext;
@property (nonatomic,weak) id <LeckerSingleIngProtocol> delegate;
@property UILabel *ingLabel;
-(void) unTap;
@end

@protocol LeckerSingleIngProtocol <NSObject>
@optional
-(void) ingredientsAddToList:(NSString*) ing;
-(void) ingredientsRemoveFromList:(NSString*) ing;
@end