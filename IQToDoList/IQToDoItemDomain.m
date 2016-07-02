//
//  IQToDoItemDomain.m
//  IQToDoList
//
//  Created by Admin on 7/2/16.
//  Copyright (c) 2016 Admin. All rights reserved.
//

#import "IQToDoItemDomain.h"
#import "IQCoreDataManager.h"
#import "ToDoItemMO.h"

@interface IQToDoItemDomain ()

@property (strong, nonatomic) IQCoreDataManager *coreDataManager;

@end

@implementation IQToDoItemDomain

- (void)initializeIQToDoItemDomain:(IQCoreDataManager *)coreDataManager {
    [self  setCoreDataManager:coreDataManager];
}

- (void) createToDoItem:(ToDoItemMO *)newToDoItem {
    [[[self coreDataManager] managedObjectContext] insertObject:newToDoItem];
    [[[self coreDataManager] managedObjectContext] save:nil];
}

- (void) updateToDoItem:(ToDoItemMO *)currentToDoItem :(ToDoItemMO *)newToDoItem {
    currentToDoItem = newToDoItem;
    [[[self coreDataManager] managedObjectContext] save:nil];
}

- (void) deleteToDoItem:(ToDoItemMO *)currentToDoItem {
    [[[self coreDataManager] managedObjectContext] deleteObject:currentToDoItem];
    [[[self coreDataManager] managedObjectContext] save:nil];
}

@end
