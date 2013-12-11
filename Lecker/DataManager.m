//
//  DataManager.m
//  Lecker
//
//  Created by Naujeck, Marcel on 15.01.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "DataManager.h"
#import "FacetGroup.h"
#import "FacetExpr.h"
#import "Recipe.h"
#import <CoreData/CoreData.h>


@interface DataManager ()
@property NSString *clientId;
@end


@implementation DataManager

@synthesize managedObjectModel=_managedObjectModel;
@synthesize persistentStoreCoordinator=_persistentStoreCoordinator;
@synthesize managedObjectContext=_managedObjectContext;
@synthesize securityInformation=_securityInformation;
@synthesize facetGroupList=_facetGroupList;
@synthesize appStatus=_appStatus;

static DataManager *instance = NULL;

+ (DataManager *)getInstance
{
    @synchronized(self)
    {
        if (instance == NULL)
            return [[self alloc] init];
    }
    
    return(instance);
}

-(id)init
{
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

-(NSManagedObjectContext*) managedObjectContext
{
    if(_managedObjectContext==nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    }
    return _managedObjectContext;
}

-(NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel==nil) {
        _managedObjectModel=[NSManagedObjectModel mergedModelFromBundles:nil];
    }
    return _managedObjectModel;
}

-(NSURL*) applicationDocumentURL
{
    NSFileManager *aManager=[NSFileManager defaultManager];
    return [[aManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(NSPersistentStoreCoordinator*) persistentStoreCoordinator
{
    if(_persistentStoreCoordinator==nil) {
        NSURL *storeUrl=[[self applicationDocumentURL] URLByAppendingPathComponent:@"Lecker.sqllite"];
        NSError *error=nil;
        NSPersistentStoreCoordinator *aCoordinator=[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        if ([aCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
            _persistentStoreCoordinator=aCoordinator;
        } else {
            NSLog(@"coordinator %@", error);
        }
        
    }
    return _persistentStoreCoordinator;
}


#pragma mark - Recipes:

-(Recipe*) getDBRecipeWithContentId:(NSString*) contentId
{
    NSFetchRequest *request= [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:self.managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"contentId==%@", contentId];
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    NSError *error;
    Recipe *recipe = [[self.managedObjectContext executeFetchRequest:request error:&error] lastObject];
    if(error!=nil || recipe==nil) {
        return nil;
    }
    
    return recipe;
}

-(LeckerSingleRecipeDetailModel*) getRecipeWithContentId:(NSString*) contentId
{
    Recipe *recipe = [self getDBRecipeWithContentId:contentId];
    if(!recipe)
    {
        return nil;
    }
    
    LeckerSingleRecipeDetailModel *tmpRecipe = [[LeckerSingleRecipeDetailModel alloc] init];
    [tmpRecipe warpFromDB:recipe];
    return tmpRecipe;
}

-(NSArray*) getAllFavRecipes
{
    NSFetchRequest *request= [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSError *error;
    
    NSArray *tmpArray = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if(error!=nil || tmpArray==nil) {
        return nil;
    }
    
    NSMutableArray *resultArray=[[NSMutableArray alloc] init];
    
    for (Recipe *recipe in tmpArray) {
        LeckerSingleRecipeDetailModel *tmp=[[LeckerSingleRecipeDetailModel alloc] init];
        [tmp warpFromDB:recipe];
        [resultArray addObject:tmp];
    }
    
    return resultArray;
}

-(NSSet*) getAllRecipeContentIDs
{
    NSEntityDescription *entity = [NSEntityDescription  entityForName:@"Recipe" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setResultType:NSDictionaryResultType];
    [request setReturnsDistinctResults:YES];
    [request setPropertiesToFetch:@[@"contentId"]];
    NSError *error;
    
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (objects == nil) {
        NSLog(@"Error : %@",error);
        return nil;
    }
    
    NSMutableSet *tmpSet=[[NSMutableSet alloc] init];
    
    for (NSDictionary *tupel in objects) {
        [tmpSet addObject:[tupel valueForKey:@"contentId"]];
    }

    return tmpSet;
}

#pragma mark - Favorite Handling:

-(int) numberOfFavorits
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity: [NSEntityDescription entityForName: @"Recipe" inManagedObjectContext: self.managedObjectContext]];
    NSError *error = nil;
    NSUInteger count = [self.managedObjectContext countForFetchRequest: request error: &error];
    return count;
}

-(BOOL) favAlreadyInDB:(NSString*) contentId
{
    NSEntityDescription *entity = [NSEntityDescription  entityForName:@"Recipe" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setResultType:NSDictionaryResultType];
    [request setReturnsDistinctResults:YES];
    [request setPropertiesToFetch:@[@"contentId"]];
    NSError *error;
    
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (objects == nil) {
        NSLog(@"Error : %@",error);
        return NO;
    }
    for (NSDictionary *tupel in objects) {
        if([[tupel valueForKey:@"contentId"] isEqualToString:contentId]) {
            return YES;
        }
    }
    return  NO;
}

-(BOOL) insertFavRecipeWithRecipe:(LeckerSingleRecipeDetailModel*) recipe andImage:(UIImage*) image
{
    if(![self favAlreadyInDB:recipe.contentId])
    {
        Recipe* dbrecipe= [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:[self managedObjectContext]];
        dbrecipe.contentId=recipe.contentId;
        dbrecipe.title=recipe.title;
        dbrecipe.prepSteps=recipe.prepSteps;
        dbrecipe.fat=recipe.fat;
        dbrecipe.carbs=recipe.carbs;
        dbrecipe.kcal=recipe.kcal;
        dbrecipe.protein=recipe.protein;
        dbrecipe.image=UIImagePNGRepresentation(image);
        dbrecipe.ingredients=recipe.ingConcat;
        dbrecipe.prepTime=recipe.prepTime;
        
        NSError *error;
        if (![[self managedObjectContext] save:&error])
        {
            NSLog(@"Fav Fehler: %@ ",error);
            return NO;
        }
        else
        {
            NSLog(@"Fav inserted");
            return YES;
        }
    }
    else
    {
        return NO;
    }
}

-(void) deleteRecipeFromFavWithContentId:(NSString*) contentId
{
    Recipe *recipe = [self getDBRecipeWithContentId:contentId];
    [self.managedObjectContext deleteObject:recipe];
    [self updateModel];
}

#pragma mark - Facet Handling:

-(void) facetLoaded
{
    AppStatus *status= [self appStatus];
    status.facetLoaded=[NSNumber numberWithBool:YES];
    NSError *error;
    
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"Fehler :%@ ",error);
    }
}

-(NSArray*) facetGroupList
{
    if (!_facetGroupList) {
        NSError *error;
        NSFetchRequest* request = [[self managedObjectModel] fetchRequestTemplateForName:@"FetchFacetGroups"];
        _facetGroupList = [self.managedObjectContext executeFetchRequest:request error:&error];
    }
    return _facetGroupList;
}

-(void) deleteAllFacets
{
    for (NSManagedObject * entry in self.facetGroupList) {
        [self.managedObjectContext deleteObject:entry];
    }
    [self updateModel];
}

-(NSDictionary *) getAllFacetsAsHash
{
    NSEntityDescription *entity = [NSEntityDescription  entityForName:@"FacetExpr" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setResultType:NSDictionaryResultType];
    [request setReturnsDistinctResults:YES];
    [request setPropertiesToFetch:[NSArray arrayWithObjects:@"f_id",@"name",nil]];
    NSError *error;
    
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (objects == nil) {
        NSLog(@"Error : %@",error);
        return nil;
    }
    
    NSMutableDictionary *tmp=[[NSMutableDictionary alloc] initWithCapacity:objects.count];
    
    for (NSDictionary *tupel in objects) {
        [tmp setObject:[tupel valueForKey:@"name"] forKey:[tupel valueForKey:@"f_id"]];
    }
    
    return tmp;
}

-(BOOL) insertFacetGroupWithDirectory:(NSDictionary*) jsonDir
{
    FacetGroup* facetGrp= [NSEntityDescription insertNewObjectForEntityForName:@"FacetGroup" inManagedObjectContext:[self managedObjectContext]];
    facetGrp.name=[jsonDir objectForKey:@"name"];
    int index=0;
    for (NSDictionary *entry in [jsonDir objectForKey:@"Expr"]) {
        FacetExpr *facetExpr=[NSEntityDescription insertNewObjectForEntityForName:@"FacetExpr" inManagedObjectContext:[self managedObjectContext]];
        facetExpr.name=[entry objectForKey:@"name"];
        facetExpr.f_id=[entry objectForKey:@"id"];
        facetExpr.facetgroup=facetGrp;
        facetExpr.index=[NSNumber numberWithInt:index];
        [facetGrp addFacetexprObject:facetExpr];
        index++;
    }
    
    NSError *error;
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"Fehler :%@ ",error);
        return NO;
    } else {
        NSLog(@"Facetgroup inserted");
        return YES;
    }
    
    [self updateModel];
    
    _facetGroupList=nil;
}

