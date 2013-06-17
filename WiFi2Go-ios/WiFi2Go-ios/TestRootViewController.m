//
//  TestRootViewController.m
//  WiFi2Go-ios
//
//  Created by Nicolas Ameghino on 6/4/13.
//  Copyright (c) 2013 Nicolas Ameghino. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "TestRootViewController.h"
#import "WiFi2GoServiceProtocol.h"
#import "WiFi2GoServiceFactory.h"
#import "Venue.h"
#import "VenuesListCell.h"

static NSArray *keys;

@interface TestRootViewController () <CLLocationManagerDelegate>
@property(nonatomic, strong) NSArray *data;
@property(nonatomic, strong) CLLocation *currentLocation;
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong) UIBarButtonItem *locateMeButton;
@end

@implementation TestRootViewController

+(void)load {
    keys = @[@"ssid", @"password", @"venue_id"];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.navigationItem.title = @"Nearby Public Wi-Fi";
        
        self.locateMeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                            target:self
                                                                            action:@selector(loadData:)];
        
        self.navigationItem.leftBarButtonItem = self.locateMeButton;
        
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.locationManager.delegate = self;
    }
    return self;
}

-(void) loadData:(id) sender {
    self.locateMeButton.enabled = NO;
    [self.locationManager startUpdatingLocation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 50.0f;
    [self.tableView registerClass:NSClassFromString(@"VenuesListCell") forCellReuseIdentifier:@"Cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) viewDidAppear:(BOOL)animated {
    [self test];
    //[self loadData:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    VenuesListCell *cell = (VenuesListCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Venue *v = self.data[indexPath.row];
    cell.venueNameLabel.text = [v name];
    cell.detailsLabel.text = [v mainCategory];
    
    if ([v hasWifi]) {
        cell.venueNameLabel.textColor = [UIColor blackColor];
        cell.venueSignalImageView.image = [UIImage imageNamed:@"signal.png"];
    } else {
        cell.venueNameLabel.textColor = [UIColor grayColor];
        cell.venueSignalImageView.image = nil;
    }
    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - WiFi2GoService testbed

-(void) test {
    self.locateMeButton.enabled = YES;
    [[WiFi2GoServiceFactory getService] queryWiFiForLatitude:-34.0
                                                   longitude:-58.0
                                             completionBlock:^(NSArray *results, NSError *error) {
                                                 if (error) {
                                                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                     message:[error localizedDescription]
                                                                                                    delegate:nil
                                                                                           cancelButtonTitle:@"Y bueh..."
                                                                                           otherButtonTitles:nil];
                                                     [alert show];
                                                     return;
                                                 }
                                                 self.data = results;
                                                 [self.tableView reloadData];
                                             }];
}

#pragma mark - CLLocationManager delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if ([locations count] == 0) {
        return;
    }
    
    for (CLLocation *location in locations) {
        if (location.horizontalAccuracy < 50.0f) {
            self.currentLocation = location;
            break;
        }
    }
    
    [self.locationManager stopUpdatingLocation];
    self.locateMeButton.enabled = YES;
    [[WiFi2GoServiceFactory getService] queryWiFiForLatitude:self.currentLocation.coordinate.latitude
                                                   longitude:self.currentLocation.coordinate.longitude
                                             completionBlock:^(NSArray *results, NSError *error) {
                                                 if (error) {
                                                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                     message:[error localizedDescription]
                                                                                                    delegate:nil
                                                                                           cancelButtonTitle:@"Y bueh..."
                                                                                           otherButtonTitles:nil];
                                                     [alert show];
                                                     return;
                                                 }
                                                 self.data = results;
                                                 [self.tableView reloadData];
                                             }];
}

@end
