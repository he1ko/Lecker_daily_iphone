//
//  AppStatus.h
//  Lecker
//
//  Created by Naujeck, Marcel on 26.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AppStatus : NSManagedObject

@property (nonatomic, retain) NSNumber * facetLoaded;
@property (nonatomic, retain) NSNumber * keyLoaded;

@end
