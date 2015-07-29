//
//  CTLoginFeildTableViewCell.m
//  CodingTest
//
//  Created by Akshay on 29/07/15.
//  Copyright (c) 2015 Akshay Hegde. All rights reserved.
//

#import "CTLoginFeildTableViewCell.h"

@implementation CTLoginFeildTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) customizeForType:(CTLoginfieldType)type
{
    switch (type) {
        case CTLoginfieldTypeUserName:
            _textField.placeholder = @"User Name";
            _textField.secureTextEntry = NO;
            break;
        case CTLoginfieldTypePassword:
            _textField.placeholder = @"Password";
            _textField.secureTextEntry = YES;
            break;
        default:
            break;
    }
}

@end
