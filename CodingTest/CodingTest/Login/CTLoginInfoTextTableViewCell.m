//
//  CTLoginInfoTextTableViewCell.m
//  CodingTest
//
//  Created by Akshay on 29/07/15.
//  Copyright (c) 2015 Akshay Hegde. All rights reserved.
//

#import "CTLoginInfoTextTableViewCell.h"

@implementation CTLoginInfoTextTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (UINib *) nib
{
    return [UINib nibWithNibName:NSStringFromClass(self) bundle:nil];
}

+ (CTLoginInfoTextTableViewCell *) loadFromNib
{
    return [[[self nib] instantiateWithOwner:self options:nil] firstObject];
}

@end