#pragma mark - Shopping Card/List:

-(void) addToShoppingCard:(NSSet*) ingSet
{
    NSError *error;
    NSFetchRequest* request = [[self managedObjectModel] fetchRequestTemplateForName:@"FetchShoppingCard"];
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    for (NSString *ing in ingSet) {
        BOOL isIn=false;
        for (ShoppingCard *item in array) {
            if([ing isEqualToString:item.ingredients]) {
                item.value=[[NSDecimalNumber alloc] initWithInt:(item.value.intValue+1)];
                isIn=YES;
            }
        }
        if(!isIn) {
            ShoppingCard *scard= [NSEntityDescription insertNewObjectForEntityForName:@"ShoppingCard" inManagedObjectContext:[self managedObjectContext]];
            scard.ingredients=ing;
            scard.value=[[NSDecimalNumber alloc] initWithInt:1];
        }
    }
    
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"Fehler :%@ ",error);
    }
}

-(int) numberOfShoppingCardItems
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity: [NSEntityDescription entityForName: @"ShoppingCard" inManagedObjectContext: self.managedObjectContext]];
    NSError *error = nil;
    NSUInteger count = [self.managedObjectContext countForFetchRequest: request error: &error];
    return count;
}

-(NSArray*) getAllShoppingListItems
{
    NSError *error;
    NSFetchRequest* request = [[self managedObjectModel] fetchRequestTemplateForName:@"FetchShoppingCard"];
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    return array;
}

