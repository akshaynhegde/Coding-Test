//
//  CTDocumentCollectionViewCell.h
//  CodingTest
//
//  Created by Akshay on 30/07/15.
//  Copyright (c) 2015 Akshay Hegde. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTDocumentCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) void(^InfoButtonActionBlock)(CTDocumentCollectionViewCell *sender);

- (void) customizeWithTitle:(NSString *) title;

@end
