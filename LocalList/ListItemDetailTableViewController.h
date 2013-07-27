//
//  ListItemDetailTableViewController.h
//  LocalList
//
//  Created by Karim Jiwani on 2013-07-26.
//  Copyright (c) 2013 Karim Jiwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectItemTableViewController.h"
#import "SelectStoreTableViewController.h"
@class List;

@interface ListItemDetailTableViewController : UITableViewController <UITextFieldDelegate, SelectItemTableVViewControllerDelegate, SelectStoreTableViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UISwitch *toBuySwitch;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
- (IBAction)saveItemInList:(UIBarButtonItem *)sender;
- (IBAction)cancelButton:(UIBarButtonItem *)sender;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) List *listItemToEdit;

@end
