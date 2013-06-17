//
//  MockWiFi2GoService.m
//  WiFi2Go-ios
//
//  Created by Nicolas Ameghino on 6/7/13.
//  Copyright (c) 2013 Nicolas Ameghino. All rights reserved.
//

#import "MockWiFi2GoService.h"
#import "Venue.h"

@implementation MockWiFi2GoService

NSUInteger getrnd(int limit) {
    return arc4random() % limit;
}

float getfrnd() {
    return rand() / (float) RAND_MAX;
}

-(void)queryWiFiForLatitude:(double)latitude longitude:(double)longitude completionBlock:(WiFi2GoServiceWiFiQueryComplete)block {
    NSUInteger limit = 50;
    NSUInteger size = getrnd(limit);
    NSMutableArray *r = [NSMutableArray arrayWithCapacity:size];
    
    for (int i=0; i < size; ++i) {
        NSDictionary *d =
        @{
          @"venue_id": [NSString stringWithFormat:@"random venue #%d", getrnd(1000)],
          @"ssid": [NSString stringWithFormat:@"random wifi ssid #%d", getrnd(1000)],
          @"password": getfrnd() < 0.4 ? [NSNull null] : @"hackme"
        };
        [r addObject:[Venue venueWithDictionary:d]];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        sleep(1);
        block(r, nil);
    });
}

-(void)addNewAccessPointForVenueID:(NSString *)venueId SSID:(NSString *)ssid password:(NSString *)password {
    
}

@end
