//
//  CTDocuments.h
//  CodingTest
//
//  Created by Akshay on 29/07/15.
//  Copyright (c) 2015 Akshay Hegde. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CTDocument, CTDocumentFeed;

@interface CTDocuments : NSManagedObject

@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) CTDocumentFeed *feed;
@property (nonatomic, retain) NSSet *files;
@end

@interface CTDocuments (CoreDataGeneratedAccessors)

- (void)addFilesObject:(CTDocument *)value;
- (void)removeFilesObject:(CTDocument *)value;
- (void)addFiles:(NSSet *)values;
- (void)removeFiles:(NSSet *)values;

@end
