//
//  ShoppingCard.h
//  Lecker
//
//  Created by Naujeck, Marcel on 26.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ShoppingCard : NSManagedObject

@property (nonatomic, retain) NSString * ingredients;
@property (nonatomic, retain) NSDecimalNumber * value;

@end
