//
//  RSACommunication.m
//  Lecker
//
//  Created by Naujeck, Marcel on 15.01.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "RSACommunication.h"
#import "DataManager.h"
#define refString "bauerdigital.leckerapp"

@interface RSACommunication()
@property NSMutableData *receivedData;
@property NSData *publicKey;
@property RSAStatus status;
@end

@implementation RSACommunication

static RSACommunication *instance = NULL;

#pragma mark - Init

+ (RSACommunication *)getInstance
{
    @synchronized(self)
    {
        if (instance == NULL)
            return [[self alloc] init];
    }
    
    return(instance);
}

-(id)init {
    if (!instance) {
        self = [super init];
        if (self) {
            
        }
        instance=self;
    } else {
        self=instance;
    }
    return self;
}

#pragma mark - Requests

-(void) doKeyRequest
{
    self.status=RSAStatus_KEYREQUEST;
    
    NSString *urlString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSABackendURL"];
    NSString *appId =[[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSAAppId"];
    NSString *requestURL = [NSString stringWithFormat:@"http://moxy:pE1nT0KeYs@%@/Init?AppID=%@&ReturnType=json",urlString,appId];
    NSLog(@"%@",requestURL);
    
    RSARequest *request=[[RSARequest alloc] init];
    request.delegate=self;
    [request doRequestWithURL:requestURL];
}

-(void) doFacetRequest
{
    self.status=RSAStatus_FACETREQUEST;
    
    NSString *urlString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSABackendURL"];
    NSString *msg=@"RequestType=facetlist&ReturnType=json";
    NSString *cipherText=[self encryptMessage:[msg dataUsingEncoding:NSISOLatin1StringEncoding] withPublicKey:[self getApplicationPublicKey]];
    NSString *requestURL = [NSString stringWithFormat:@"http://%@/Lecker?clientId=%@&msg=%@",urlString,[DataManager getInstance].securityInformation.clientid,cipherText];
    
    RSARequest *request=[[RSARequest alloc] init];
    request.delegate=self;
    [request doRequestWithURL:requestURL];
}

-(void) doSearchRequestWithMessage:(NSString*) msg andIndex:(int) index
{
    self.status=RSAStatus_SEARCHREQUEST;
    
    NSString *msgString = [msg stringByAppendingFormat:@"&startwith=%d&ReturnType=json",index];
    NSString *urlString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSABackendURL"];
    NSString *test = [self splitAndEncryptMessage:msgString withPublicKey:[self getApplicationPublicKey]];
    NSString *requestURL = [NSString stringWithFormat:@"http://%@/Lecker?clientId=%@&msg=%@",urlString,[DataManager getInstance].securityInformation.clientid,test];
    
    RSARequest *request=[[RSARequest alloc] init];
    request.delegate=self;
    [request doRequestWithURL:requestURL];
}

// Pull 10 receipes: date = 3.7.2013 - get recipes from 24.6.-3.7.
-(void) doDailyRequestForDate:(NSDate *) date
{
    self.status=RSAStatus_DAILYREQUEST;
    
    NSString *urlString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSABackendURL"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *theDate = [dateFormat stringFromDate:date];
    NSString *msg=[NSString stringWithFormat:@"RequestType=dailyRecipe&startdate=%@&ReturnType=json",theDate];
    NSString *cipherText=[self encryptMessage:[msg dataUsingEncoding:NSISOLatin1StringEncoding] withPublicKey:[self getApplicationPublicKey]];
    NSString *requestURL = [NSString stringWithFormat:@"http://%@/Lecker?clientId=%@&msg=%@",urlString,[DataManager getInstance].securityInformation.clientid,cipherText];
    
    RSARequest *request=[[RSARequest alloc] init];
    request.delegate=self;
    [request doRequestWithURL:requestURL];
}

-(void) doRecipeRequestForId:(NSString *) contentId
{
    self.status=RSAStatus_RECIPEREQUEST;
    
    NSString *urlString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSABackendURL"];
    NSString *msg = [NSString stringWithFormat:@"RequestType=singleContent&contentId=%@&ReturnType=json",contentId];
    NSString *cipherText = [self encryptMessage:[msg dataUsingEncoding:NSISOLatin1StringEncoding] withPublicKey:[self getApplicationPublicKey]];
    NSString *requestURL = [NSString stringWithFormat:@"http://%@/Lecker?clientId=%@&msg=%@",urlString,[DataManager getInstance].securityInformation.clientid,cipherText];
    
    RSARequest *request=[[RSARequest alloc] init];
    request.delegate=self;
    NSLog(@"doRecipeRequestForId");
    [request doRequestWithURL:requestURL];
}

// SK Unused?!
//-(void)doDailyRecipeRequest: (NSDate*) date
//{
//    
//}

#pragma mark - Requst Results

-(void) RSARequestProtocolTransmissionError {
    if ([self.delegate respondsToSelector:@selector(communicationFailedinStatus:)]) {
        [self.delegate communicationFailedinStatus:self.status];
    }
}

-(void) RSARequestProtocolReceivedData:(NSData *)data
{    
    switch (self.status) {
        case RSAStatus_KEYREQUEST:
        {
 
            NSError* error;
            NSDictionary *json=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            
            NSString *result_key=[[json objectForKey:@"initValue"] objectForKey:@"publicKey"];
            NSString *result_id=[[json objectForKey:@"initValue"] objectForKey:@"clientID"];
            [self setPublicAKey:[self dataFromHex:result_key]];
            
            if([self getApplicationPublicKey]!=nil) {
                [[DataManager getInstance] insertClientID:result_id];
                if ([self.delegate respondsToSelector:@selector(communicationFinishSuccessfulinStatus:)]) {
                    [self.delegate communicationFinishSuccessfulinStatus:self.status];
                }
            } else {
                if ([self.delegate respondsToSelector:@selector(communicationFailedinStatus:)]) {
                    [self.delegate communicationFailedinStatus:self.status];
                }
            }
        }
        break;
            
        case RSAStatus_FACETREQUEST:
        {
            NSError* error;
            NSDictionary *json=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            BOOL facetSuccess=YES;
            for (NSDictionary *object in [[json objectForKey:@"facetlist"] objectForKey:@"facet"]) {
                facetSuccess=facetSuccess|[[DataManager getInstance]insertFacetGroupWithDirectory:object];
            }
            if (facetSuccess) {
                if ([self.delegate respondsToSelector:@selector(communicationFinishSuccessfulinStatus:)]) {
                    [self.delegate communicationFinishSuccessfulinStatus:self.status];
                }
            } else {
                if ([self.delegate respondsToSelector:@selector(communicationFailedinStatus:)]) {
                    [self.delegate communicationFailedinStatus:self.status];
                }
            }
        }
        break;
        case RSAStatus_DAILYREQUEST:
        {
            NSError* error;
            NSDictionary *jsonResult=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if(error==nil) {
                if ([self.delegate respondsToSelector:@selector(communicationFinishSuccessfulWithJSON:inStatus:)]) {
                    [self.delegate communicationFinishSuccessfulWithJSON:jsonResult inStatus:self.status];
                }
            } else {
                if ([self.delegate respondsToSelector:@selector(communicationFailedinStatus:)]) {
                    [self.delegate communicationFailedinStatus:self.status];
                }
            }
        }
        break;
        case RSAStatus_RECIPEREQUEST:
        {
            NSError* error;
            NSDictionary *jsonResult=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if(error==nil) {
                if ([self.delegate respondsToSelector:@selector(communicationFinishSuccessfulWithJSON:inStatus:)]) {
                    [self.delegate communicationFinishSuccessfulWithJSON:jsonResult inStatus:self.status];
                }
            } else {
                if ([self.delegate respondsToSelector:@selector(communicationFailedinStatus:)]) {
                    [self.delegate communicationFailedinStatus:self.status];
                }
            }
        }
        break;
        case RSAStatus_SEARCHREQUEST:
        {
            NSError* error;
            NSDictionary *jsonResult=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

            if(error==nil) {
             if ([self.delegate respondsToSelector:@selector(communicationFinishSuccessfulWithJSON:inStatus:)]) {
                 [self.delegate communicationFinishSuccessfulWithJSON:jsonResult inStatus:self.status];
             }
            } else {
                if ([self.delegate respondsToSelector:@selector(communicationFailedinStatus:)]) {
                    [self.delegate communicationFailedinStatus:self.status];
                }
            }
        }
        break;
    }
}

#pragma mark - Helper

-(SecKeyRef) getApplicationPublicKey
{
    const char *stringRef = (const char *)[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSAKeyIdentifier"] cStringUsingEncoding: NSASCIIStringEncoding];
    SecKeyRef publicKeyRef = NULL;
    
    NSData * refTag = [[NSData alloc] initWithBytes:stringRef length:strlen(stringRef)];
    NSMutableDictionary * keyAttr = [[NSMutableDictionary alloc] init];
    
    [keyAttr setObject:(id)CFBridgingRelease(kSecClassKey) forKey:(id)CFBridgingRelease(kSecClass)];
    [keyAttr setObject:refTag forKey:(id)CFBridgingRelease(kSecAttrApplicationTag)];
    [keyAttr setObject:(id)CFBridgingRelease(kSecAttrKeyTypeRSA) forKey:(id)CFBridgingRelease(kSecAttrKeyType)];
    [keyAttr setObject:[NSNumber numberWithBool:YES] forKey:(id)CFBridgingRelease(kSecReturnRef)];
    
    OSStatus error = noErr;
    error = SecItemCopyMatching((CFDictionaryRef)CFBridgingRetain(keyAttr), (CFTypeRef *)&publicKeyRef);
    
    return publicKeyRef;
}


- (BOOL) setPublicAKey: (NSData *) keyAsData
{
    const char *stringRef = (const char *)[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSAKeyIdentifier"] cStringUsingEncoding: NSASCIIStringEncoding];
    NSData * rawFormattedKey = keyAsData;
    unsigned char * bytes = (unsigned char *)[rawFormattedKey bytes];
    size_t bytesLen = [rawFormattedKey length];
    
    /* Find correct Keyoffset */
    size_t i = 0;
    if (bytes[i++] != 0x30) return FALSE;
    
    if (bytes[i] > 0x80)
        i += bytes[i] - 0x80 + 1;
    else
        i++;
    
    if (i >= bytesLen) return FALSE;
    if (bytes[i] != 0x30) return FALSE;
    
    i += 15;
    
    if (i >= bytesLen - 2) return FALSE;
    if (bytes[i++] != 0x03) return FALSE;
    
    if (bytes[i] > 0x80)
        i += bytes[i] - 0x80 + 1;
    else
        i++;
    
    if (i >= bytesLen) return FALSE;
    if (bytes[i++] != 0x00) return FALSE;
    if (i >= bytesLen) return FALSE;
    
    /* Extract key from offset */
    NSData * extractedKey = [NSData dataWithBytes:&bytes[i] length:bytesLen - i];
    
    /* Load as a key ref */
    OSStatus error = noErr;
    CFTypeRef persistPeer = NULL;
    
    /* Delete old key from keychain */

    NSData * refTag = [[NSData alloc] initWithBytes:stringRef length:strlen(stringRef)];
    NSMutableDictionary * keyAttr = [[NSMutableDictionary alloc] init];
    [keyAttr setObject:(id)CFBridgingRelease(kSecClassKey) forKey:(id)CFBridgingRelease(kSecClass)];
    [keyAttr setObject:(id)CFBridgingRelease(kSecAttrKeyTypeRSA) forKey:(id)CFBridgingRelease(kSecAttrKeyType)];
    [keyAttr setObject:refTag forKey:(id)CFBridgingRelease(kSecAttrApplicationTag)];
    error = SecItemDelete((CFDictionaryRef) CFBridgingRetain(keyAttr));
    
    // Insert key to keychain
    [keyAttr setObject:extractedKey forKey:(id)CFBridgingRelease(kSecValueData)];
    [keyAttr setObject:[NSNumber numberWithBool:YES] forKey:(id)CFBridgingRelease(kSecReturnPersistentRef)];
    
    error = SecItemAdd((CFDictionaryRef) CFBridgingRetain(keyAttr), (CFTypeRef *)&persistPeer);
    
    if (persistPeer == nil || ( error != noErr && error != errSecDuplicateItem)) {
        NSLog(@"Problem adding public key to keychain");
        return FALSE;
    }
    
    CFRelease(persistPeer);
    return TRUE;
}

- (NSString*) splitAndEncryptMessage: (NSString*) message withPublicKey:(SecKeyRef) publicKeyRef
{
    NSData *data= [message dataUsingEncoding:NSISOLatin1StringEncoding];
    size_t blocklength= 117;//SecKeyGetBlockSize(publicKeyRef);
    int blockCounter=message.length/blocklength;
    int rest=data.length%blocklength;
    if(rest!=0)blockCounter++;
    NSString *resultString=@"";
    NSData *cipherBlock;
    for (int i=0; i<blockCounter; i++) {
        if((i*blocklength)+blocklength>message.length) {
            NSRange range = NSMakeRange(i*blocklength, data.length-i*blocklength);
            cipherBlock=[data subdataWithRange:range];
            resultString=[resultString stringByAppendingString:[self encryptMessage:cipherBlock withPublicKey:publicKeyRef]];
        } else {
            NSRange range = NSMakeRange(i*blocklength, blocklength);
            cipherBlock=[data subdataWithRange:range];
            resultString=[resultString stringByAppendingString:[self encryptMessage:cipherBlock withPublicKey:publicKeyRef]];
        }
    }
    CFRelease(publicKeyRef);
    NSLog(@"-> %@",resultString);
    return resultString;
}

-(NSString *) hexStringFromData:(NSData*) value
{
    
    NSUInteger dataLength = [value length];
    NSMutableString *string = [NSMutableString stringWithCapacity:dataLength*2];
    const unsigned char *dataBytes = [value bytes];
    for (NSInteger idx = 0; idx < dataLength; ++idx) {
        [string appendFormat:@"%02x", dataBytes[idx]];
    }
    
    return string;
}

- (NSString *)encryptMessage:(NSData *) inputData withPublicKey:(SecKeyRef) publicKeyRef
{
    const void *bytes = [inputData bytes];
    int length = [inputData length];
    uint8_t *plainText = malloc(length);
    memcpy(plainText, bytes, length);
    
    /* allocate a buffer to hold the cipher text */
    size_t cipherBufferSize;
    uint8_t *cipherBuffer;
    cipherBufferSize = SecKeyGetBlockSize(publicKeyRef);
    cipherBuffer = malloc(cipherBufferSize);
    
    /* encrypt!! */
    OSStatus error = noErr;
    //error=SecKeyEncrypt(publicKeyRef, kSecPaddingPKCS1, plainText, length, cipherBuffer, &cipherBufferSize);
    error=SecKeyEncrypt(publicKeyRef, kSecPaddingPKCS1, plainText, length, cipherBuffer, &cipherBufferSize);
    NSLog(@"%ld",error);
    
    NSData *d = [NSData dataWithBytes:cipherBuffer length:cipherBufferSize];
    
    /* Free the Security Framework Five! */
    
    free(cipherBuffer);
    
    //NSLog(@"encrypted: %@",d);
    return [self hexStringFromData:d];
    //return [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
}

- (NSData *) dataFromHex:(NSString *)str
{
    NSMutableData *stringData = [[NSMutableData alloc] init] ;
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [str length] / 2; i++) {
        byte_chars[0] = [str characterAtIndex:i*2];
        byte_chars[1] = [str characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [stringData appendBytes:&whole_byte length:1];
    }
    
    return stringData;
}


- (NSString *) stringToHex:(NSString *)str
{
    NSUInteger len = [str length];
    unichar *chars = malloc(len * sizeof(unichar));
    [str getCharacters:chars];
    NSMutableString *hexString = [[NSMutableString alloc] init];
    for(NSUInteger i = 0; i < len; i++ )
    {
        [hexString appendString:[NSString stringWithFormat:@"%x", chars[i]]];
    }
    free(chars);
    return hexString;
}



@end
