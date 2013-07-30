//
//  DirectionService.h
//  LocalList
//
//  Created by Karim Jiwani on 2013-07-29.
//  Copyright (c) 2013 Karim Jiwani. All rights reserved.
//

#import "PlaceService.h"

@interface DirectionService : PlaceService
- (void)setDestinationQuery:(NSDictionary *)options withSelector:(SEL)selector withDelegate:(id)delegate;
@end
