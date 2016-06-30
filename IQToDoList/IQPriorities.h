//
//  IQPriorities.h
//  IQToDoList
//
//  Created by Admin on 6/29/16.
//  Copyright (c) 2016 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IQPriorities : NSObject

typedef enum {
    Low,
    Average,
    High
} kPriority;

@property (readonly, retain) NSArray *priorities;

+(instancetype) instance;

@end
