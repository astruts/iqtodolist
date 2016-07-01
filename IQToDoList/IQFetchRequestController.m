//
//  IQFetchRequestController.m
//  IQToDoList
//
//  Created by Admin on 7/1/16.
//  Copyright (c) 2016 Admin. All rights reserved.
//

#import "IQFetchRequestController.h"
#import "IQCoreDataManager.h"

@implementation IQFetchRequestController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)initializeFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ToDoItem"];
    
    //NSSortDescriptor *lastNameSort = [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES];
    //[request setSortDescriptors:@[lastNameSort]];
    
    NSManagedObjectContext *moc = [[IQCoreDataManager new] managedObjectContext];
    [self setFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil]];
    [[self fetchedResultsController] setDelegate:self];
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
}

@end
