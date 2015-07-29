//
//  CTLoginFeildTableViewCell.h
//  CodingTest
//
//  Created by Akshay on 29/07/15.
//  Copyright (c) 2015 Akshay Hegde. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CTLoginfieldType) {
    CTLoginfieldTypeUserName,
    CTLoginfieldTypePassword
};

@interface CTLoginFeildTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *textField;

- (void) customizeForType:(CTLoginfieldType) type;
@end
