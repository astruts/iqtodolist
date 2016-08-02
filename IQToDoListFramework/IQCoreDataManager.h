//
//  IQCoreDataManager.h
//  IQToDoList
//
//  Created by Admin on 7/1/16.
//  Copyright (c) 2016 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ToDoItemMO.h"

@interface IQCoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) ToDoItemMO *createToDoItem;

+(instancetype) instance;
- (void)saveContext;

@end
