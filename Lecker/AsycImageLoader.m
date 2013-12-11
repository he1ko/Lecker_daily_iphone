//
//  AsycImageLoader.m
//  Lecker
//
//  Created by Naujeck, Marcel on 05.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "AsycImageLoader.h"

@interface AsycImageLoader()
@property NSMutableData *receivedData;
@property NSString *url;
@end

@implementation AsycImageLoader

-(id) initWithURL:(NSString*) url {
    self = [super init];
    if (self) {
        self.url=url;
    }
    return self;
}

-(void) doRequest {
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(theConnection){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        self.receivedData = [NSMutableData data];
    }
    else{
        if ([self.delegate respondsToSelector:@selector(imageLoadingFailed)]) {
            [self.delegate imageLoadingFailed];
        }
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{

    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{

    self.receivedData=nil;
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if ([self.delegate respondsToSelector:@selector(imageLoadingFailed)]) {
        [self.delegate imageLoadingFailed];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{

	if([self.receivedData length] != 0){
        if ([self.delegate respondsToSelector:@selector(imageLoadingComplettWithImage:)]) {
            [self.delegate imageLoadingComplettWithImage:[UIImage imageWithData:self.receivedData]];
        }
    }
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


@end
