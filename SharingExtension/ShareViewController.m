//
//  ShareViewController.m
//  SharingExtension
//
//  Created by Andrii Struts on 8/1/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "ShareViewController.h"
#import "IQCoreDataManager.h"
#import "IQToDoItemDomain.h"

@interface ShareViewController ()

@property (nonatomic, strong) IQToDoItemDomain *toDoItemDomain;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    NSManagedObjectContext *managedObjectContext = [[IQCoreDataManager instance] managedObjectContext];
    self.toDoItemDomain = [[IQToDoItemDomain alloc] initWithManagedObjectContext:managedObjectContext];
}

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

- (void)didSelectPost {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    ToDoItemMO *toDoItem = [[IQCoreDataManager instance] createToDoItem];
    [toDoItem setItemName:self.textView.text];
    toDoItem.itemIsChecked = [NSNumber numberWithBool:NO];
    toDoItem.itemPriority = [NSNumber numberWithLong:0];
    toDoItem.itemDate = [NSDate date];
    [self.toDoItemDomain saveCreatedToDoItem:toDoItem];
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}

@end
