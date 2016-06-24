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

@interface IQToDoListTableViewController ()

@property NSMutableArray *toDoItems;

@end

@implementation IQToDoListTableViewController

static NSString *const titleOfEditMode = @"Add To-Do Item";
static NSString *const titleOfAddMode = @"Edit To-Do Item";
static NSString *const lowPriority = @"Low priority ";
static NSString *const middlePriority = @"Middle priority ";
static NSString *const highPriority = @"High priority ";

- (void)loadInitialData {
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
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    IQAddToDoItemViewController *source = [segue sourceViewController];
    IQToDoItem *item = source.toDoItem;
    
    if (item == nil) {
        return;
    }
    
    if (source.isEditMode) {
        [self.toDoItems replaceObjectAtIndex:source.indexItemInArray withObject:item];;
    } else {
        [self.toDoItems addObject:item];
    }
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.toDoItems = [[NSMutableArray alloc] init];
    [self loadInitialData];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.toDoItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ListPrototypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    IQToDoItem *toDoItem = [self.toDoItems objectAtIndex:indexPath.row];
    cell.textLabel.text = toDoItem.itemName;
    NSString * stringPriority;
    switch (toDoItem.priority)
    {
        case 0:
            stringPriority = lowPriority;
            break;
        case 1:
            stringPriority = middlePriority;
            break;
        case 2:
            stringPriority = highPriority;
            break;
        default:
            break; 
    }
    cell.detailTextLabel.text = [stringPriority stringByAppendingString:toDoItem.date.description];
    if (toDoItem.completed) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove from NSMutableArray
        [_toDoItems removeObjectAtIndex:indexPath.row];
        //remove from table view
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"editItem"] && !self.tableView.editing) {
        return NO;
    }
    return YES;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"addItem"]) {
        [self prepareViewControllerForSegue:segue withItem:[[IQToDoItem alloc] init] withTitle:titleOfEditMode withIndexOfItem:0 isEditMode:NO];
    }
    if ([segue.identifier isEqualToString:@"editItem"] && self.tableView.editing) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        IQToDoItem *toDoItemForEditing = [self.toDoItems objectAtIndex:indexPath.row];
        [self prepareViewControllerForSegue:segue withItem:toDoItemForEditing withTitle:titleOfAddMode withIndexOfItem:indexPath.row isEditMode:YES];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (!tableView.editing) {
        IQToDoItem *tappedItem = [self.toDoItems objectAtIndex:indexPath.row];
        tappedItem.completed = !tappedItem.completed;
        [tableView reloadRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - Private methods

- (void)prepareViewControllerForSegue:(UIStoryboardSegue *)segue
                             withItem:(IQToDoItem *)item
                            withTitle:(NSString *)title
                      withIndexOfItem:(NSInteger)numberOfItem
                           isEditMode:(BOOL)editMode
{
    UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
    IQAddToDoItemViewController *viewController = (IQAddToDoItemViewController *)navController.topViewController;
    
    viewController.toDoItem = item;
    viewController.title = title;
    viewController.indexItemInArray = numberOfItem;
    viewController.isEditMode = editMode;
}

@end
