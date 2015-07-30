//
//  CTDocumentDetailViewController.m
//  CodingTest
//
//  Created by Akshay on 30/07/15.
//  Copyright (c) 2015 Akshay Hegde. All rights reserved.
//

#import "CTDocumentDetailViewController.h"
#import "CTDocument.h"

@interface CTDocumentDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation CTDocumentDetailViewController

+ (CTDocumentDetailViewController *) loadFromStoryBoard
{
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    NSError *error;
    CTDocument *document = (CTDocument *)[[NSManagedObjectContext MR_defaultContext] existingObjectWithID:_selectedDocumentID error:&error];
    if (document) {
        _titleLabel.text = document.name;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterFullStyle];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        
        NSMutableString *details = [[NSMutableString alloc] init];
        [details appendFormat:@"Created On %@\n",[dateFormatter stringFromDate:document.createdTime]];
        [details appendFormat:@"Last Edited on %@\n",[dateFormatter stringFromDate:document.modifiedDate]];
        _detailLabel.text = details;
    }
    
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = doneBarButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Target Action

- (void) done:(UIBarButtonItem *) sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
