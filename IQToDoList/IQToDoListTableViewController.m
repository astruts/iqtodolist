//
//  IQToDoListTableViewController.m
//  IQToDoList
//
//  Created by Yukon on 6/22/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "IQToDoListTableViewController.h"
#import "IQToDoItem.h"
#import "IQAddToDoItemViewController.h"
#import "IQPriorities.h"
#import "ToDoItemMO.h"
#import "IQAppDelegate.h"
#import "IQToDoItemDomain.h"

@interface IQToDoListTableViewController ()

@property NSMutableArray *toDoItems;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) IQToDoItemDomain *toDoItemDomain;

@end

@implementation IQToDoListTableViewController

static NSString *const cellIdentifier = @"ListPrototypeCell";
static NSString *const titleOfEditMode = @"Add To-Do Item";
static NSString *const titleOfAddMode = @"Edit To-Do Item";
static NSString *const lowPriority = @"Low priority ";
static NSString *const middlePriority = @"Middle priority ";
static NSString *const highPriority = @"High priority ";
static NSString *const keyOfIdentifierOfLocalNotification = @"notification";
static NSString *const identifierOfEditMode= @"editItem";
static NSString *const identifierOfAddMode= @"addItem";

/*- (void)loadInitialData {
    IQToDoItem *item1 = [[IQToDoItem alloc] init];
    item1.itemName = @"Buy milk";
    item1.priority = 0;
    item1.date = [NSDate date];
    [self.toDoItems addObject:item1];
    IQToDoItem *item2 = [[IQToDoItem alloc] init];
    item2.itemName = @"Buy eggs";
    item2.priority = 1;
    item2.date = [NSDate date];
    [self.toDoItems addObject:item2];
    IQToDoItem *item3 = [[IQToDoItem alloc] init];
    item3.itemName = @"Read a book";
    item3.priority = 2;
    item3.date = [NSDate date];
    [self.toDoItems addObject:item3];
}*///

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    IQAddToDoItemViewController *source = [segue sourceViewController];
    //ToDoItemMO *item = source.toDoItem;
    if (source.youngToDoItem == nil) {
        return;
    }
    if (source.isEditMode) {
        //[self.toDoItems replaceObjectAtIndex:[source.indexItemInArray intValue]  withObject:item];//
        [self.toDoItemDomain updateToDoItem:source.currentToDoItem :source.youngToDoItem];
    } else {
        //[self.toDoItems addObject:item];//
        [self.toDoItemDomain createToDoItem:source.youngToDoItem];
    }
    //[self.tableView reloadData];//
}

