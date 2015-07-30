//
//  CTDocument.h
//  CodingTest
//
//  Created by Akshay on 30/07/15.
//  Copyright (c) 2015 Akshay Hegde. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CTDocuments;

@interface CTDocument : NSManagedObject

@property (nonatomic, retain) NSDate * createdTime;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSDate * modifiedDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) CTDocuments *parentContainer;

@end
