//
//  ListItemDetailTableViewController.m
//  LocalList
//
//  Created by Karim Jiwani on 2013-07-26.
//  Copyright (c) 2013 Karim Jiwani. All rights reserved.
//

#import "ListItemDetailTableViewController.h"
#import "List.h"
@interface ListItemDetailTableViewController ()

@end

@implementation ListItemDetailTableViewController {
    NSString *storeRef;
}

@synthesize itemNameLabel = _itemNameLabel, storeNameLabel = _storeNameLabel, quantityTextField = _quantityTextField, priceTextField = _priceTextField, toBuySwitch = _toBuySwitch, saveButton = _saveButton, managedObjectContext = _managedObjectContext, listItemToEdit = _listItemToEdit;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.quantityTextField.delegate = self;
    self.priceTextField.delegate = self;
    if ( self.listItemToEdit != nil ) {
        [self loadData];
    }
    [self checkSaveButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSString *decimalSymbol = [formatter decimalSeparator];
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *expression = [NSString stringWithFormat:@"^([0-9]+)?(\\%@([0-9]{1,2})?)?$", decimalSymbol];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString options:0 range:NSMakeRange(0,[newString length])];
    if (numberOfMatches == 0) {
        return NO;
    }
    return YES;
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ( [segue.identifier isEqualToString:@"SelectItemSegue"] ) {
        SelectItemTableViewController *selectItemTableViewController = (SelectItemTableViewController *)segue.destinationViewController;
        selectItemTableViewController.delegate = self;
        selectItemTableViewController.managedObjectContext = self.managedObjectContext;
        
    } else if ( [segue.identifier isEqualToString:@"SelectStoreSegue"] ) {
        SelectStoreTableViewController *selectStoreTableViewController = (SelectStoreTableViewController *) segue.destinationViewController;
        selectStoreTableViewController.delegate = self;
        selectStoreTableViewController.managedObjectContext = self.managedObjectContext;
        
    }
}

- (void)checkSaveButton {
    if ( [self.itemNameLabel.text isEqualToString:@""] || [self.storeNameLabel.text isEqualToString:@""] ) {
        self.saveButton.enabled = NO;
    } else {
        self.saveButton.enabled = YES;
    }
}

- (void) closeScreen {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveItemInList:(UIBarButtonItem *)sender {
    List *listItem;
    if ( self.listItemToEdit != nil ) {
        listItem = self.listItemToEdit;
    } else {
        listItem = [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:self.managedObjectContext];
    }
    listItem.itemName = self.itemNameLabel.text;
    listItem.storeName = self.storeNameLabel.text;
    listItem.storeReference = storeRef;
    listItem.price = [NSDecimalNumber decimalNumberWithString:self.priceTextField.text];
    listItem.quantity = [NSDecimalNumber decimalNumberWithString:self.quantityTextField.text];
    listItem.toBuy = [NSNumber numberWithBool:[self.toBuySwitch isOn]];
    [self.managedObjectContext save:nil];
    [self closeScreen];
}

- (IBAction)cancelButton:(UIBarButtonItem *)sender {
    [self closeScreen];
}

- (void) loadData {
    self.itemNameLabel.text = self.listItemToEdit.itemName;
    self.storeNameLabel.text = self.listItemToEdit.storeName;
    self.priceTextField.text = [self.listItemToEdit.price stringValue];
    self.quantityTextField.text = [self.listItemToEdit.quantity stringValue];
    self.toBuySwitch.on = [self.listItemToEdit.toBuy boolValue];
    storeRef = self.listItemToEdit.storeReference;
}

- (void) itemSelect:(SelectItemTableViewController *)controller itemName:(NSString *)name {
    self.itemNameLabel.text = name;
    [self.navigationController popViewControllerAnimated:YES];
    [self checkSaveButton];
}

- (void) storeSelect:(SelectStoreTableViewController *)controller withStoreName:(NSString *)storeName withStoreReference:(NSString *)storeReference {
    self.storeNameLabel.text = storeName;
    storeRef = storeReference;
    [self.navigationController popViewControllerAnimated:YES];
    [self checkSaveButton];
}
@end
