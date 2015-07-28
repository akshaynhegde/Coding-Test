//
//  CTHTTPDocumentsSessionInteractor.m
//  CodingTest
//
//  Created by Akshay on 28/07/15.
//  Copyright (c) 2015 Akshay Hegde. All rights reserved.
//

#import "CTHTTPDocumentsSessionInteractor.h"
#import "CTHTTPDocumentsSessionManager.h"

#define DOCUMENTS_PATH   @"v4/files"

@interface CTHTTPDocumentsSessionInteractor()

@end

@implementation CTHTTPDocumentsSessionInteractor

#pragma mark -
#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark -
#pragma mark - API Calls

- (NSURLSessionDataTask *) fetchDocumentsWithCompletion:(CTHTTPSessionInteractorSuccessBlock)success failure:(CTHTTPSessionInteractorFailureBlock)failure
{
    return [self GET:DOCUMENTS_PATH parameters:nil
             success:success
             failure:failure];
}

#pragma mark -
#pragma mark - Overriden

- (AFHTTPSessionManager *) sessionManger
{
    return [CTHTTPDocumentsSessionManager sharedManager];
}

@end
