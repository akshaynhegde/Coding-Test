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
#import "CTDocumentCollectionSectionHeaderViewCollectionReusableView.h"
#import "CTOriginalDocuments.h"
#import "CTDraftDocuments.h"
#import "CTSignedDocuments.h"
#import "CTDocumentDetailViewController.h"

#define kCTDocumentCollectionCellID @"CTDocumentCollectionViewCellID"
#define kCTDocumentCollectionSectionHeaderViewID @"kCTDocumentCollectionSectionHeaderViewID"

@interface CTDocumentCollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSFetchedResultsController *fetchResultsController;
@property (nonatomic, strong) CTHTTPDocumentsSessionInteractor *documentSessionInteractor;

/**
 *  When using NSFetchedResultsController with collectionView, we need to club all the changes in a performBatchUpdates: block on collectionVIew as there is no beginUpdates and endUpdates as in tableViews. Hence these dictionaries wil be used to keep track of the changes that need to be clubbed together.
 */
@property (nonatomic, strong) NSMutableDictionary *objectChanges;
@property (nonatomic, strong) NSMutableDictionary *sectionChanges;


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
    
    self.title =  @"Documents";
    
    [self setUpFetchresultsController];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 10.0;
    layout.minimumLineSpacing = 10.0;
    layout.sectionInset = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    
    [_collectionView registerNib:[CTDocumentCollectionSectionHeaderViewCollectionReusableView nib] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCTDocumentCollectionSectionHeaderViewID];
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeNone];
    __weak typeof(self) weakSelf = self;
    _documentSessionInteractor = [[CTHTTPDocumentsSessionInteractor alloc] init];
    [_documentSessionInteractor fetchDocumentsAndSaveToDBWithCompletion:^(NSURLSessionTask *task, id response) {
        
        [SVProgressHUD dismiss];
//        NSError *fetchError = nil;
//        [weakSelf.fetchResultsController performFetch:&fetchError];
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
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"parentContainer.displayTitle" ascending:NO],[NSSortDescriptor sortDescriptorWithKey:@"modifiedDate" ascending:NO]];
    
    _fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[NSManagedObjectContext MR_defaultContext] sectionNameKeyPath:@"parentContainer.displayTitle" cacheName:@"CTDocumentsCollectionCache"];
    _fetchResultsController.delegate = self;
    
    NSError *error = nil;
    [_fetchResultsController performFetch:&error];
}

