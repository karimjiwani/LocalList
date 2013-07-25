//
//  Stores.h
//  LocalList
//
//  Created by Karim Jiwani on 2013-07-24.
//  Copyright (c) 2013 Karim Jiwani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Stores : NSManagedObject

@property (nonatomic, retain) NSString * storeName;
@property (nonatomic, retain) NSString * storeAddress;
@property (nonatomic, retain) NSString * storeReference;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * priceLevel;
@property (nonatomic, retain) NSString * storeWebsite;
@property (nonatomic, retain) NSNumber * rating;

@end