- (void)addLocalNotification
{
    /*NSDate *currentDate = [NSDate date];
    if ([[self.toDoItem.itemDate earlierDate:currentDate] isEqualToDate:currentDate])
    {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = self.toDoItem.itemDate;
        localNotification.alertBody = self.toDoItem.itemName;
        localNotification.alertAction = notificationAlertAction;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        NSDictionary *infoDict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%i", indexOfItemInArrayForNotification]
                                                             forKey:keyOfIdentifierOfLocalNotification];
        localNotification.userInfo = infoDict;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }*/
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.toDoItems = [[NSMutableArray alloc] init];//
    IQAppDelegate *appDelegate = (IQAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [[appDelegate coreDataManager] managedObjectContext];
    [self initializeFetchedResultsController:self.managedObjectContext];
    self.toDoItemDomain = [IQToDoItemDomain new];
    [self.toDoItemDomain initializeIQToDoItemDomain:self.managedObjectContext];
    //[self loadInitialData];//
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath*)indexPath
{
    ToDoItemMO *toDoItem = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    // Populate cell from the NSManagedObject instance
    cell.textLabel.text = toDoItem.itemName;
    NSString *stringPriority = [IQPriorities instance].priorities[toDoItem.itemPriority.intValue];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSString *prettyDate = [formatter stringFromDate:toDoItem.itemDate];
    cell.detailTextLabel.text = [stringPriority stringByAppendingString:prettyDate];
    if ([toDoItem.itemIsChecked boolValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    // Set up the cell
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id< NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.toDoItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                            forIndexPath:indexPath];
    IQToDoItem *toDoItem = [self.toDoItems objectAtIndex:indexPath.row];
    cell.textLabel.text = toDoItem.itemName;
    NSString * stringPriority = [IQPriorities instance].priorities[toDoItem.priority];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSString *prettyDate = [formatter stringFromDate:toDoItem.date];
    cell.detailTextLabel.text = [stringPriority stringByAppendingString:prettyDate];
    if (toDoItem.completed) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}*/

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteRowAtIndexPath:indexPath];
    }
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:identifierOfEditMode] && !self.tableView.editing) {
        return NO;
    }
    return YES;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if ([segue.identifier isEqualToString:identifierOfAddMode]) {
        [self prepareViewControllerForSegue:segue
                                   withItem:nil
                                  withTitle:titleOfEditMode
                            withIndexOfItem:indexPath.row+1
                                 isEditMode:NO];
    }
    if ([segue.identifier isEqualToString:identifierOfEditMode] && self.tableView.editing) {
        /*NSFetchRequest *request = [NSFetchRequest new];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ToDoItem"
                                                  inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"empId = %d", 12345]];
        [request setPredicate:pred];
        
        NSArray *empArray=[self.managedObjectContext executeFetchRequest:request error:nil];
        ToDoItemMO *toDoItemForEditing;
        if ([empArray count] > 0){
            toDoItemForEditing = [empArray objectAtIndex:0];
        }*/
        ToDoItemMO *toDoItemForEditing = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [self prepareViewControllerForSegue:segue
                                   withItem:toDoItemForEditing
                                  withTitle:titleOfAddMode
                            withIndexOfItem:indexPath.row
                                 isEditMode:YES];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (!tableView.editing) {
        ToDoItemMO *tappedItem = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        tappedItem.itemIsChecked = [NSNumber numberWithBool:![tappedItem.itemIsChecked boolValue]];
        [tableView reloadRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - Private methods

- (void) deleteRowAtIndexPath:(NSIndexPath *)indexPath {
    //remove from UILocalNotification
    NSArray *scheduledNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in scheduledNotifications)
    {
        //Get the ID you set when creating the notification
        NSString *stringIdentifierOfLocalNotification = [notification.userInfo objectForKey:keyOfIdentifierOfLocalNotification];
    
        if ([stringIdentifierOfLocalNotification intValue] == indexPath.row)
        {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            break;
        }
    }
    //remove from NSMutableArray
    //[_toDoItems removeObjectAtIndex:indexPath.row];//
    ToDoItemMO *toDoItem = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [[self toDoItemDomain] deleteToDoItem:toDoItem];
    //remove from table view
    //[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];//
    //recalculate userinfo UILocalNotification
    NSInteger notifCount = [[[UIApplication sharedApplication] scheduledLocalNotifications] count];
    for (int j = 0; j < notifCount; j++) {
        UILocalNotification *notification = [[[UIApplication sharedApplication] scheduledLocalNotifications] objectAtIndex:j];
        if ([notification.userInfo objectForKey:keyOfIdentifierOfLocalNotification] > [NSString stringWithFormat:@"%i", indexPath.row]) {
            NSInteger integerIdentifierOfLocalNotification = [[notification.userInfo objectForKey:keyOfIdentifierOfLocalNotification] intValue];
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            integerIdentifierOfLocalNotification--;
            NSDictionary *infoDict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%i", integerIdentifierOfLocalNotification]
                                                                 forKey:keyOfIdentifierOfLocalNotification];
            [notification setUserInfo:infoDict];
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
    }
}

- (void)prepareViewControllerForSegue:(UIStoryboardSegue *)segue
                             withItem:(ToDoItemMO *)item
                            withTitle:(NSString *)title
                      withIndexOfItem:(NSInteger)numberOfItem
                           isEditMode:(BOOL)editMode
{
    UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
    IQAddToDoItemViewController *viewController = (IQAddToDoItemViewController *)navController.topViewController;
    
    viewController.currentToDoItem = item;
    viewController.title = title;
    viewController.indexItemInArray = [NSNumber numberWithInt:numberOfItem];
    viewController.isEditMode = editMode;
}

#pragma mark - Initialize FetchedResultsController

- (void)initializeFetchedResultsController:(NSManagedObjectContext *)managedObjectContext
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ToDoItem"];
    NSSortDescriptor *itemNameSort = [NSSortDescriptor sortDescriptorWithKey:@"itemName" ascending:YES];
    [request setSortDescriptors:@[itemNameSort]];
    NSFetchedResultsController *fetchRequestController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                             managedObjectContext:managedObjectContext
                                                                                               sectionNameKeyPath:nil
                                                                                                        cacheName:nil];
    [self  setFetchedResultsController:fetchRequestController];
    [[self fetchedResultsController] setDelegate:self];
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [[self tableView] beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [[self tableView] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [[self tableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[[self tableView] cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [[self tableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [[self tableView] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [[self tableView] endUpdates];
}

@end
