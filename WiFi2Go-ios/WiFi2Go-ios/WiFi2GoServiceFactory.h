//
//  WiFi2GoServiceFactory.h
//  WiFi2Go-ios
//
//  Created by Nicolas Ameghino on 6/7/13.
//  Copyright (c) 2013 Nicolas Ameghino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WiFi2GoServiceProtocol.h"

@interface WiFi2GoServiceFactory : NSObject

+(id<WiFi2GoServiceProtocol>) getService;

@end
