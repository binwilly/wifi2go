//
//  Venue.m
//  WiFi2Go-ios
//
//  Created by Nicolas Ameghino on 6/6/13.
//  Copyright (c) 2013 Nicolas Ameghino. All rights reserved.
//

#import "Venue.h"

@interface Venue ()
@property(nonatomic, strong) NSDictionary *data;
@end


@implementation Venue

-(id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.data = dictionary;
    }
    return self;
}

+(id)venueWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

-(id)objectForKeyedSubscript: (id)key {
    if (self.data[key] == nil) {
        return self.data[@"foursquare"][key];
    }
    return self.data[key];
}

-(BOOL)hasWifi {
    return self[@"password"] != [NSNull null] && [self[@"password"] length] != 0;
}

-(NSString *)name {
    return self[@"foursquare"][@"name"];
}

-(NSString *)mainCategory {
    NSArray *categories = self[@"foursquare"][@"categories"];
    if ([categories count] > 0) {
        return categories[0][@"shortName"];
    }
    return nil;
}

-(NSArray *)allCategories {
    return [self[@"foursquare"][@"categories"] map:^id(id obj) {
        return obj[@"shortName"];
    }];
}

@end
