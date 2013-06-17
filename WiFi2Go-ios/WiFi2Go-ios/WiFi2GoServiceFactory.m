//
//  WiFi2GoServiceFactory.m
//  WiFi2Go-ios
//
//  Created by Nicolas Ameghino on 6/7/13.
//  Copyright (c) 2013 Nicolas Ameghino. All rights reserved.
//

#import "WiFi2GoServiceFactory.h"

#import "WiFi2GoService.h"
#import "MockWiFi2GoService.h"

static id<WiFi2GoServiceProtocol> serviceInstance;

@implementation WiFi2GoServiceFactory

+(id<WiFi2GoServiceProtocol>) getService {
    if (!serviceInstance) {
        serviceInstance = [WiFi2GoService new];
    }
    return serviceInstance;
}

@end
