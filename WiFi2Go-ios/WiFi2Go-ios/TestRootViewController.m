//
//  TestRootViewController.m
//  WiFi2Go-ios
//
//  Created by Nicolas Ameghino on 6/4/13.
//  Copyright (c) 2013 Nicolas Ameghino. All rights reserved.
//

#import "TestRootViewController.h"
#import "WiFi2GoService.h"

static NSArray *keys;

@interface TestRootViewController ()
@property(nonatomic, strong) NSArray *data;
@end

@implementation TestRootViewController

+(void)load {
    keys = @[@"name", @"password", @"location_id"];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Nearby Public Wi-Fi";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:NSClassFromString(@"UITableViewCell") forCellReuseIdentifier:@"Cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) viewDidAppear:(BOOL)animated {
    [[WiFi2GoService new] queryWiFiForLatitude:99
                                     longitude:-158
                               completionBlock:^(NSArray *results, NSError *error) {
                                   if (error) {
                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                       message:@"algo..."
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"ACHU!!!!"
                                                                             otherButtonTitles:nil];
                                       [alert show];
                                       return;
                                   }
                                   self.data = results;
                                   [self.tableView reloadData];
                               }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *d = self.data[indexPath.section];
    NSString *key = keys[indexPath.row];

    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", key, d[key]];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Wi-Fi %d", section+1];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