-(void) removeFromShoppingCard:(NSSet*) ingSet
{
    NSError *error;
    NSFetchRequest* request = [[self managedObjectModel] fetchRequestTemplateForName:@"FetchShoppingCard"];
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    for (NSString *ing in ingSet) {
        for (ShoppingCard *item in array) {
            if([ing isEqualToString:item.ingredients]) {
                [self.managedObjectContext deleteObject:item];
            }
        }
    }
    [self updateModel];
}

#pragma mar - Client ID:

-(void) insertClientID:(NSString*) clientId
{
    Security* sec=[self securityInformation];
    if(sec==nil) {
        sec = [NSEntityDescription insertNewObjectForEntityForName:@"Security" inManagedObjectContext:[self managedObjectContext]];
    }
    
    sec.clientid=clientId;
    
    NSError *error;
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"Fehler :%@ ",error);
    } else {
        NSLog(@"Client ID inserted");
    }
}


#pragma mark - Various

-(AppStatus*) appStatus
{
    if(!_appStatus) {
        NSError *error;
        NSFetchRequest* request = [[self managedObjectModel] fetchRequestTemplateForName:@"FetchAppStatus"];
        NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
        if (array == nil) {
            NSLog(@"Error : %@",error);
        }
        if (array.count>0) {
            _appStatus=[array objectAtIndex:0];
        } else {
            _appStatus= [NSEntityDescription insertNewObjectForEntityForName:@"AppStatus" inManagedObjectContext:[self managedObjectContext]];
            _appStatus.facetLoaded=[NSNumber numberWithBool:NO];
            _appStatus.keyLoaded=[NSNumber numberWithBool:NO];
            if (![[self managedObjectContext] save:&error]) {
                NSLog(@"Fehler :%@ ",error);
            }
            
        }
    }
    return _appStatus;
}

-(Security*) securityInformation
{
    if (!_securityInformation) {
        NSError *error;
        NSFetchRequest* request = [[self managedObjectModel] fetchRequestTemplateForName:@"FetchSecurityInformation"];
        NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
        if (array == nil) {
            NSLog(@"Error : %@",error);
        }
        if (array.count>0) _securityInformation=[array objectAtIndex:0];
    }
    
    return _securityInformation;
}

-(void) updateModel
{
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Fehler :%@ ",error);
    } else {
        NSLog(@"Daten aktualiesiert");
    }
}

@end
