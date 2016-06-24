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
    if (sender != self.doneButton)
    {
        return;
    }
    
    if (self.isEditMode) {
        if (![self.textBeforeEdit isEqualToString: self.textField.text]) {
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
    } else {
        self.toDoItem = nil;
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

@end
