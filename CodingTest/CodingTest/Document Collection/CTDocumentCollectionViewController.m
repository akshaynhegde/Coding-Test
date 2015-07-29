//
//  CTDocumentCollectionViewController.m
//  CodingTest
//
//  Created by Akshay on 29/07/15.
//  Copyright (c) 2015 Akshay Hegde. All rights reserved.
//

#import "CTDocumentCollectionViewController.h"
#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecord.h>
#import "CTDocument.h"
#import "CTHTTPDocumentsSessionInteractor.h"
#import "CTDocumentCollectionViewCell.h"
#import <SVProgressHUD/SVProgressHUD.h>

#define kCTDocumentCollectionCellID @"CTDocumentCollectionViewCellID"

@interface CTDocumentCollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSFetchedResultsController *fetchResultsController;
@property (nonatomic, strong) CTHTTPDocumentsSessionInteractor *documentSessionInteractor;

@end

@implementation CTDocumentCollectionViewController

#pragma mark -
#pragma mark - Init

+ (CTDocumentCollectionViewController *) loadFromStoryBoard
{
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}

#pragma mark -
#pragma mark - View Life Cuycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 10.0;
    layout.minimumLineSpacing = 10.0;
    layout.sectionInset = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    
    [self setUpFetchresultsController];
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeNone];
    __weak typeof(self) weakSelf = self;
    _documentSessionInteractor = [[CTHTTPDocumentsSessionInteractor alloc] init];
    [_documentSessionInteractor fetchDocumentsAndSaveToDBWithCompletion:^(NSURLSessionTask *task, id response) {
        
        [SVProgressHUD dismiss];
        NSError *fetchError = nil;
        [weakSelf.fetchResultsController performFetch:&fetchError];
        [weakSelf.collectionView reloadData];
        
    } failure:^(NSURLSessionTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error.localizedDescription]];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - helpers

- (void) setUpFetchresultsController
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([CTDocument class])];
    fetchRequest.fetchBatchSize = 50;
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modifiedDate" ascending:NO]];
    
    _fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[NSManagedObjectContext MR_defaultContext] sectionNameKeyPath:@"parentContainer" cacheName:@"CTDocumentsCollectionCache"];
    _fetchResultsController.delegate = self;
    
    NSError *error = nil;
    [_fetchResultsController performFetch:&error];
}

#pragma mark -
#pragma mark - fetchResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
{
    
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type;
{
    
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    
}

- (NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName
{
    return sectionName;
}

#pragma mark -
#pragma mark - UICollectionViewDelegate

#pragma mark -
#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeZero;
    size.width = 150.0;
    size.height = 100.0;
    return size;
}

#pragma mark -
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[_fetchResultsController sections] count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [_fetchResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CTDocumentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCTDocumentCollectionCellID forIndexPath:indexPath];
    CTDocument *document = [_fetchResultsController objectAtIndexPath:indexPath];
    [cell customizeWithTitle:document.name];
    
    return cell;
}

@end
