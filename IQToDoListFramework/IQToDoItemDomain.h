//
//  IQToDoItemDomain.h
//  IQToDoList
//
//  Created by Admin on 7/2/16.
//  Copyright (c) 2016 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "IQCoreDataManager.h"
#import "ToDoItemMO.h"

@interface IQToDoItemDomain : NSObject

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (void) saveCreatedToDoItem:(ToDoItemMO *)youngToDoItem;
- (void) deleteToDoItem:(ToDoItemMO *)currentToDoItem;

@end
