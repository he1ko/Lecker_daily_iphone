//
//  LeckerSingleRecipeOverviewModel.m
//  Lecker
//
//  Created by Naujeck, Marcel on 05.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerSingleRecipeOverviewModel.h"
#import "LeckerTools.h"

@implementation LeckerSingleRecipeOverviewModel

-(void) loadThumbnail {
    AsycImageLoader *loader=[[AsycImageLoader alloc] initWithURL:self.thumbnailUrl];
    loader.delegate=self;
    [loader doRequest];
    
}

-(void)imageLoadingComplettWithImage:(UIImage *)image {
    NSLog(@"imageLoaded: %f %f",image.size.height,image.size.width);
    float factor=image.size.width/130;
    self.thumbnail=[UIImage imageWithCGImage:image.CGImage scale:factor orientation:nil];

    if([self.delegate respondsToSelector:@selector(loadingFinished)]) {
        [self.delegate loadingFinished];
    }
}

-(void) imageLoadingFailed {
    
    UIImage *image=[UIImage imageNamed:@"no_image.png"];
    float factor=image.size.width/130;
    self.thumbnail=[LeckerTools scaleImage:image withFactor:factor];
    if([self.delegate respondsToSelector:@selector(loadingFinished)]) {
        [self.delegate loadingFinished];
    }
}

@end
