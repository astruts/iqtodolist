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
        
        _colors = @[@"0xC2F7B1",
                    @"0xF7F796",
                    @"0xF6A3A3",];
    }
    return self;
}

@end
