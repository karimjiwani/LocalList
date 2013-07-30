//
//  PlaceSearchTableViewController.h
//  LocalList
//
//  Created by Karim Jiwani on 2013-07-24.
//  Copyright (c) 2013 Karim Jiwani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceSearchTableViewController : UITableViewController <UISearchBarDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *placeSearchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

