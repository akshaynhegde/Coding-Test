//
//  CTHTTPSessionInteractor.h
//  CodingTest
//
//  Created by Akshay on 28/07/15.
//  Copyright (c) 2015 Akshay Hegde. All rights reserved.
//


#import <Foundation/Foundation.h>

@class AFHTTPSessionManager;

typedef void(^CTHTTPSessionInteractorSuccessBlock)(NSURLSessionTask *task, id response);
typedef void(^CTHTTPSessionInteractorFailureBlock)(NSURLSessionTask *task, NSError *error);

/**
 *  Just an Abstarct superclass for the SessionInteractors. Meant to be sublassed and used.
 */
@interface CTHTTPSessionInteractor : NSObject

/**
*  Override the method in subclasses and return the right Session manager
*
*  @return an instance of AFHTTPSessionManager.
*/
- (AFHTTPSessionManager *) sessionManger;


/**
 *  Makes a GET request
 *
 *  @param URLString  The urlString to create the URL request
 *  @param parameters The parameters for the request
 *  @param success    The success block will be executed on success of the network call.
 *  @param failure    The failure bloack will be executed in case of an error.
 *
 *  @return An instance of NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(CTHTTPSessionInteractorSuccessBlock) success
                      failure:(CTHTTPSessionInteractorFailureBlock) failure;

/**
 *  Make a POST request
 *
 *  @param URLString  The urlString to create the URL request
 *  @param parameters The parameters for the request
 *  @param success    The success block will be executed on success of the network call.
 *  @param failure    The failure bloack will be executed in case of an error.
 *
 *  @return An instance of NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(CTHTTPSessionInteractorSuccessBlock)success
                       failure:(CTHTTPSessionInteractorFailureBlock)failure;

@end
