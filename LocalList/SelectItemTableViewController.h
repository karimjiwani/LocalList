//
//  SelectItemTableViewController.h
//  LocalList
//
//  Created by Karim Jiwani on 2013-07-26.
//  Copyright (c) 2013 Karim Jiwani. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectItemTableViewController;
@protocol SelectItemTableVViewControllerDelegate

- (void)itemSelect:(SelectItemTableViewController *)controller itemName:(NSString *)name;

@end

@interface SelectItemTableViewController : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) id <SelectItemTableVViewControllerDelegate> delegate;

@end
