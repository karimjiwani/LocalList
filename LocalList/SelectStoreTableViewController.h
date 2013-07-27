//
//  SelectStoreTableViewController.h
//  LocalList
//
//  Created by Karim Jiwani on 2013-07-26.
//  Copyright (c) 2013 Karim Jiwani. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectStoreTableViewController;

@protocol SelectStoreTableViewControllerDelegate

- (void)storeSelect:(SelectStoreTableViewController *)controller withStoreName:(NSString *)storeName withStoreReference:(NSString *)storeReference;

@end

@interface SelectStoreTableViewController : UITableViewController

@property (nonatomic, weak) id <SelectStoreTableViewControllerDelegate> delegate;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
