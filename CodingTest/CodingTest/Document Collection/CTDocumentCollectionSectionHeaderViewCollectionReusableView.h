//
//  CTDocumentCollectionSectionHeaderViewCollectionReusableView.h
//  CodingTest
//
//  Created by Akshay on 30/07/15.
//  Copyright (c) 2015 Akshay Hegde. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTDocumentCollectionSectionHeaderViewCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (UINib *) nib;

@end
