//
//  CTDocumentFeed.h
//  CodingTest
//
//  Created by Akshay on 30/07/15.
//  Copyright (c) 2015 Akshay Hegde. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CTDocuments;

@interface CTDocumentFeed : NSManagedObject

@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSSet *documents;
@end

@interface CTDocumentFeed (CoreDataGeneratedAccessors)

- (void)addDocumentsObject:(CTDocuments *)value;
- (void)removeDocumentsObject:(CTDocuments *)value;
- (void)addDocuments:(NSSet *)values;
- (void)removeDocuments:(NSSet *)values;

@end
