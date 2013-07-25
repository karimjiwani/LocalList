//
//  PlaceDetailTableViewController.m
//  LocalList
//
//  Created by Karim Jiwani on 2013-07-24.
//  Copyright (c) 2013 Karim Jiwani. All rights reserved.
//

#import "PlaceDetailTableViewController.h"
#import "Places.h"
#import "Stores.h"
#import "PlaceService.h"

@interface PlaceDetailTableViewController ()

@end

@implementation PlaceDetailTableViewController {
    NSDictionary *results;
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize places = _places;
@synthesize placeService = _placeService;
@synthesize addStore = _addStore, storeDetail = _storeDetail;
@synthesize nameLabel = _nameLabel, addressLabel = _addressLabel, phoneLabel = _phoneLabel, ratingLabel = _ratingLabel, pricingLabel = _pricingLabel, websiteLabel = _websiteLabel;


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
    if ( self.storeDetail == nil ) {
        [self fetchDetails];
    } else {
        self.addStore.enabled = NO;
        [self loadDetails];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
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

- (void)fetchDetails {
    self.nameLabel.text = self.places.placeName;
    [self.placeService setPlaceDetailQuery:self.places.reference withSelector:@selector(detailPlaceResult:) withDelegate:self];
}

- (void) detailPlaceResult:(NSDictionary *)json {
    if ( [[json objectForKey:@"status"] isEqualToString:@"OK"] ) {
        results = [json objectForKey:@"result"];
        self.addressLabel.text = [results objectForKey:@"formatted_address"];
        self.phoneLabel.text = [results objectForKey:@"international_phone_number"];
        NSNumber *pricing = [results objectForKey:@"price_level"];
        self.pricingLabel.text = [pricing stringValue];
        NSNumber *rating = [results objectForKey:@"rating"];
        self.ratingLabel.text = [rating stringValue];
        self.websiteLabel.text = [results objectForKey:@"website"];
        
    } else {
        NSLog(@"Some Error in fetching details");
    }
}


- (IBAction)addStore:(UIBarButtonItem *)sender {
    if ( [self saveStore ] ) {
        [self closeViewController];
    }

}

- (IBAction)cancelButton:(UIBarButtonItem *)sender {
    [self closeViewController];
}

- (void) closeViewController {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];

}

- (BOOL)saveStore {
    if ( [self alreadyPresentStore] ) {
        NSLog(@"Store Already Present");
        return YES;
    }
    Stores *store = [NSEntityDescription insertNewObjectForEntityForName:@"Stores" inManagedObjectContext:self.managedObjectContext];
    store.storeName = self.places.placeName;
    store.storeAddress = [results objectForKey:@"formatted_address"];
    store.storeReference = self.places.reference;
    store.latitude = self.places.latitude;
    store.longitude = self.places.longitude;
    store.phoneNumber = [results objectForKey:@"international_phone_number"];
    store.priceLevel = [[results objectForKey:@"price_level"] stringValue];
    store.rating = [results objectForKey:@"rating"];
    store.storeWebsite = [results objectForKey:@"website"];
    NSError *error;
    if ( ![self.managedObjectContext save:&error] ) {
        return NO;
    }
    return YES;
}

- (BOOL) alreadyPresentStore {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Stores" inManagedObjectContext:self.managedObjectContext]];
    NSExpression *expressionSNLeft = [NSExpression expressionForKeyPath:@"storeName"];
    NSExpression *expressionSNRight = [NSExpression expressionForConstantValue:self.places.placeName];
    NSPredicate *predicateName = [NSComparisonPredicate predicateWithLeftExpression:expressionSNLeft rightExpression:expressionSNRight modifier:NSDirectPredicateModifier type:NSContainsPredicateOperatorType options:NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch];
    NSExpression *expressionSALeft = [NSExpression expressionForKeyPath:@"storeAddress"];
    NSExpression *expressionSARight = [NSExpression expressionForConstantValue:[results objectForKey:@"formatted_address"]];
    NSPredicate *predicateAddress = [NSComparisonPredicate predicateWithLeftExpression:expressionSALeft rightExpression:expressionSARight modifier:NSDirectPredicateModifier type:NSContainsPredicateOperatorType options:NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:predicateName, predicateAddress, nil]];
    [fetchRequest setPredicate:predicate];
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    if( [result count] > 0 ) {
        return YES;
    } else {
        return NO;
    }
}

- (void) loadDetails {
    self.nameLabel.text = self.storeDetail.storeName;
    self.addressLabel.text = self.storeDetail.storeAddress;
    self.phoneLabel.text = self.storeDetail.phoneNumber;
    self.ratingLabel.text = [self.storeDetail.rating stringValue];
    self.pricingLabel.text = self.storeDetail.priceLevel;
    self.websiteLabel.text = self.storeDetail.storeWebsite;
}
@end
