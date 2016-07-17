//
//  IQMigrationTest.m
//  IQToDoList
//
//  Created by Andrii Struts on 7/17/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>

@interface IQMigrationTest : XCTestCase

@end

@implementation IQMigrationTest

- (void)testStore {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [self performTestWithStoreName:@"IQToDoList"];
}

- (void)performTestWithStoreName:(NSString *)name
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *storeURL = [bundle URLForResource:name withExtension:@"sqlite"];
    
    XCTAssertNotNil(storeURL, @"Cannot find %@.sqlite", name);
    
    NSURL *modelURL = [bundle URLForResource:@"IQToDoList" withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    XCTAssertNotNil(managedObjectModel, @"Cannot load model");
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                                                initWithManagedObjectModel:managedObjectModel];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSError *error;
    NSPersistentStore *persistentStore = [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                                  configuration:nil URL:storeURL options:options error:&error];
    
    XCTAssertNotNil(persistentStore, @"Cannot load persistentStore: %@", [error localizedDescription]);
}

@end
