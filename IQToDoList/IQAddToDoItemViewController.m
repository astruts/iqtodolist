//
//  IQAddToDoItemViewController.m
//  IQToDoList
//
//  Created by Yukon on 6/22/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "IQAddToDoItemViewController.h"
#import "IQAppDelegate.h"

@interface IQAddToDoItemViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation IQAddToDoItemViewController

//@synthesize newToDoItem = _newToDoItem;

static NSString *const notificationAlertAction = @"Show me the item";
static NSString *const keyOfIdentifierOfLocalNotification = @"notification";

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ((sender == self.cancelButton) ||
        (self.textField.text.length <= 0))
    {
        self.youngToDoItem = nil;
        return;
    }
    if (self.isEditMode) {
        if ((![self.currentToDoItem.itemName isEqualToString: self.textField.text]) ||
            ([self.currentToDoItem.itemPriority intValue] != self.segmentedControl.selectedSegmentIndex) ||
            (![self.currentToDoItem.itemDate isEqualToDate: self.datePicker.date]))
        {
            [self deleteLocalNotification];
            [self fillToDoItemIfNotEmpty];
        }
    } else {
        [self fillToDoItemIfNotEmpty];
    }
}

- (void)fillToDoItemIfNotEmpty
{
    IQAppDelegate *appDelegate = (IQAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.youngToDoItem = [appDelegate.coreDataManager toDoItem];
    [self.youngToDoItem setItemName:self.textField.text];
    self.youngToDoItem.itemIsChecked = [NSNumber numberWithBool:NO];
    self.youngToDoItem.itemPriority = [NSNumber numberWithInt:self.segmentedControl.selectedSegmentIndex];
    NSTimeInterval time = floor([self.datePicker.date timeIntervalSinceReferenceDate] / 60.0) * 60.0;
    self.youngToDoItem.itemDate = [NSDate dateWithTimeIntervalSinceReferenceDate:time];
}

- (void)deleteLocalNotification
{
    NSArray *scheduledNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in scheduledNotifications)
    {
        //Get the ID you set when creating the notification
        NSString *stringIdentifierOfLocalNotification = [notification.userInfo objectForKey:keyOfIdentifierOfLocalNotification];
        if ([stringIdentifierOfLocalNotification intValue] == [self.indexItemInArray intValue])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            break;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.datePicker.date = [NSDate dateWithTimeIntervalSinceNow:60];
    if (self.currentToDoItem == nil)
    {
        return;
    }
    self.textField.text = self.currentToDoItem.itemName;
    self.segmentedControl.selectedSegmentIndex = [self.currentToDoItem.itemPriority intValue];
    self.datePicker.date = self.currentToDoItem.itemDate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)CloseKeyboard:(UISwipeGestureRecognizer *)sender {
    [self.textField resignFirstResponder];
}

- (IBAction)CloseKeyboardUp:(UISwipeGestureRecognizer *)sender {
    [self.textField resignFirstResponder];
}

@end
