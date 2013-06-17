//
//  WiFi2GoService.m
//  WiFi2Go-ios
//
//  Created by Nicolas Ameghino on 6/4/13.
//  Copyright (c) 2013 Nicolas Ameghino. All rights reserved.
//

#import "WiFi2GoService.h"
#import "Venue.h"

@implementation WiFi2GoService

static NSString *urlString;

+(void)load {
    urlString = @"http://wifi2use.appspot.com/api/1/";
    //urlString = @"http://localhost:8080/";
}

-(id)init {
    self = [super initWithBaseURL:[NSURL URLWithString:@"http://wifi2use.appspot.com/api/1/"]];
    if (self) {
        
    }
    return self;
}


-(void)queryWiFiForLatitude:(double)latitude longitude:(double)longitude completionBlock:(WiFi2GoServiceWiFiQueryComplete)block {
    NSURL *url = [NSURL URLWithString: [[self.baseURL absoluteString] stringByAppendingFormat:@"wifi?ll=%f,%f", latitude, longitude]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"Target URL: %@", [request.URL absoluteString]);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSError *error = nil;
        id r = nil;
        
        if ([JSON[@"error"] boolValue] == YES) {
            error = [NSError errorWithDomain:@"wifi2go.py" code:-1 userInfo:@{NSLocalizedDescriptionKey: JSON[@"error_message"]}];
        } else {
            r = [NSMutableArray array];
            for (NSDictionary* d in JSON[@"response"]) {
                [r addObject:[Venue venueWithDictionary:d]];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{ block(r, error); });
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        dispatch_async(dispatch_get_main_queue(), ^{ block(nil, error); });
    }];
    [operation start];
}


-(void) addNewAccessPointForVenueID:(NSString*) venueId SSID:(NSString*) ssid password:(NSString*) password {
    // http://wifi2use.appspot.com/api/1/addwifi
    //NSURL *url = [NSURL URLWithString:[[self.baseURL absoluteString] stringByAppendingFormat:@"addwifi"]];
    NSURLRequest *request = [self requestWithMethod:@"POST"
                                               path:@"addwifi"
                                         parameters:nil];
    NSLog(@"%@", request.URL.absoluteString);
}

-(void)_nonaf_queryWiFiForLatitude:(double)latitude
                         longitude:(double)longitude
                   completionBlock:(WiFi2GoServiceWiFiQueryComplete)block {
    //NSDictionary *parameters = @{@"latitude": @(latitude), @"longitude": @(longitude)};
    
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:
                              [urlString stringByAppendingFormat:@"?ll=%f,%f", latitude, longitude]]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *urlResponse, NSData *body, NSError *error) {
                               if ([(id)urlResponse statusCode] != 200) {
                                   if (error == nil) {
                                       error = [NSError errorWithDomain:NSURLErrorDomain
                                                                   code:[(id)urlResponse statusCode]
                                                               userInfo:nil];
                                   }
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       block(nil, error);
                                   });
                                   return;
                               }
                               
                               NSString *bodyString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
                               NSLog(@"%@", bodyString);
                               
                               
                               id r = [NSJSONSerialization JSONObjectWithData:body
                                                                      options:0
                                                                        error:&error];
                               if (error != nil) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       block(nil, error);
                                   });
                               }
                               
                               error = nil;
                               if ([r[@"error"] boolValue]) {
                                   error = [NSError errorWithDomain:@"Backend"
                                                               code:-1
                                                           userInfo:@{NSLocalizedDescriptionKey: r[@"error_message"]}];
                               }
                               
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   block(r[@"response"], error);
                               });
                           }];
}

@end
