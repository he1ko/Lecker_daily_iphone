//
//  RSARequest.m
//  Lecker
//
//  Created by Naujeck, Marcel on 15.01.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "RSARequest.h"

@interface  RSARequest ()
@property NSMutableData *receivedData;
@end


@implementation RSARequest

-(id) init {
    self = [super init];
    if (self) {

    }
    return self;
}

-(void) doRequestWithURL:(NSString*) url {

    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
  
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(theConnection){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        self.receivedData = [NSMutableData data];
    }
    else{
        NSLog(@"didFailWithError");
        if ([self.delegate respondsToSelector:@selector(RSARequestProtocolkeyTransmissionError)]) {
            [self.delegate RSARequestProtocolTransmissionError];
        }
    }
}

- (void) eraseCredentials{
    NSURLCredentialStorage *credentialsStorage = [NSURLCredentialStorage sharedCredentialStorage];
    NSDictionary *allCredentials = [credentialsStorage allCredentials];
    
    //iterate through all credentials to find the twitter host
    for (NSURLProtectionSpace *protectionSpace in allCredentials) {
        NSLog(@"%@",[protectionSpace host]);
        if ([[protectionSpace host] isEqualToString:@"http://mobile.bauerdigital.de:8080"]){
            //to get the twitter's credentials
            NSDictionary *credentials = [credentialsStorage credentialsForProtectionSpace:protectionSpace];
            //iterate through twitter's credentials, and erase them all
            for (NSString *credentialKey in credentials)
                [credentialsStorage removeCredential:[credentials objectForKey:credentialKey] forProtectionSpace:protectionSpace];
        }
    }
}

- (void)clearCookiesForURL:(NSURL*) url {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookiesForURL:url];
    for (NSHTTPCookie *cookie in cookies) {
        NSLog(@"Deleting cookie for domain: %@", [cookie domain]);
        [cookieStorage deleteCookie:cookie];
    }
}

-(void) connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"didReceiveAuthenticationChallenge:");
    
                                                  if ([challenge previousFailureCount] == 0) {
                                                  NSURLCredential *newCredential =[NSURLCredential credentialWithUser:@"moxy" password:@"pE1nT0KeYs" persistence:NSURLCredentialPersistenceNone];
                                                  [[challenge sender] useCredential:newCredential forAuthenticationChallenge:challenge];
                                                  } else {
                                                  [[challenge sender] cancelAuthenticationChallenge:challenge];
                                                  }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	NSLog(@"didReceiveResponse: URL: %@",[[response URL] absoluteString] );
	//NSLog(@"didReceiveResponse: expectedContentLength: %qi",[response expectedContentLength]);
	if([response isKindOfClass:[NSHTTPURLResponse class]])
	{
		//NSLog(@"didReceiveResponse: statusCode: %d",[(NSHTTPURLResponse *)response statusCode]);
	}
	
    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	NSLog(@"didReceiveData: length: %d",[data length]);
    [self.receivedData appendData:data];
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	NSLog(@"didFailWithError");
    self.receivedData=nil;
    NSLog(@"Connection failed! Error - %@", [error localizedDescription]);
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if ([self.delegate respondsToSelector:@selector(RSARequestProtocolTransmissionError)]) {
        [self.delegate RSARequestProtocolTransmissionError];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"Succeeded! Received %d bytes of data",[self.receivedData length]);
	if([self.receivedData length] != 0){
        //NSLog(@"%@",[[NSString alloc] initWithData:self.receivedData encoding:NSASCIIStringEncoding]);
        if ([self.delegate respondsToSelector:@selector(RSARequestProtocolReceivedData:)]) {
            [self.delegate RSARequestProtocolReceivedData:self.receivedData.copy];
        }
    }
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
