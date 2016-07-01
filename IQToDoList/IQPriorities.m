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

+ (instancetype)instance
{
    static IQPriorities *instance = nil;
    @synchronized(self) {
        if (instance == nil)
            instance = [[self alloc] init];
    }
    return instance;
}

- (id)init
{
    if (self = [super init]) {
        _priorities = @[lowPriority,
                        averagePriority,
                        highPriority,];
    }
    return self;
}

@end
