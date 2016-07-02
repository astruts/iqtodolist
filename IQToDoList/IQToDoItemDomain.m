//
//  IQToDoItemDomain.m
//  IQToDoList
//
//  Created by Admin on 7/2/16.
//  Copyright (c) 2016 Admin. All rights reserved.
//

#import "IQToDoItemDomain.h"

@interface IQToDoItemDomain ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation IQToDoItemDomain

- (void)initializeIQToDoItemDomain:(NSManagedObjectContext *)managedObjectContext {
    [self  setManagedObjectContext:managedObjectContext];
}

- (void) createToDoItem:(ToDoItemMO *)youngToDoItem {
    [[self managedObjectContext] insertObject:youngToDoItem];
    [[self managedObjectContext] save:nil];
}

- (void) updateToDoItem:(ToDoItemMO *)currentToDoItem :(ToDoItemMO *)youngToDoItem {
    [[self managedObjectContext] deleteObject:currentToDoItem];
    [[self managedObjectContext] insertObject:youngToDoItem];
    //currentToDoItem = youngToDoItem;
    [[self managedObjectContext] save:nil];
}

- (void) deleteToDoItem:(ToDoItemMO *)currentToDoItem {
    [[self managedObjectContext] deleteObject:currentToDoItem];
    [[self managedObjectContext] save:nil];
}

@end
