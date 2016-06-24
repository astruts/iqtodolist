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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) NSString *textBeforeEdit;

@end

@implementation IQAddToDoItemViewController

@synthesize toDoItem;

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *titleOfViewController = @"Add To-Do Item";
    if (self.title == titleOfViewController) {
        if (sender != self.doneButton) return;
        if (self.textField.text.length > 0) {
            self.toDoItem = [[IQToDoItem alloc] init];
            self.toDoItem.itemName = self.textField.text;
            self.toDoItem.completed = NO;
        }
    }
    titleOfViewController = @"Edit To-Do Item";
    if (self.title == titleOfViewController) {
        if (sender != self.doneButton) return;
        if (self.textField.text.length > 0) {
            if (![self.textBeforeEdit isEqualToString: self.textField.text]) {
                self.toDoItem.itemName = self.textField.text;
                self.toDoItem.completed = NO;
            }
        }
        else {
            self.toDoItem = nil;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (toDoItem.itemName == nil) return;
    self.textField.text = toDoItem.itemName;
    self.textBeforeEdit = toDoItem.itemName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
