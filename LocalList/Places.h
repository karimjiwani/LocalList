//
//  Places.h
//  LocalList
//
//  Created by Karim Jiwani on 2013-07-24.
//  Copyright (c) 2013 Karim Jiwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Places : NSObject

@property (nonatomic, strong) NSString *placeName;
@property (nonatomic, strong) NSString *placeAddress;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSString *reference;


@end
