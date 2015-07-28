//
//  ViewController.m
//  CodingTest
//
//  Created by Akshay on 28/07/15.
//  Copyright (c) 2015 Akshay Hegde. All rights reserved.
//

#import "ViewController.h"
#import "CTHTTPDocumentsSessionInteractor.h"

@interface ViewController ()

@property (nonatomic, strong) CTHTTPDocumentsSessionInteractor *documentsSessionInteractor;
@property (nonatomic, weak) NSURLSessionTask *documentFetchTask;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchDocuments];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Fetching

- (void) fetchDocuments
{
    if (!_documentsSessionInteractor) {
        _documentsSessionInteractor = [[CTHTTPDocumentsSessionInteractor alloc] init];
    }
    
     _documentFetchTask = [_documentsSessionInteractor fetchDocumentsWithCompletion:^(NSURLSessionTask *task, id response) {
         NSLog(@"");
    } failure:^(NSURLSessionTask *task, NSError *error) {
        NSLog(@"");
    }];
}


#pragma mark -
#pragma mark - Dealloc

- (void) dealloc
{
    [_documentFetchTask cancel];
}

@end
