//
//  IQPriorities.m
//  IQToDoList
//
//  Created by Admin on 6/29/16.
//  Copyright (c) 2016 Admin. All rights reserved.
//

#import "IQPriorities.h"

@implementation IQPriorities

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
        _priorities = @[@"Low priority ",
                        @"Average priority ",
                        @"High priority ",];
    }
    return self;
}

@end
