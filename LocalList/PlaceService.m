//
//  PlaceService.m
//  LocalList
//
//  Created by Karim Jiwani on 2013-07-24.
//  Copyright (c) 2013 Karim Jiwani. All rights reserved.
//

#import "PlaceService.h"


@implementation PlaceService {
    
}

static NSString *kPlaceKey = @"key=AIzaSyA7840APP8ruMRWXGc5F3nEzs0qcFL2Fhc";
static NSString *placeUrl = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?";
static NSString *detailUrl = @"https://maps.googleapis.com/maps/api/place/details/json?";


- (void) setPlaceQuery:(NSDictionary *)options withSelector:(SEL)selector withDelegate:(id)delegate {
    
    NSArray *keys = [options allKeys];
    NSString *url = [NSString stringWithString:placeUrl];
    for ( NSString *key in keys ) {
        url = [url stringByAppendingFormat:@"%@=%@&", key, [options objectForKey:key]];
    }
    url = [url stringByAppendingString:kPlaceKey];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    placesURL = [NSURL URLWithString:url];
    [self retereivePlaces:selector withDelegate:delegate];
    
}


- (void) setPlaceDetailQuery:(NSString *)referenceString withSelector:(SEL)selector withDelegate:(id)delegate {
    NSString *url = [NSString stringWithString:detailUrl];
    url = [url stringByAppendingFormat:@"sensor=false&reference=%@&%@", referenceString, kPlaceKey];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    placesURL = [NSURL URLWithString:url];
    [self retereivePlaces:selector withDelegate:delegate];
    
}

- (void) retereivePlaces:(SEL)selector withDelegate:(id)delegate {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *data = [NSData dataWithContentsOfURL:placesURL];
        [self fetchData:data withSelector:selector withDelegate:delegate];
    });
    
}

- (void) fetchData:(NSData *)data withSelector:(SEL)selector withDelegate:(id)delegate {
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    [delegate performSelector:selector withObject:json];
}
@end