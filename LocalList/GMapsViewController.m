//
//  GMapsViewController.m
//  LocalList
//
//  Created by Karim Jiwani on 2013-07-27.
//  Copyright (c) 2013 Karim Jiwani. All rights reserved.
//

#import "GMapsViewController.h"
#import "Stores.h"
#import "DirectionService.h"
@interface GMapsViewController ()

@end

@implementation GMapsViewController {
    NSFetchRequest *fetchRequest;
    NSMutableArray *resultArray;
    DirectionService *directionService;
    BOOL routeButtonClicked;
}

@synthesize managedObjectContext = _managedObjectContext;
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
    fetchRequest = [[NSFetchRequest alloc] init];
}

- (void)loadView {
    [super loadView];
    resultArray = [[NSMutableArray alloc] initWithCapacity:0];
    mapView.delegate = self;
    mapView.myLocationEnabled = YES;
    mapView.settings.myLocationButton = YES;
    mapView.settings.compassButton = YES;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)displayStore:(UIButton *)sender {
    [self fetchStores];
}

- (IBAction)displayRoute:(UIButton *)sender {
    routeButtonClicked = YES;
    [self fetchStores];
}

- (IBAction)clearMap:(UIButton *)sender {
    [mapView clear];
}

- (void)fetchStores {
    [resultArray removeAllObjects];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"List" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    fetchRequest.propertiesToFetch = [NSArray arrayWithObject:[[entity propertiesByName] objectForKey:@"storeReference"]];
    fetchRequest.returnsDistinctResults = YES;
    fetchRequest.resultType = NSDictionaryResultType;
    [fetchRequest setPredicate:nil];
    NSArray *distinctresults = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        for ( NSDictionary *result in distinctresults ) {
            NSString *reference = [result objectForKey:@"storeReference"];
            fetchRequest.resultType = NSManagedObjectResultType;
            fetchRequest.propertiesToFetch = nil;
            NSPredicate *referencePredicate = [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:@"storeReference"] rightExpression:[NSExpression expressionForConstantValue:reference] modifier:NSDirectPredicateModifier type:NSContainsPredicateOperatorType options:NSCaseInsensitivePredicateOption|NSDiacriticInsensitivePredicateOption];
            NSPredicate *toBuyItem = [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:@"toBuy"] rightExpression:[NSExpression expressionForConstantValue:[NSNumber numberWithInt:1]] modifier:NSDirectPredicateModifier type:NSEqualToPredicateOperatorType options:0];
            [fetchRequest setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:referencePredicate, toBuyItem, nil]]];
            NSNumber *counter = [NSNumber numberWithInteger:[self.managedObjectContext countForFetchRequest:fetchRequest error:nil]];
            if ( [counter integerValue] > 0 ) {
                NSEntityDescription *storeEntity = [NSEntityDescription entityForName:@"Stores" inManagedObjectContext:self.managedObjectContext];
                NSFetchRequest *storeFetch = [[NSFetchRequest alloc] init];
                [storeFetch setEntity:storeEntity];
                [storeFetch setPredicate:referencePredicate];
                NSArray *storeResult = [self.managedObjectContext executeFetchRequest:storeFetch error:nil];
                Stores *store = [storeResult lastObject];
                NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:store, @"store", counter, @"count", nil];
                [resultArray insertObject:data atIndex:0];
            }
        }
        [self showStoresOnMap];
    });
}

- (void)showStoresOnMap {
    [mapView clear];
    for ( NSDictionary *data in resultArray ) {
        Stores *store = [data objectForKey:@"store"];
        CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake([store.latitude doubleValue], [store.longitude doubleValue]);
        GMSMarker *marker = [GMSMarker markerWithPosition:coordinates];
        marker.title = store.storeName;
        marker.snippet = [NSString stringWithFormat:@"items to buy: %@", [[data objectForKey:@"count"] stringValue]];
        marker.animated = YES;
        marker.map = mapView;
    }
    if ( routeButtonClicked ) {
        [self fetchDirections];
        routeButtonClicked = NO;
    }
}

- (void) fetchDirections {
    NSString *origin = [self coordinatesToString:[mapView myLocation].coordinate];
    NSArray *markers = [mapView markers];
    if ( [markers count] > 0) {
        NSMutableArray *wayPoints = [[NSMutableArray alloc] initWithCapacity:[markers count]];
        if ( directionService == nil ) {
            directionService = [[DirectionService alloc] init];
        }
        for ( GMSMarker *marker in markers ) {
            [wayPoints addObject:[self coordinatesToString:[marker position]]];
        }
        NSDictionary *query = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:origin, wayPoints, @"true", nil] forKeys:[NSArray arrayWithObjects:@"origin", @"waypoints", @"sensor", nil]];
        [directionService setDestinationQuery:query withSelector:@selector(addDirectionOnMap:) withDelegate:self];
    }
}

- (void)addDirectionOnMap:(NSDictionary*)json {
    
    NSString *status = [json objectForKey:@"status"];if ( [status isEqualToString:@"OK"]) {
        NSDictionary *routes = [json objectForKey:@"routes"][0];
        
        NSDictionary *route = [routes objectForKey:@"overview_polyline"];
        //NSDictionary *steps = [routes objectForKey:@"legs"][1];
        //NSArray *step = [steps objectForKey:@"steps"];
        /*for( NSDictionary *data in step ) {
            NSLog(@"distance: %@, duration: %@, Instruction %@", [[data objectForKey:@"distance"] objectForKey:@"text"], [[data objectForKey:@"duration"] objectForKey:@"text"], [[data objectForKey:@"html_instructions"] stripHtml]);
        }*/
        //NSLog(@"%@", steps);
        NSString *overview_route = [route objectForKey:@"points"];
        GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
        GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
        polyline.strokeWidth = 5.0f;
        polyline.map = mapView;
    } else {
        NSLog(@"%@", status);
    }
}

- (NSString *)coordinatesToString:(CLLocationCoordinate2D) coorinate {
    return [NSString stringWithFormat:@"%f,%f", coorinate.latitude, coorinate.longitude];
}
@end
