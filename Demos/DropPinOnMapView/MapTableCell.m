//
//  MapTableCell.m
//  SchoolDemo
//
//  Created by Liefu Liu on 11/1/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import "MapTableCell.h"

@implementation MapTableCell

- (void)awakeFromNib {
    // Initialization code
    self.mapView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) setPin:(CLLocationCoordinate2D) locationCoordinate {
    
}

@end
