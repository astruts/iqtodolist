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

static NSInteger const countOfSecondsInOneMinute = 60;

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ((sender == self.cancelButton) ||
        (self.textField.text.length <= 0)) {
        return;
    }
    if (self.isEditMode) {
        if ((![self.currentToDoItem.itemName isEqualToString: self.textField.text]) ||
            ([self.currentToDoItem.itemPriority intValue] != self.segmentedControl.selectedSegmentIndex) ||
            (![self.currentToDoItem.itemDate isEqualToDate: self.datePicker.date])) {
            [self fillToDoItem];
        }
    } else {
        [self fillToDoItem];
    }
}

- (void)fillToDoItem {
    NSTimeInterval time = floor([self.datePicker.date timeIntervalSinceReferenceDate] / countOfSecondsInOneMinute) * countOfSecondsInOneMinute;
    NSDate *pickedDate = [NSDate dateWithTimeIntervalSinceReferenceDate:time];
    //Can not pick earlier then current time date
    NSDate *currentDate = [NSDate date];
    if ([[pickedDate earlierDate:currentDate] isEqualToDate:pickedDate]) {
        return;
    }
    
    IQAppDelegate *appDelegate = (IQAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.youngToDoItem = [appDelegate.coreDataManager toDoItem];
    [self.youngToDoItem setItemName:self.textField.text];
    self.youngToDoItem.itemIsChecked = [NSNumber numberWithBool:NO];
    self.youngToDoItem.itemPriority = [NSNumber numberWithInt:self.segmentedControl.selectedSegmentIndex];
    self.youngToDoItem.itemDate = pickedDate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.datePicker.date = [NSDate dateWithTimeIntervalSinceNow:countOfSecondsInOneMinute];
    if (self.currentToDoItem == nil)
    {
        return;
    }
    self.textField.text = self.currentToDoItem.itemName;
    self.segmentedControl.selectedSegmentIndex = [self.currentToDoItem.itemPriority intValue];
    self.datePicker.date = self.currentToDoItem.itemDate;
    self.youngToDoItem = nil;
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
