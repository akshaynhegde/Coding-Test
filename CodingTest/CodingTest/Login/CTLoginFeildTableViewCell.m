//
//  CTLoginFeildTableViewCell.m
//  CodingTest
//
//  Created by Akshay on 29/07/15.
//  Copyright (c) 2015 Akshay Hegde. All rights reserved.
//

#import "CTLoginFeildTableViewCell.h"

@interface CTLoginFeildTableViewCell()

@property (nonatomic, readwrite) CTLoginfieldType type;

@end

@implementation CTLoginFeildTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) prepareForReuse
{
    [super prepareForReuse];
    _textField.delegate = nil;
}

- (void) customizeForType:(CTLoginfieldType)type
{
    _type = type;
    _textField.tag = _type;
    
    switch (type) {
        case CTLoginfieldTypeUserName:
            _textField.placeholder = @"User Name";
            _textField.secureTextEntry = NO;
            _textField.returnKeyType = UIReturnKeyNext;
            break;
        case CTLoginfieldTypePassword:
            _textField.placeholder = @"Password";
            _textField.secureTextEntry = YES;
            _textField.returnKeyType = UIReturnKeyGo;
            break;
        default:
            break;
    }
}

@end
