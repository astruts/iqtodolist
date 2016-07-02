//
//  IQToDoItemDomain.h
//  IQToDoList
//
//  Created by Admin on 7/2/16.
//  Copyright (c) 2016 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IQCoreDataManager.h"
#import "ToDoItemMO.h"

@interface IQToDoItemDomain : NSObject

- (void)initializeIQToDoItemDomain:(NSManagedObjectContext *)managedObjectContext;
- (void) createToDoItem:(ToDoItemMO *)youngToDoItem;
- (void) updateToDoItem:(ToDoItemMO *)currentToDoItem :(ToDoItemMO *)youngToDoItem;
- (void) deleteToDoItem:(ToDoItemMO *)currentToDoItem;

@end
