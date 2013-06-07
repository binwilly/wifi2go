//
//  VenuesListCell.m
//  WiFi2Go-ios
//
//  Created by Nicolas Ameghino on 6/6/13.
//  Copyright (c) 2013 Nicolas Ameghino. All rights reserved.
//

#import "VenuesListCell.h"

@implementation VenuesListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //self.contentView.backgroundColor = [UIColor lightGrayColor];
        
        self.venueNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.venueNameLabel.textColor = [UIColor blackColor];
        self.venueNameLabel.font = [UIFont boldSystemFontOfSize:self.venueNameLabel.font.pointSize];
        //self.venueNameLabel.backgroundColor =  [UIColor orangeColor];
        
        self.detailsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.detailsLabel.textColor = [UIColor grayColor];
        self.detailsLabel.font = [UIFont systemFontOfSize:self.detailsLabel.font.pointSize * 0.80f];
        //self.detailsLabel.backgroundColor = [UIColor colorWithRed:1.0f green:0.8 blue:0.8 alpha:1.0f];
        
        self.venueSignalImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.venueSignalImageView.contentMode = UIViewContentModeScaleAspectFit;
        //self.venueSignalImageView.backgroundColor = [UIColor redColor];
        
        [self.contentView addSubview:self.venueSignalImageView];
        [self.contentView addSubview:self.detailsLabel];
        [self.contentView addSubview:self.venueNameLabel];
    }
    return self;
}

-(void) layoutSubviews {
    
    const CGFloat imageViewNameLabelSeparatorWidth = 10.0f;
    const CGFloat nameLabelDetailLabelSeparatorWidth = 10.0f;
    
    [super layoutSubviews];
    [self.venueNameLabel sizeToFit];
    [self.detailsLabel sizeToFit];
    
    CGFloat midY = CGRectGetMidY(self.bounds);

    CGSize imageViewSize = CGSizeMake(20.0f, 20.0f);
    CGFloat imageViewTop = midY - imageViewSize.height / 2.0 ;
    CGFloat imageViewLeft = 10.0f;
    CGPoint imageViewOrigin = CGPointMake(imageViewLeft, imageViewTop);
    
    self.venueSignalImageView.frame = (CGRect){imageViewOrigin, imageViewSize};
    
    CGFloat venueNameLabelTop = midY - self.venueNameLabel.bounds.size.height / 2.0f;
    CGFloat venueNameLabelLeft = imageViewLeft + self.venueSignalImageView.frame.size.width + imageViewNameLabelSeparatorWidth;
    
    self.venueNameLabel.frame = (CGRect){CGPointMake(venueNameLabelLeft, venueNameLabelTop), self.venueNameLabel.bounds.size};
    
    CGFloat detailsLabelTop = midY - self.detailsLabel.bounds.size.height / 2.0f;
    CGFloat detailsLabelLeft = venueNameLabelLeft + self.detailsLabel.bounds.size.width + nameLabelDetailLabelSeparatorWidth;
    
    self.detailsLabel.frame = (CGRect){CGPointMake(detailsLabelLeft, detailsLabelTop), self.detailsLabel.bounds.size};
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
