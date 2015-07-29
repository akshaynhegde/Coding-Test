//
//  CTDocumentCollectionViewController.m
//  CodingTest
//
//  Created by Akshay on 29/07/15.
//  Copyright (c) 2015 Akshay Hegde. All rights reserved.
//

#import "CTDocumentCollectionViewController.h"

@interface CTDocumentCollectionViewController ()

@end

@implementation CTDocumentCollectionViewController

#pragma mark -
#pragma mark - Init

+ (CTDocumentCollectionViewController *) loadFromStoryBoard
{
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}

#pragma mark -
#pragma mark - View Life Cuycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
