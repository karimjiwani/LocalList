//
//  Items.h
//  LocalList
//
//  Created by Karim Jiwani on 2013-07-25.
//  Copyright (c) 2013 Karim Jiwani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Items : NSManagedObject

@property (nonatomic, retain) NSString * itemName;
- (NSString *)initialLetter;

@end
