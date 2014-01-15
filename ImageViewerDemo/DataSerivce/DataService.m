//
//  RepositoryService.m
//  SBJSon_Touch
//
//  Created by vnicon on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataService.h"
#import <CoreData/CoreData.h>

@implementation DataService
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Util
+ (DataService *) sharedInstance
{
    static DataService *sharedDataService;
    static dispatch_once_t onceToken;
      dispatch_once(&onceToken, ^{
            sharedDataService = [[DataService alloc] init];
        
    });
    return sharedDataService;
}

//+ (NSManagedObjectContext *) defaultContext
//{
//    @synchronized (self)
//    {
//        return [[DataService sharedInstance] managedObjectContext];
//    }
//}

- (void) saveContext
{
    NSError *error = nil;
   
    if(_managedObjectContext != nil)
    {
        if([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
            abort();
        }
    }
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory 
                                                   inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
//    if (_managedObjectModel != nil)
//    {
//        return _managedObjectModel;
//    }
//    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
//    return _managedObjectModel;
    
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"IMAGE"
                                              withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *url = [self applicationDocumentsDirectory];
    NSURL *storeURL = [url URLByAppendingPathComponent:@"IMAGE.sqlite"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:[storeURL path]])
    {
        NSURL *defaultURL = [[NSBundle mainBundle] URLForResource:@"IMAGE"
                                                    withExtension:@"sqlite"];
        if(defaultURL)
        {
            [fileManager copyItemAtURL:defaultURL toURL:storeURL error:nil];
        }
    }
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];	
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    
    NSError *error;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }        return _persistentStoreCoordinator;
}

//delete 
- (void)deleteAllDataInEntity 
{
    NSManagedObjectContext *context = [[DataService sharedInstance] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"IMAGE" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *managedObject in items) 
    {
        [context deleteObject:managedObject];
    }
    [[DataService sharedInstance] saveContext];
    // NSLog(@"DONE DELETE");
}

- (void) deleteDataInEntityWithId:(NSString*) imageId
{
    NSManagedObjectContext *context = [[DataService sharedInstance] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"IMAGE" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"imageId == %@", imageId];
    
    NSArray* neededDeleteItems = [items filteredArrayUsingPredicate:predicate];
    
    if (neededDeleteItems && [neededDeleteItems count] >0)
    {
        IMAGE* image = (IMAGE*) [neededDeleteItems objectAtIndex:0];
        
        //Delete this image in document directory
        [[NSFileManager defaultManager] removeItemAtPath: image.imagePath error: nil];
        [[NSFileManager defaultManager] removeItemAtPath: image.thumbPath error: nil];

        
        for (NSManagedObject *managedObject in neededDeleteItems)
        {
            [context deleteObject:managedObject];
        }
        [[DataService sharedInstance] saveContext];
    }
}

//get All

- (NSArray*) selectAllByContext
{
    NSManagedObjectContext *context = [[DataService sharedInstance] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"IMAGE" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    //NSLog(@"%d",items.count);
    
    return items;
}

@end
