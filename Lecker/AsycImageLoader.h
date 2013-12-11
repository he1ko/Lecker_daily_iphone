//
//  AsycImageLoader.h
//  Lecker
//
//  Created by Naujeck, Marcel on 05.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AycnImageLoaderProtocol;



@interface AsycImageLoader : NSObject <NSURLConnectionDelegate>
-(id) initWithURL:(NSString*) url;
-(void) doRequest;
@property (nonatomic,weak) id <AycnImageLoaderProtocol> delegate;

@end

@protocol AycnImageLoaderProtocol <NSObject>
@optional
-(void) imageLoadingComplettWithImage:(UIImage *) image;
-(void) imageLoadingFailed;
@end
