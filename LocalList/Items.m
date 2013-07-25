//
//  Items.m
//  LocalList
//
//  Created by Karim Jiwani on 2013-07-25.
//  Copyright (c) 2013 Karim Jiwani. All rights reserved.
//

#import "Items.h"


@implementation Items

@dynamic itemName;

- (NSString *)initialLetter {
    return [self.itemName substringFromIndex:1];
}

@end
