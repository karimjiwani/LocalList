//
//  ItemViewController.m
//  LocalList
//
//  Created by Karim Jiwani on 2013-07-25.
//  Copyright (c) 2013 Karim Jiwani. All rights reserved.
//

#import "ItemViewController.h"
#import "Items.h"
@interface ItemViewController ()

@end

@implementation ItemViewController

@synthesize managedObjectContext = _managedObjectContext, itemTextField = _itemTextField, itemToEdit = _itemToEdit;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if ( self.itemToEdit == nil ) {
        [self.itemTextField becomeFirstResponder];
    } else {
        self.itemTextField.text = self.itemToEdit.itemName;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButton:(UIBarButtonItem *)sender {
    Items *item;
    if ( self.itemToEdit == nil ) {
        item = [NSEntityDescription insertNewObjectForEntityForName:@"Items" inManagedObjectContext:self.managedObjectContext];
    } else {
        item = self.itemToEdit;
    }
    item.itemName = self.itemTextField.text;
    [self.managedObjectContext save:nil];
    [self closeViewController];
}

- (IBAction)cancelButton:(UIBarButtonItem *)sender {
    [self closeViewController];
}

- (void) closeViewController {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
