//
//  GMapsViewController.h
//  LocalList
//
//  Created by Karim Jiwani on 2013-07-27.
//  Copyright (c) 2013 Karim Jiwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface GMapsViewController : UIViewController <GMSMapViewDelegate>  {
    
    __weak IBOutlet GMSMapView *mapView;
}

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
- (IBAction)displayStore:(UIButton *)sender;
- (IBAction)displayRoute:(UIButton *)sender;
- (IBAction)clearMap:(UIButton *)sender;

@end
