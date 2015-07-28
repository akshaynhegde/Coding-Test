//
//  CTHTTPDocumentsSessionInteractor.h
//  CodingTest
//
//  Created by Akshay on 28/07/15.
//  Copyright (c) 2015 Akshay Hegde. All rights reserved.
//

#import "CTHTTPSessionInteractor.h"

@interface CTHTTPDocumentsSessionInteractor : CTHTTPSessionInteractor

- (NSURLSessionDataTask *) fetchDocumentsWithCompletion:(CTHTTPSessionInteractorSuccessBlock) success failure:(CTHTTPSessionInteractorFailureBlock) failure;

@end
