//
//  IQAppDelegate.h
//  IQToDoList
//
//  Created by Admin on 6/22/16.
//  Copyright (c) 2016 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQCoreDataManager.h"

@interface IQAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IQCoreDataManager *coreDataManager;

@end
