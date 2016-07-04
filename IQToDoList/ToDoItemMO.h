//
//  ToDoItemMO.h
//  IQToDoList
//
//  Created by Admin on 7/1/16.
//  Copyright (c) 2016 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ToDoItemMO : NSManagedObject

@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, retain) NSNumber * itemPriority;
@property (nonatomic, retain) NSNumber * itemIsChecked;
@property (nonatomic, retain) NSDate * itemDate;

@end
