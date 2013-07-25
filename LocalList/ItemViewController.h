//
//  ItemViewController.h
//  LocalList
//
//  Created by Karim Jiwani on 2013-07-25.
//  Copyright (c) 2013 Karim Jiwani. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Items;
@interface ItemViewController : UITableViewController
- (IBAction)saveButton:(UIBarButtonItem *)sender;
- (IBAction)cancelButton:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITextField *itemTextField;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Items *itemToEdit;
@end
