//
//  ItemsTableViewController.m
//  LocalList
//
//  Created by Karim Jiwani on 2013-07-25.
//  Copyright (c) 2013 Karim Jiwani. All rights reserved.
//

#import "ItemsTableViewController.h"
#import "ItemViewController.h"
#import "Items.h"
@interface ItemsTableViewController ()

@end

@implementation ItemsTableViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedResultController;

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
    [self performFetch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    fetchedResultController.delegate = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultController sections] count];
}

/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ( tableView == self.searchDisplayController.searchResultsTableView ) {
     return @"Search Result";
     }
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultController sections] objectAtIndex:section];
    return [sectionInfo name];
    //return [[self.fetchResultController sectionIndexTitles] objectAtIndex:section];
}*/


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( editingStyle == UITableViewCellEditingStyleDelete ) {
        Items *item = [self.fetchedResultController objectAtIndexPath:indexPath];
        [self.managedObjectContext deleteObject:item];
        NSError *error;
        if ( ![self.managedObjectContext save:&error] ) {
            NSLog(@"Error Deleting cell: %@", error);
            return;
        }
    }}


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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
    ItemViewController *destinationController = (ItemViewController *)navigationController.topViewController;
    if ( [segue.identifier isEqualToString:@"AddItem"] ) {
        destinationController.managedObjectContext = self.managedObjectContext;
    } else if ( [segue.identifier isEqualToString:@"EditItem"] ) {
        destinationController.managedObjectContext = self.managedObjectContext;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Items *item = [self.fetchedResultController objectAtIndexPath:indexPath];
        destinationController.itemToEdit = item;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
       *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    //[self performSegueWithIdentifier:@"EditItem" sender:indexPath];
}


- (NSFetchedResultsController *)fetchedResultController {
    if ( fetchedResultController == nil ) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Items" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"itemName" ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        [fetchRequest setFetchBatchSize:20];
        fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Items"];
        fetchedResultController.delegate = self;
    }
    
    return fetchedResultController;
}

- (void) performFetch {
    NSError *error;
    if ( ![self.fetchedResultController performFetch:&error]) {
        NSLog(@"Error Fetching: %@", error);
        return;
    }
}


- (void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Items *item = [fetchedResultController objectAtIndexPath:indexPath];
    cell.textLabel.text = item.itemName;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        default:
            break;
    }
}

- (void) controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}


@end
