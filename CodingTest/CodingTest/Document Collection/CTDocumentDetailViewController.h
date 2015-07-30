//
//  CTDocumentDetailViewController.h
//  CodingTest
//
//  Created by Akshay on 30/07/15.
//  Copyright (c) 2015 Akshay Hegde. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MagicalRecord/MagicalRecord.h>

@interface CTDocumentDetailViewController : UIViewController

@property (nonatomic, strong) NSManagedObjectID *selectedDocumentID;

+ (CTDocumentDetailViewController *) loadFromStoryBoard;

@end
