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

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    self = [super init];
    [self setManagedObjectContext:managedObjectContext];
    return self;
}

- (void) saveCreatedToDoItem:(ToDoItemMO *)youngToDoItem {
    [self.managedObjectContext save:nil];
}

- (void) deleteToDoItem:(ToDoItemMO *)currentToDoItem {
    [self.managedObjectContext deleteObject:currentToDoItem];
    [self.managedObjectContext save:nil];
}

@end
