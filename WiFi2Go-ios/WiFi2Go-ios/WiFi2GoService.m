//
//  WiFi2GoService.m
//  WiFi2Go-ios
//
//  Created by Nicolas Ameghino on 6/4/13.
//  Copyright (c) 2013 Nicolas Ameghino. All rights reserved.
//

#import "WiFi2GoService.h"
#import "Venue.h"

@interface NSURLRequest (Debug)
- (NSString*) logDebugData;
@end


@implementation NSURLRequest (Debug)
- (NSString*) logDebugData {
    NSMutableString *s = [NSMutableString string];
	[s appendFormat:@"Method: %@\n", self.HTTPMethod];
    [s appendFormat:@"Headers: %@\n", [self allHTTPHeaderFields]];
	[s appendFormat:@"URL: %@\n", self.URL.absoluteString];
	[s appendFormat:@"Body: %@\n", [[NSString alloc] initWithData:self.HTTPBody encoding:NSUTF8StringEncoding]];
    return s;
}

@end

@interface WiFi2GoService ()
@property(atomic, assign) BOOL serviceIsBusy;
@end

@implementation WiFi2GoService

static NSString *urlString;

+(void)load {
    urlString = @"wifi2use.appspot.com";
    //urlString = @"localhost:9090";
}

-(id)init {
    self = [super initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/1/", urlString]]];
    if (self) {
        self.serviceIsBusy = NO;
    }
    return self;
}


-(void)queryWiFiForLatitude:(double)latitude longitude:(double)longitude completionBlock:(WiFi2GoServiceWiFiQueryComplete)block {
    if (self.serviceIsBusy) return;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.serviceIsBusy = YES;
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
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        self.serviceIsBusy = NO;
        dispatch_async(dispatch_get_main_queue(), ^{ block(r, error); });
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        self.serviceIsBusy = NO;
        dispatch_async(dispatch_get_main_queue(), ^{ block(nil, error); });
    }];
    [operation start];
}


-(void) addNewAccessPointForVenueID:(NSString*) venueId SSID:(NSString*) ssid password:(NSString*) password {
    // http://wifi2use.appspot.com/api/1/addwifi
    //NSURL *url = [NSURL URLWithString:[[self.baseURL absoluteString] stringByAppendingFormat:@"addwifi"]];
    
    NSDictionary *parameters = @{
                                 @"venue_id": venueId,
                                 @"ssid": ssid,
                                 @"password": password != (NSString*)[NSNull null] ? password : @"",
                                 @"has_password": @(password != (NSString*)[NSNull null])
                                 };
    
    NSError *serializationError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&serializationError];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"POST"
                                               path:@"addwifi"
                                         parameters:nil];
    request.HTTPBody = jsonData;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"Request: %@", [request logDebugData]);
    
    [[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"success");
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failed: %@", [error localizedDescription]);
    }] start];
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
