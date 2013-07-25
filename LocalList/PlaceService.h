//
//  PlaceService.h
//  LocalList
//
//  Created by Karim Jiwani on 2013-07-24.
//  Copyright (c) 2013 Karim Jiwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceService : NSObject
- (void)setPlaceQuery:(NSDictionary *)options withSelector:(SEL)selector withDelegate:(id)delegate;
- (void)setPlaceDetailQuery:(NSString *)referenceString withSelector:(SEL)selector withDelegate:(id)delegate;
- (void)retereivePlaces:(SEL)selector withDelegate:(id)delegate;
- (void)fetchData:(NSData *)data withSelector:(SEL)selector withDelegate:(id)delegate;
@end
