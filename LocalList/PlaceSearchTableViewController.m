//
//  PlaceSearchTableViewController.m
//  LocalList
//
//  Created by Karim Jiwani on 2013-07-24.
//  Copyright (c) 2013 Karim Jiwani. All rights reserved.
//

#import "PlaceSearchTableViewController.h"
#import "PlaceService.h"
#import "Places.h"
#import "PlaceDetailTableViewController.h"

@interface PlaceSearchTableViewController ()

@end

@implementation PlaceSearchTableViewController {
    NSMutableArray *resultArray;
    PlaceService *placeService;
    NSMutableArray *keyArray;
    NSMutableArray *dataArray;
}
@synthesize placeSearchBar = _placeSearchBar;
@synthesize tableView = _tableView;

static NSString *kLocation = @"location";
static NSString *kRadius = @"radius";
static NSString *kRankBy = @"rankby";
static NSString *kSensor = @"sensor";
static NSString *kName = @"name";
static NSString *kType = @"type";



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
    self.placeSearchBar.delegate = self;
    self.tableView.delegate = self;
    resultArray = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Total Results: %d", [resultArray count]];
}


/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [resultArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchStoreCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Places *place = [resultArray objectAtIndex:indexPath.row];
    cell.textLabel.text = place.placeName;
    cell.detailTextLabel.text = place.placeAddress;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ( [segue.identifier isEqualToString:@"PlaceDetailSegue"] ) {
        NSIndexPath *indexPlath = [self.tableView indexPathForCell:sender];
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        PlaceDetailTableViewController *destinationController = (PlaceDetailTableViewController *)navigationController.topViewController;
        destinationController.placeService = placeService;
        destinationController.places = [resultArray objectAtIndex:indexPlath.row];
        destinationController.managedObjectContext = self.managedObjectContext;
    }
}

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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    //resultArray = [[NSArray alloc] initWithObjects:searchBar.text, searchBar.text, searchBar.text, nil];
    [resultArray removeAllObjects];
    [self generateQueryWithText:searchBar.text withNextPageToken:nil];
    
    //[self.tableView reloadData];
}

- (void) generateQueryWithText:(NSString *)query withNextPageToken:(NSString *)nextPageToken {
    NSString *location = @"43.472847,-80.562613";
    if ( nextPageToken == nil ) {
        [dataArray removeAllObjects];
        [keyArray removeAllObjects];
        keyArray = [[NSMutableArray alloc] initWithObjects:kLocation, kRankBy, kSensor, kName, kType, nil];
        dataArray = [[NSMutableArray alloc] initWithObjects:location, @"distance", @"false", query, @"grocery_or_supermarket", nil];
    } else {
        [keyArray addObject:@"pagetoken"];
        [dataArray addObject:nextPageToken];
    }
    NSDictionary *queryData = [[NSDictionary alloc] initWithObjects:dataArray forKeys:keyArray];
    if ( placeService == nil ) {
        placeService = [[PlaceService alloc] init];
    }
    [placeService setPlaceQuery:queryData withSelector:@selector(displayQueryResults:) withDelegate:self];
}

- (void) forNextPage:(NSString *)nextPageToken {
    [self generateQueryWithText:nil withNextPageToken:nextPageToken];
}

- (void) displayQueryResults:(NSDictionary *)json {
    NSString *nextPageToken = nil;
    if ( [[json objectForKey:@"status"] isEqualToString:@"OK"] ) {
        nextPageToken = [json objectForKey:@"next_page_token"];
        NSArray *results = [json objectForKey:@"results"];
        for ( NSDictionary *result in results ) {
            Places *place = [[Places alloc] init];
            place.placeName = [result objectForKey:@"name"];
            place.placeAddress = [result objectForKey:@"vicinity"];
            place.latitude = [[[result objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"];
            place.longitude = [[[result objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"];
            place.reference = [result objectForKey:@"reference"];
            [resultArray addObject:place];

        }
    } else {
        NSLog(@"error getting data: %@", [json objectForKey:@"status"]);
    }
    [self.tableView reloadData];
    if ( nextPageToken != nil && [resultArray count] < 100 ) {
        [self performSelector:@selector(forNextPage:) withObject:nextPageToken afterDelay:1.5];
    }
}


@end
