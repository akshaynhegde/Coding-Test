//
//  CTHTTPDocumentsSessionManager.m
//  CodingTest
//
//  Created by Akshay on 28/07/15.
//  Copyright (c) 2015 Akshay Hegde. All rights reserved.
//

#import "CTHTTPDocumentsSessionManager.h"
#import <CommonCrypto/CommonCrypto.h>
#import "NSData+stringConversion.h"

#define BASE_URL @"https://api.getsigneasy.com"

#define USER_NAME @"signeasytask2@gmail.com"
#define PASSWORD @"signeasytask2"

@implementation CTHTTPDocumentsSessionManager

#pragma mark -
#pragma mark - Init

+ (CTHTTPDocumentsSessionManager *) sharedManager
{
    static CTHTTPDocumentsSessionManager *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    
        sharedInstance = [[CTHTTPDocumentsSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL] sessionConfiguration:[self sessionCongfiguration]];
    });
    
    return sharedInstance;
}

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (self) {
        
        /**
         *  Customizing the  response serializer.
         */
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        
        /**
         *  Customize the request serializer
         */
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        [self.requestSerializer setValue:[self authHeader] forHTTPHeaderField:@"Authorization"];
    }
    return self;
}

#pragma mark -
#pragma mark - Create Auth header

- (NSString *) authHeader
{
    NSString *userName = USER_NAME;
    NSString *password = PASSWORD;

    /**
     *  Base64 of password
     */
    NSData *encodedPassword = [[password dataUsingEncoding:NSUTF8StringEncoding] base64EncodedDataWithOptions:0];
    
    /**
     *  SHA256 on the base64 encoded password from before
     */
    unsigned char hashedPassword[32];
    CC_SHA256(encodedPassword.bytes, (unsigned int)encodedPassword.length, hashedPassword);
    
    encodedPassword = [NSData dataWithBytes:hashedPassword length:32];
    
    /**
     *  To generate the header, we combine the userName and encoded password and encode it again.
     */
    NSString *combinedUserNameAndPassword = [NSString stringWithFormat:@"%@:%@",userName,[encodedPassword hexadecimalString]];
    combinedUserNameAndPassword = [[combinedUserNameAndPassword dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    
    /**
     *  The final auth header
     */
    NSString *authHeader = [NSString stringWithFormat:@"Basic %@",combinedUserNameAndPassword];
    
    return authHeader;
}

#pragma mark -
#pragma mark - Helper methods

+ (NSURLSessionConfiguration *) sessionCongfiguration
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    return config;
}

@end
