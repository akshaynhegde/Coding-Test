//
//  CTLoginViewController.m
//  CodingTest
//
//  Created by Akshay on 29/07/15.
//  Copyright (c) 2015 Akshay Hegde. All rights reserved.
//

#import "CTLoginViewController.h"

@interface CTLoginViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UITextField *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoLabelLeadingSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoLabelTrailingSpace;

@end

@implementation CTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     _infoLabel.text = @"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum";
    
    
     [self adjustContentSize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self adjustContentSize];
}

- (void) updateViewConstraints
{
    [super updateViewConstraints];
    _contentViewHeight.constant = _scrollView.contentSize.height;
}

- (void) adjustContentSize
{
    CGSize contentSize = CGSizeZero;
    contentSize.width = CGRectGetWidth(self.view.frame);
    contentSize.height = CGRectGetMinY(_infoLabel.frame) + [_infoLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.view.frame) - _infoLabelLeadingSpace.constant - _infoLabelTrailingSpace.constant, CGFLOAT_MAX)].height;
    _scrollView.contentSize = contentSize;
}

@end
