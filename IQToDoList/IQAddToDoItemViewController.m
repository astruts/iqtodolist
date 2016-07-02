//
//  IQAddToDoItemViewController.m
//  IQToDoList
//
//  Created by Yukon on 6/22/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "IQAddToDoItemViewController.h"

@interface IQAddToDoItemViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) NSString *textBeforeEdit;
@property (assign) NSInteger priorityBeforeEdit;
@property (weak, nonatomic) NSDate *dateBeforeEdit;

@end

@implementation IQAddToDoItemViewController

static NSString *const notificationAlertAction = @"Show me the item";
static NSString *const keyOfIdentifierOfLocalNotification = @"notification";

@synthesize toDoItem;

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ((sender == self.cancelButton) ||
        (self.textField.text.length <= 0))
    {
        self.toDoItem = nil;
        return;
    }
    if (self.isEditMode) {
        if ((![self.textBeforeEdit isEqualToString: self.textField.text]) ||
            (self.priorityBeforeEdit != self.segmentedControl.selectedSegmentIndex) ||
            (![self.dateBeforeEdit isEqualToDate: self.datePicker.date]))
        {
            [self deleteLocalNotification];
            [self fillToDoItemIfNotEmpty:self.indexItemInArray];
        }
    } else {
        [self fillToDoItemIfNotEmpty:self.countOfArray];
    }
}

- (void)fillToDoItemIfNotEmpty:(NSInteger)indexOfItemInArrayForNotification
{
    self.toDoItem.itemName = self.textField.text;
    self.toDoItem.completed = NO;
    self.toDoItem.priority = self.segmentedControl.selectedSegmentIndex;
    
    NSTimeInterval time = floor([self.datePicker.date timeIntervalSinceReferenceDate] / 60.0) * 60.0;
    self.toDoItem.date = [NSDate dateWithTimeIntervalSinceReferenceDate:time];
    NSDate *currentDate = [NSDate date];
    if ([[self.toDoItem.date earlierDate:currentDate] isEqualToDate:currentDate])
    {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = self.toDoItem.date;
        localNotification.alertBody = self.toDoItem.itemName;
        localNotification.alertAction = notificationAlertAction;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        NSDictionary *infoDict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%i", indexOfItemInArrayForNotification]
                                                                 forKey:keyOfIdentifierOfLocalNotification];
        localNotification.userInfo = infoDict;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

- (void)deleteLocalNotification
{
    NSArray *scheduledNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in scheduledNotifications)
    {
        //Get the ID you set when creating the notification
        NSString *stringIdentifierOfLocalNotification = [notification.userInfo objectForKey:keyOfIdentifierOfLocalNotification];
        if ([stringIdentifierOfLocalNotification intValue] == self.indexItemInArray)
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
    if ((toDoItem.itemName == nil) || (toDoItem.date == nil))
    {
        return;
    }
    self.textBeforeEdit = toDoItem.itemName;
    self.textField.text = toDoItem.itemName;
    self.priorityBeforeEdit = toDoItem.priority;
    self.segmentedControl.selectedSegmentIndex = toDoItem.priority;
    self.dateBeforeEdit = toDoItem.date;
    self.datePicker.date = toDoItem.date;
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
