//
//  IQAddToDoItemViewController.h
//  IQToDoList
//
//  Created by Yukon on 6/22/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQToDoItem.h"

@interface IQAddToDoItemViewController : UIViewController

@property (assign) BOOL isEditMode;
@property (strong, nonatomic) IQToDoItem *toDoItem;
@property (assign) NSInteger indexItemInArray;
- (IBAction)CloseKeyboard:(UISwipeGestureRecognizer *)sender;

@end
