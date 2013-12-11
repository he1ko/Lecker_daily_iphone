//
//  RSACommunication.h
//  Lecker
//
//  Created by Naujeck, Marcel on 15.01.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSARequest.h"


enum {
    RSAStatus_KEYREQUEST    =0,
    RSAStatus_FACETREQUEST  =1,
    RSAStatus_DAILYREQUEST  =2,
    RSAStatus_RECIPEREQUEST =3,
    RSAStatus_SEARCHREQUEST =4
};

typedef NSUInteger RSAStatus;

@protocol RSACommunicationProtocol;

@interface RSACommunication : NSObject <RSARequestProtocol>

@property (nonatomic,weak) id <RSACommunicationProtocol> delegate;
//@property NSString *stateToObserv; // SK unused

+(RSACommunication*) getInstance;
-(SecKeyRef) getApplicationPublicKey;

-(void) doKeyRequest;
-(void) doFacetRequest;
-(void) doDailyRequestForDate:(NSDate *) date;
-(void) doRecipeRequestForId:(NSString *) contentId;
-(void) doSearchRequestWithMessage:(NSString*) msg andIndex:(int) index;

@end

@protocol RSACommunicationProtocol <NSObject>
@optional
-(void) communicationFinishSuccessfulinStatus:(RSAStatus) status;
-(void) communicationFinishSuccessfulWithJSON:(NSDictionary*)json inStatus:(RSAStatus)status;
@required
-(void) communicationFailedinStatus:(RSAStatus) status;
@end
