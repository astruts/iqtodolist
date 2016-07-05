//
//  IQToDoListTests.m
//  IQToDoListTests
//
//  Created by Yukon on 7/5/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IQAddToDoItemViewController.h"

@interface IQToDoListTests : XCTestCase

@end

@implementation IQToDoListTests

IQAddToDoItemViewController *addToDoItemViewController;
NSTimeInterval timeInterval;
NSDate *returnedDate;

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    addToDoItemViewController = [[IQAddToDoItemViewController alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testIsNilWhenTimeIntervalIsEqualCurrentDate{
    timeInterval = [[NSDate date] timeIntervalSinceReferenceDate];
    returnedDate = [addToDoItemViewController isEarlierThenCurrentDate:timeInterval];
    XCTAssertNil(returnedDate, @"pointer:%p", returnedDate);
}

- (void)testIsNotNilWhenTimeIntervalBiggerThenCurrentDate{
    timeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + 1;
    returnedDate = [addToDoItemViewController isEarlierThenCurrentDate:timeInterval];
    XCTAssertNotNil(returnedDate);
}

- (void)testIsNotNilWhenTimeIntervalLessThenCurrentDate{
    timeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - 1;
    returnedDate = [addToDoItemViewController isEarlierThenCurrentDate:timeInterval];
    XCTAssertNil(returnedDate, @"pointer:%p", returnedDate);
}

- (void)testIsEqualReturnedDateCalculatedWhenTimeIntervalBiggerThenCurrentDate {
    timeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + 1;
    returnedDate = [addToDoItemViewController isEarlierThenCurrentDate:timeInterval];
    NSDate *calculatedDate = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
    XCTAssertEqualObjects(returnedDate, calculatedDate, @"obj1(%@) not equal to obj2(%@))", returnedDate, calculatedDate);
}

@end
