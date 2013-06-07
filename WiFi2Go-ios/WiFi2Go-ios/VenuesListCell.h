//
//  VenuesListCell.h
//  WiFi2Go-ios
//
//  Created by Nicolas Ameghino on 6/6/13.
//  Copyright (c) 2013 Nicolas Ameghino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenuesListCell : UITableViewCell

@property(nonatomic, strong) UILabel *venueNameLabel, *detailsLabel;
@property(nonatomic, strong) UIImageView *venueSignalImageView;

@end
