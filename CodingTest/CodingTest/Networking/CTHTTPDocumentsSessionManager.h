//
//  CTHTTPDocumentsSessionManager.h
//  CodingTest
//
//  Created by Akshay on 28/07/15.
//  Copyright (c) 2015 Akshay Hegde. All rights reserved.
//

#import "AFHTTPSessionManager.h"

/**
 *  A class that actually configures the session for Document feeds
 */
@interface CTHTTPDocumentsSessionManager : AFHTTPSessionManager

+ (CTHTTPDocumentsSessionManager *) sharedManager;

@end
