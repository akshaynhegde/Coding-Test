//
//  CTDocumentFeed.h
//  CodingTest
//
//  Created by Akshay on 29/07/15.
//  Copyright (c) 2015 Akshay Hegde. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CTDocument;

@interface CTDocumentFeed : NSManagedObject

@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSSet *documents;
@end

@interface CTDocumentFeed (CoreDataGeneratedAccessors)

- (void)addDocumentsObject:(CTDocument *)value;
- (void)removeDocumentsObject:(CTDocument *)value;
- (void)addDocuments:(NSSet *)values;
- (void)removeDocuments:(NSSet *)values;

@end
