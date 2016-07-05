//
//  IQToDoListTableViewController.m
//  IQToDoList
//
//  Created by Yukon on 6/22/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "IQToDoListTableViewController.h"
#import "IQAddToDoItemViewController.h"
#import "IQPriorities.h"
#import "ToDoItemMO.h"
#import "IQAppDelegate.h"
#import "IQToDoItemDomain.h"

@interface IQToDoListTableViewController ()

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

static NSString *const notificationAlertAction = @"Show me the item";
static NSString *const keyOfIdentifierOfLocalNotification = @"objectID";

static NSString *const identifierOfEditMode= @"editItem";
static NSString *const identifierOfAddMode= @"addItem";

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    IQAddToDoItemViewController *source = [segue sourceViewController];
    if (source.youngToDoItem == nil){
        return;
    }
    if (source.isEditMode) {
        [self deleteLocalNotification:source.currentToDoItem];
        [self.toDoItemDomain updateToDoItem:source.currentToDoItem :source.youngToDoItem];
        [self addLocalNotification:source.youngToDoItem];
    } else {
        [self.toDoItemDomain createToDoItem:source.youngToDoItem];
        [self addLocalNotification:source.youngToDoItem];
    }
}

- (void)addLocalNotification:(ToDoItemMO *)toDoItem {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = toDoItem.itemDate;
    localNotification.alertBody = toDoItem.itemName;
    localNotification.alertAction = notificationAlertAction;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    NSManagedObjectID *managgedObjectId = toDoItem.objectID;
    NSString *stringID = [managgedObjectId.URIRepresentation absoluteString];
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:stringID
                                                         forKey:keyOfIdentifierOfLocalNotification];
    localNotification.userInfo = infoDict;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void)deleteLocalNotification:(ToDoItemMO *)toDoItem {
    NSManagedObjectID *managgedObjectId = toDoItem.objectID;
    NSString *stringID = [managgedObjectId.URIRepresentation absoluteString];
    NSArray *scheduledNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in scheduledNotifications) {
        //Get the ID you set when creating the notification
        NSString *stringIdentifierOfLocalNotification = [notification.userInfo objectForKey:keyOfIdentifierOfLocalNotification];
        if ([stringIdentifierOfLocalNotification isEqualToString:stringID]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            break;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    IQAppDelegate *appDelegate = (IQAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [[appDelegate coreDataManager] managedObjectContext];
    [self initializeFetchedResultsController:self.managedObjectContext];
    self.toDoItemDomain = [IQToDoItemDomain new];
    [self.toDoItemDomain initializeIQToDoItemDomain:self.managedObjectContext];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath*)indexPath {
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    ToDoItemMO *toDoItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
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
    cell.backgroundColor = [IQPriorities instance].colors[toDoItem.itemPriority.intValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    // Set up the cell
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id< NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

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
                                 isEditMode:NO];
    }
    if ([segue.identifier isEqualToString:identifierOfEditMode] && self.tableView.editing) {
        ToDoItemMO *toDoItemForEditing = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self prepareViewControllerForSegue:segue
                                   withItem:toDoItemForEditing
                                  withTitle:titleOfAddMode
                                 isEditMode:YES];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (!tableView.editing) {
        ToDoItemMO *tappedItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
        tappedItem.itemIsChecked = [NSNumber numberWithBool:![tappedItem.itemIsChecked boolValue]];
        [tableView reloadRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - Private methods

- (void) deleteRowAtIndexPath:(NSIndexPath *)indexPath {
    //remove from UILocalNotification
    ToDoItemMO *toDoItem = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [self deleteLocalNotification:toDoItem];
    //remove from Data Base
    [self.toDoItemDomain deleteToDoItem:toDoItem];
}

- (void)prepareViewControllerForSegue:(UIStoryboardSegue *)segue
                             withItem:(ToDoItemMO *)item
                            withTitle:(NSString *)title
                           isEditMode:(BOOL)editMode {
    UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
    IQAddToDoItemViewController *viewController = (IQAddToDoItemViewController *)navController.topViewController;
    viewController.currentToDoItem = item;
    viewController.title = title;
    viewController.isEditMode = editMode;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (editing) {
        [self.tableView reloadData];
    }
}

#pragma mark - Initialize FetchedResultsController

- (void)initializeFetchedResultsController:(NSManagedObjectContext *)managedObjectContext {
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.estimatedRowHeight = 70.0; // for example. Set your average height
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView reloadData];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

@end
