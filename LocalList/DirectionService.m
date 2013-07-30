//
//  DirectionService.m
//  LocalList
//
//  Created by Karim Jiwani on 2013-07-29.
//  Copyright (c) 2013 Karim Jiwani. All rights reserved.
//

#import "DirectionService.h"

@implementation DirectionService {
    NSURL *directionURL;
}

static NSString *kDirectionsURL = @"http://maps.googleapis.com/maps/api/directions/json?";

- (void)setDestinationQuery:(NSDictionary *)options withSelector:(SEL)selector withDelegate:(id)delegate {
    NSString *url = [NSString stringWithString:kDirectionsURL];
    NSArray *waypoints = [options objectForKey:@"waypoints"];
    url = [url stringByAppendingFormat:@"&origin=%@&destination=%@&sensor=%@", [options objectForKey:@"origin"], [waypoints lastObject], [options objectForKey:@"sensor"]];
    if ( [waypoints count] > 1 ) {
        url = [url stringByAppendingString:@"&waypoints=optimize:true"];
        for ( int i = 0; i < [waypoints count] - 1; i++ ) {
            url = [url stringByAppendingFormat:@"|%@", [waypoints objectAtIndex:i]];
        }
    }
    url = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    placesURL = [NSURL URLWithString:url];
    NSLog(@"%@", placesURL);
    [self retereivePlaces:selector withDelegate:delegate];
}


@end
