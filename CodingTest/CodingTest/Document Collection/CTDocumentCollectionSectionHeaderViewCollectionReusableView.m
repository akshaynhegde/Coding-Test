//
//  CTDocumentCollectionSectionHeaderViewCollectionReusableView.m
//  CodingTest
//
//  Created by Akshay on 30/07/15.
//  Copyright (c) 2015 Akshay Hegde. All rights reserved.
//

#import "CTDocumentCollectionSectionHeaderViewCollectionReusableView.h"

@implementation CTDocumentCollectionSectionHeaderViewCollectionReusableView

+ (UINib *) nib
{
    return [UINib nibWithNibName:NSStringFromClass(self) bundle:nil];
}

- (void)awakeFromNib {
    // Initialization code
}

@end
