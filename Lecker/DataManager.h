//
//  DataManager.h
//  Lecker
//
//  Created by Naujeck, Marcel on 15.01.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Security.h"
#import "AppStatus.h"
#import "LeckerSingleRecipeDetailModel.h"
#import "ShoppingCard.h"

@interface DataManager : NSObject

@property (strong, nonatomic) NSManagedObjectModel* managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator* persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;
+ (DataManager *)getInstance;
@property (nonatomic)  Security *securityInformation;
@property (nonatomic)  NSArray *facetGroupList;
@property (nonatomic)  AppStatus *appStatus;

// Recipes:
-(LeckerSingleRecipeDetailModel*) getRecipeWithContentId:(NSString*) contentId;
-(NSSet*) getAllRecipeContentIDs;

// Favorite Handling:
-(int) numberOfFavorits;
-(BOOL) favAlreadyInDB:(NSString*) contentId;
-(NSArray*) getAllFavRecipes;
-(BOOL) insertFavRecipeWithRecipe:(LeckerSingleRecipeDetailModel*) recipe andImage:(UIImage*) image;
-(void) deleteRecipeFromFavWithContentId:(NSString*) contentId;

// Facet Handling:
-(BOOL) insertFacetGroupWithDirectory:(NSDictionary*) jsonDir;
-(void) deleteAllFacets;
-(void) facetLoaded;
-(NSDictionary *) getAllFacetsAsHash;

// Shopping Card/List:
-(void) addToShoppingCard:(NSSet*) ingSet;
-(int) numberOfShoppingCardItems;
-(NSArray*) getAllShoppingListItems;
-(void) removeFromShoppingCard:(NSSet*) ingSet;

// Client ID:
-(void) insertClientID:(NSString*) clientId;

@end
