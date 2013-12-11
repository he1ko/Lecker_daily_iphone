//
//  LeckerPreviewImage.h
//  Lecker
//
//  Created by Naujeck, Marcel on 11.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeckerPreviewImage : UIView
- (id)initWithFrame:(CGRect)frame withImage:(UIImage*) image;
-(void) animateToBig;
@end
