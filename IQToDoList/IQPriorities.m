//
//  IQPriorities.m
//  IQToDoList
//
//  Created by Admin on 6/29/16.
//  Copyright (c) 2016 Admin. All rights reserved.
//

#import "IQPriorities.h"

@implementation IQPriorities

static NSString *const lowPriority = @"Low priority ";
static NSString *const averagePriority = @"Average priority ";
static NSString *const highPriority = @"High priority ";

+ (instancetype)instance {
    static IQPriorities *instance = nil;
    @synchronized(self) {
        if (instance == nil)
            instance = [[self alloc] init];
    }
    return instance;
}

- (id)init {
    if (self = [super init]) {
        _priorities = @[lowPriority,
                        averagePriority,
                        highPriority,];
        _colors = @[[UIColor colorWithRed:194.0/255.0 green: 247.0/255.0 blue: 177.0/255.0 alpha: 1.0],
                    [UIColor colorWithRed:247.0/255.0 green: 247.0/255.0 blue: 150.0/255.0 alpha: 1.0],
                    [UIColor colorWithRed:246.0/255.0 green: 163.0/255.0 blue: 163.0/255.0 alpha: 1.0],];
    }
    return self;
}

@end
