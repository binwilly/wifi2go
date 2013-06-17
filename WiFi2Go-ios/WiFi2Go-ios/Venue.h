//
//  Venue.h
//  WiFi2Go-ios
//
//  Created by Nicolas Ameghino on 6/6/13.
//  Copyright (c) 2013 Nicolas Ameghino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Venue : NSObject

-(id) initWithDictionary:(NSDictionary*) dictionary;
+(id) venueWithDictionary:(NSDictionary*) dictionary;

-(id)objectForKeyedSubscript: (id)key;


-(BOOL) hasWifi;
-(NSString *)name;
-(NSString *)mainCategory;
-(NSArray *)allCategories;
-(NSString *) ssid;
-(NSString *) password;

@end
