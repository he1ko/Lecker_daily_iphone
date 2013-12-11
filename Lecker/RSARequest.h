//
//  RSAKeyRequest.h
//  Lecker
//
//  Created by Naujeck, Marcel on 15.01.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RSARequestProtocol;

@interface RSARequest : NSObject<NSURLConnectionDelegate>
@property (nonatomic,weak) id <RSARequestProtocol> delegate;
-(void) doRequestWithURL:(NSString*) url;
@end



@protocol RSARequestProtocol <NSObject>
@optional
-(void) RSARequestProtocolReceivedData:(NSData *) data;
-(void) RSARequestProtocolTransmissionError;
@end