//
//  LeckerTemporaryRecipe.m
//  Lecker
//
//  Created by Naujeck, Marcel on 14.01.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerTemporaryRecipe.h"

@implementation LeckerTemporaryRecipe
@synthesize name=_name;
@synthesize image=_image;

-(void) initWithName:(NSString*) name andImage:(UIImage*) image {
    self.name=name.copy;
    self.image=image.copy;
}

@end