#pragma mark -
#pragma mark - fetchResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
{
    if (!indexPath || !newIndexPath) {
        return;
    }
    
    NSMutableArray *changeSet = _objectChanges[@(type)];
    if (changeSet == nil) {
        changeSet = [[NSMutableArray alloc] init];
        _objectChanges[@(type)] = changeSet;
    }
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [changeSet addObject:newIndexPath];
            break;
        case NSFetchedResultsChangeDelete:
            [changeSet addObject:indexPath];
            break;
        case NSFetchedResultsChangeUpdate:
            [changeSet addObject:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [changeSet addObject:@[indexPath, newIndexPath]];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type;
{
    if (type == NSFetchedResultsChangeInsert || type == NSFetchedResultsChangeDelete) {
        NSMutableIndexSet *changeSet = _sectionChanges[@(type)];
        if (changeSet != nil) {
            [changeSet addIndex:sectionIndex];
        } else {
            _sectionChanges[@(type)] = [[NSMutableIndexSet alloc] initWithIndex:sectionIndex];
        }
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    _objectChanges = [NSMutableDictionary dictionary];
    _sectionChanges = [NSMutableDictionary dictionary];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSMutableArray *moves = _objectChanges[@(NSFetchedResultsChangeMove)];
    if (moves.count > 0) {
        NSMutableArray *updatedMoves = [[NSMutableArray alloc] initWithCapacity:moves.count];
        
        NSMutableIndexSet *insertSections = _sectionChanges[@(NSFetchedResultsChangeInsert)];
        NSMutableIndexSet *deleteSections = _sectionChanges[@(NSFetchedResultsChangeDelete)];
        for (NSArray *move in moves) {
            NSIndexPath *fromIP = move[0];
            NSIndexPath *toIP = move[1];
            
            if ([deleteSections containsIndex:fromIP.section]) {
                if (![insertSections containsIndex:toIP.section]) {
                    NSMutableArray *changeSet = _objectChanges[@(NSFetchedResultsChangeInsert)];
                    if (changeSet == nil) {
                        changeSet = [[NSMutableArray alloc] initWithObjects:toIP, nil];
                        _objectChanges[@(NSFetchedResultsChangeInsert)] = changeSet;
                    } else {
                        [changeSet addObject:toIP];
                    }
                }
            } else if ([insertSections containsIndex:toIP.section]) {
                NSMutableArray *changeSet = _objectChanges[@(NSFetchedResultsChangeDelete)];
                if (changeSet == nil) {
                    changeSet = [[NSMutableArray alloc] initWithObjects:fromIP, nil];
                    _objectChanges[@(NSFetchedResultsChangeDelete)] = changeSet;
                } else {
                    [changeSet addObject:fromIP];
                }
            } else {
                [updatedMoves addObject:move];
            }
        }
        
        if (updatedMoves.count > 0) {
            _objectChanges[@(NSFetchedResultsChangeMove)] = updatedMoves;
        } else {
            [_objectChanges removeObjectForKey:@(NSFetchedResultsChangeMove)];
        }
    }
    
    NSMutableArray *deletes = _objectChanges[@(NSFetchedResultsChangeDelete)];
    if (deletes.count > 0) {
        NSMutableIndexSet *deletedSections = _sectionChanges[@(NSFetchedResultsChangeDelete)];
        [deletes filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSIndexPath *evaluatedObject, NSDictionary *bindings) {
            return ![deletedSections containsIndex:evaluatedObject.section];
        }]];
    }
    
    NSMutableArray *inserts = _objectChanges[@(NSFetchedResultsChangeInsert)];
    if (inserts.count > 0) {
        NSMutableIndexSet *insertedSections = _sectionChanges[@(NSFetchedResultsChangeInsert)];
        [inserts filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSIndexPath *evaluatedObject, NSDictionary *bindings) {
            return ![insertedSections containsIndex:evaluatedObject.section];
        }]];
    }
    
    UICollectionView *collectionView = self.collectionView;
    
    [collectionView performBatchUpdates:^{
        NSIndexSet *deletedSections = _sectionChanges[@(NSFetchedResultsChangeDelete)];
        if (deletedSections.count > 0) {
            [collectionView deleteSections:deletedSections];
        }
        
        NSIndexSet *insertedSections = _sectionChanges[@(NSFetchedResultsChangeInsert)];
        if (insertedSections.count > 0) {
            [collectionView insertSections:insertedSections];
        }
        
        NSArray *deletedItems = _objectChanges[@(NSFetchedResultsChangeDelete)];
        if (deletedItems.count > 0) {
            [collectionView deleteItemsAtIndexPaths:deletedItems];
        }
        
        NSArray *insertedItems = _objectChanges[@(NSFetchedResultsChangeInsert)];
        if (insertedItems.count > 0) {
            [collectionView insertItemsAtIndexPaths:insertedItems];
        }
        
        NSArray *reloadItems = _objectChanges[@(NSFetchedResultsChangeUpdate)];
        if (reloadItems.count > 0) {
            [collectionView reloadItemsAtIndexPaths:reloadItems];
        }
        
        NSArray *moveItems = _objectChanges[@(NSFetchedResultsChangeMove)];
        for (NSArray *paths in moveItems) {
            [collectionView moveItemAtIndexPath:paths[0] toIndexPath:paths[1]];
        }
    } completion:nil];
    
    _objectChanges = nil;
    _sectionChanges = nil;
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

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.bounds.size.width, 44.0);
}

#pragma mark -
#pragma mark - UICollectionViewDataSource

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CTDocumentCollectionSectionHeaderViewCollectionReusableView *sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kCTDocumentCollectionSectionHeaderViewID forIndexPath:indexPath];
        
        id <NSFetchedResultsSectionInfo> sectionInfo = [_fetchResultsController sections][indexPath.section];
        NSString *title = [NSString stringWithFormat:@"%@ (%@)",[sectionInfo indexTitle],@([sectionInfo numberOfObjects])];
        sectionHeader.titleLabel.text = title;
        
        return sectionHeader;
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[_fetchResultsController sections] count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [_fetchResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CTDocumentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCTDocumentCollectionCellID forIndexPath:indexPath];
    CTDocument *document = [_fetchResultsController objectAtIndexPath:indexPath];
    [cell customizeWithTitle:document.name];
    
    __weak typeof(self) weakSelf = self;
    [cell setInfoButtonActionBlock:^(CTDocumentCollectionViewCell *sender) {
        NSIndexPath *senderIndexPath = [collectionView indexPathForCell:sender];
        
        if (indexPath) {
            CTDocument *selectedDocument = [weakSelf.fetchResultsController objectAtIndexPath:senderIndexPath];
            
            CTDocumentDetailViewController *detailVC = [CTDocumentDetailViewController loadFromStoryBoard];
            detailVC.selectedDocumentID = selectedDocument.objectID;
            
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailVC];
            [weakSelf presentViewController:navController animated:YES completion:nil];
        }
    }];
    
    return cell;
}


#pragma mark -
#pragma mark - Dealloc

- (void)dealloc
{
    [SVProgressHUD dismiss];
}

@end
