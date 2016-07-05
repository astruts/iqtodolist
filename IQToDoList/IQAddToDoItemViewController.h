//
//  IQAddToDoItemViewController.h
//  IQToDoList
//
//  Created by Yukon on 6/22/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoItemMO.h"

@interface IQAddToDoItemViewController : UIViewController<UITextFieldDelegate>

@property (assign) BOOL isEditMode;
@property (strong, nonatomic) ToDoItemMO *youngToDoItem;
@property (strong, nonatomic) ToDoItemMO *currentToDoItem;

- (IBAction)CloseKeyboard:(UISwipeGestureRecognizer *)sender;
- (IBAction)CloseKeyboardUp:(UISwipeGestureRecognizer *)sender;

- (NSDate *)isEarlierThenCurrentDate:(NSTimeInterval)time;

@end
