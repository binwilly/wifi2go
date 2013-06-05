//
//  WiFi2GoService.m
//  WiFi2Go-ios
//
//  Created by Nicolas Ameghino on 6/4/13.
//  Copyright (c) 2013 Nicolas Ameghino. All rights reserved.
//

#import "WiFi2GoService.h"

@implementation WiFi2GoService

static NSString *urlString;

+(void)load {
    urlString = @"http://localhost:8080/api/1/wifi";
    //urlString = @"http://localhost:8080/";
}

-(void)queryWiFiForLatitude:(double)latitude
                  longitude:(double)longitude
            completionBlock:(WiFi2GoServiceWiFiQueryComplete)block {
    //NSDictionary *parameters = @{@"latitude": @(latitude), @"longitude": @(longitude)};
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
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
                               id r = [NSJSONSerialization JSONObjectWithData:body
                                                                      options:0
                                                                        error:&error];
                               if (error != nil) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       block(nil, error);
                                   });
                               }
                               
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   block(r, nil);
                               });
                           }];
}

@end
