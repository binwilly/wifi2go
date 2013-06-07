//
//  WiFi2GoServiceProtocol.h
//  WiFi2Go-ios
//
//  Created by Nicolas Ameghino on 6/7/13.
//  Copyright (c) 2013 Nicolas Ameghino. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WiFi2GoServiceWiFiQueryComplete)(NSArray *results, NSError *error);

@protocol WiFi2GoServiceProtocol <NSObject>

@required
-(void) queryWiFiForLatitude:(double)latitude
                   longitude:(double)longitude
             completionBlock:(WiFi2GoServiceWiFiQueryComplete) block;


@end
