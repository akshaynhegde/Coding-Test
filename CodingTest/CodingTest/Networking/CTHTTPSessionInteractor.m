//
//  CTHTTPSessionInteractor.m
//  CodingTest
//
//  Created by Akshay on 28/07/15.
//  Copyright (c) 2015 Akshay Hegde. All rights reserved.
//

#import "CTHTTPSessionInteractor.h"
#import "AFHTTPSessionManager.h"

@implementation CTHTTPSessionInteractor

- (NSURLSessionDataTask *) GET:(NSString *)URLString
                    parameters:(id)parameters
                       success:(CTHTTPSessionInteractorSuccessBlock)success
                       failure:(CTHTTPSessionInteractorFailureBlock)failure
{
    return [[self sessionManger] GET:URLString parameters:parameters success:success failure:failure];
}


- (NSURLSessionDataTask *) POST:(NSString *)URLString
                     parameters:(id)parameters
                        success:(CTHTTPSessionInteractorSuccessBlock)success
                        failure:(CTHTTPSessionInteractorFailureBlock)failure
{
    return [[self sessionManger] POST:URLString parameters:parameters success:success failure:failure];
}

- (AFHTTPSessionManager *) sessionManger
{
    //Override in subclasses
    return nil;
}

@end
