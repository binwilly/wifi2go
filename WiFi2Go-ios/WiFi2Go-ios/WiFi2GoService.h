//
//  WiFi2GoService.h
//  WiFi2Go-ios
//
//  Created by Nicolas Ameghino on 6/4/13.
//  Copyright (c) 2013 Nicolas Ameghino. All rights reserved.
//

#import "WiFi2GoServiceProtocol.h"

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>


@interface WiFi2GoService : AFHTTPClient <WiFi2GoServiceProtocol>

-(void) queryWiFiForLatitude:(double)latitude
                   longitude:(double)longitude
             completionBlock:(WiFi2GoServiceWiFiQueryComplete) block;

-(void) addNewAccessPointForVenueID:(NSString*) venueId SSID:(NSString*) ssid password:(NSString*) password;

@end
