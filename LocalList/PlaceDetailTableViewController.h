//
//  PlaceDetailTableViewController.h
//  LocalList
//
//  Created by Karim Jiwani on 2013-07-24.
//  Copyright (c) 2013 Karim Jiwani. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Places;
@class PlaceService;
@class Stores;
@interface PlaceDetailTableViewController : UITableViewController

@property (nonatomic, strong) Places *places;
@property (nonatomic, strong) PlaceService *placeService;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Stores *storeDetail;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *pricingLabel;
@property (weak, nonatomic) IBOutlet UILabel *websiteLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addStore;
- (IBAction)addStore:(UIBarButtonItem *)sender;
- (IBAction)cancelButton:(UIBarButtonItem *)sender;


@end
