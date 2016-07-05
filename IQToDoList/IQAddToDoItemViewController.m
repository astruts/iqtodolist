//
//  IQAddToDoItemViewController.m
//  IQToDoList
//
//  Created by Yukon on 6/22/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "IQAddToDoItemViewController.h"
#import "IQCoreDataManager.h"

@interface IQAddToDoItemViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation IQAddToDoItemViewController

static NSInteger const CountOfSecondsInOneMinute = 60;

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

- (NSDate *)isEarlierThenCurrentDate:(NSTimeInterval)time{
    //Can not pick earlier then current time date
    NSDate *pickedDate = [NSDate dateWithTimeIntervalSinceReferenceDate:time];
    if ([[NSDate date] timeIntervalSinceReferenceDate] > time) {
        return nil;
    } else {
        return pickedDate;
    }
}

- (void)fillToDoItem {
    NSTimeInterval time = floor([self.datePicker.date timeIntervalSinceReferenceDate] / CountOfSecondsInOneMinute) * CountOfSecondsInOneMinute;
    NSDate *pickedDate = [self isEarlierThenCurrentDate:time];
    if (pickedDate == nil) {
        return;
    }
    self.youngToDoItem = [[IQCoreDataManager instance] createToDoItem];
    [self.youngToDoItem setItemName:self.textField.text];
    self.youngToDoItem.itemIsChecked = [NSNumber numberWithBool:NO];
    self.youngToDoItem.itemPriority = [NSNumber numberWithLong:self.segmentedControl.selectedSegmentIndex];
    self.youngToDoItem.itemDate = pickedDate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.textField setReturnKeyType:UIReturnKeyGo];
    [self.textField setDelegate:self];
    // Do any additional setup after loading the view.
    self.datePicker.date = [NSDate dateWithTimeIntervalSinceNow:CountOfSecondsInOneMinute];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    return YES;
}

@end
