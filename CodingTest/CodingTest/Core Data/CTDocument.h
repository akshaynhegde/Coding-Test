//
//  CTDocument.h
//  CodingTest
//
//  Created by Akshay on 29/07/15.
//  Copyright (c) 2015 Akshay Hegde. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CTDocumentFeed;

@interface CTDocument : NSManagedObject

@property (nonatomic, retain) NSDate * createdTime;
@property (nonatomic, retain) NSDate * modifiedTime;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) CTDocumentFeed *feed;

@end
