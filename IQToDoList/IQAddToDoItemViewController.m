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

@property (nonatomic, assign) id currentResponder;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *ClaseKeyboard;

@end

@implementation IQAddToDoItemViewController

static NSString *const notificationAlertAction = @"Show me the item";

@synthesize toDoItem;

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender == self.cancelButton)
    {
        self.toDoItem = nil;
        return;
    }
    
    if (self.isEditMode) {
        if ((![self.textBeforeEdit isEqualToString: self.textField.text]) ||
            (self.priorityBeforeEdit != self.segmentedControl.selectedSegmentIndex) ||
            (![self.dateBeforeEdit isEqualToDate: self.datePicker.date]))
        {
            [self fillToDoItemIfNotEmpty];
        }
    } else {
        [self fillToDoItemIfNotEmpty];
    }
}

- (void)fillToDoItemIfNotEmpty
{
    if (self.textField.text.length > 0) {
        self.toDoItem.itemName = self.textField.text;
        self.toDoItem.completed = NO;
        self.toDoItem.priority = self.segmentedControl.selectedSegmentIndex;
        NSTimeInterval time = floor([self.datePicker.date timeIntervalSinceReferenceDate] / 60.0) * 60.0;
        self.toDoItem.date = [NSDate dateWithTimeIntervalSinceReferenceDate:time];
        //self.toDoItem.date = self.datePicker.date;
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = self.toDoItem.date;
        localNotification.alertBody = self.toDoItem.itemName;
        localNotification.alertAction = notificationAlertAction;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
//        // Request to reload table view data
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
        
        // Dismiss the view controller
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        self.toDoItem = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnSwipe:)];
    [self.view addGestureRecognizer:swipe];
    
    // Do any additional setup after loading the view.
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

//Implement the below delegate method:
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
}

//Implement resignOnSwipe:
- (void)resignOnSwipe:(id)sender {
    [self.currentResponder resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//declare a property to store your current responder


@end
