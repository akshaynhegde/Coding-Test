//
//  CTDocumentCollectionViewCell.m
//  CodingTest
//
//  Created by Akshay on 30/07/15.
//  Copyright (c) 2015 Akshay Hegde. All rights reserved.
//

#import "CTDocumentCollectionViewCell.h"

@interface CTDocumentCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;

- (IBAction)infoButtonTapped:(UIButton *)sender;
@end

@implementation CTDocumentCollectionViewCell

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 2.0;
    self.layer.cornerRadius = 3.0;
    self.layer.masksToBounds = YES;
}

- (IBAction)infoButtonTapped:(UIButton *)sender
{
    if (_InfoButtonActionBlock) {
        _InfoButtonActionBlock(self);
    }
}

- (void) customizeWithTitle:(NSString *)title
{
    _titleLabel.text = title;
}

@end
