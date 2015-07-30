//
//  CTHTTPDocumentsSessionInteractor.m
//  CodingTest
//
//  Created by Akshay on 28/07/15.
//  Copyright (c) 2015 Akshay Hegde. All rights reserved.
//

#import "CTHTTPDocumentsSessionInteractor.h"
#import "CTHTTPDocumentsSessionManager.h"

#import <MagicalRecord/MagicalRecord.h>

#import "CTDocumentFeed.h"
#import "CTDraftDocuments.h"
#import "CTOriginalDocuments.h"
#import "CTSignedDocuments.h"
#import "CTDocument.h"

#define DOCUMENTS_PATH   @"v4/files"

#define kCTAPIKeyCount            @"count"
#define kCTAPIKeyDraft            @"draft"
#define kCTAPIKeyFiles            @"files"
#define kCTAPIKeyOriginal         @"original"
#define kCTAPIKeySigned           @"signed"
#define kCTAPIKeyCreatedTime      @"created_time"
#define kCTAPIKeyLastModifiedTime @"last_modified_time"
#define kCTAPIKeyID               @"id"
#define kCTAPIKeyName             @"name"

@interface CTHTTPDocumentsSessionInteractor()

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation CTHTTPDocumentsSessionInteractor

#pragma mark -
#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

#pragma mark -
#pragma mark - API Calls

- (NSURLSessionDataTask *) fetchDocumentsAndSaveToDBWithCompletion:(CTHTTPSessionInteractorSuccessBlock)success failure:(CTHTTPSessionInteractorFailureBlock)failure
{
    __weak typeof(self) weakSelf = self;
    return [self GET:DOCUMENTS_PATH parameters:nil
             success:^(NSURLSessionTask *task, id response) {
                 [weakSelf saveResponseToDB:response withCompletion:^{
                     if (success) {
                         success(task,nil);
                     }
                 }];
             }
             failure:failure];
}

#pragma mark -
#pragma mark - Overriden

- (AFHTTPSessionManager *) sessionManger
{
    return [CTHTTPDocumentsSessionManager sharedManager];
}

#pragma mark -
#pragma mark - Parse and Saving to DB

- (void) saveResponseToDB:(NSDictionary *) response withCompletion:(void(^)(void)) completion
{
    __weak typeof(self) weakSelf = self;
    
    /**
     *  Making all a separate operation so that saves wouldn't be too much if there are too many objects
     */
    
    __block CTDocumentFeed *originalFeed = nil;
    NSBlockOperation *prepareParseOp = [NSBlockOperation blockOperationWithBlock:^{
        
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            /**
             *  Delete the existing feed
             */
            [CTDocumentFeed MR_truncateAllInContext:localContext];
            
            originalFeed = [CTDocumentFeed MR_createEntityInContext:localContext];
            originalFeed.count = [response objectForKey:kCTAPIKeyCount];
        }];
    }];
    
    /**
     *  Saving Drafts
     */
    NSBlockOperation *draftsSaveOp = [NSBlockOperation blockOperationWithBlock:^{
        
        NSDictionary *draftsDict = [response objectForKey:kCTAPIKeyDraft];
        NSArray *files = [draftsDict objectForKey:kCTAPIKeyFiles];
        
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            
            CTDocumentFeed *feed = [originalFeed MR_inContext:localContext];

            CTDraftDocuments *drafDocuments = [CTDraftDocuments MR_createEntityInContext:localContext];
            drafDocuments.count = [draftsDict objectForKey:kCTAPIKeyCount];
            drafDocuments.displayTitle = @"Drafts";
            
            for (NSDictionary *aDocumentDict in files) {
                CTDocument *aDocument = [weakSelf createDocumentEntityFromDict:aDocumentDict inContext:localContext];
                [drafDocuments addFilesObject:aDocument];
            }
            
            [feed addDocumentsObject:drafDocuments];
        }];
    }];
    
    [draftsSaveOp addDependency:prepareParseOp];
    
    /**
     *  Saving Originals
     */
    NSBlockOperation *origalsSaveOp = [NSBlockOperation blockOperationWithBlock:^{
        
        NSDictionary *originalsDict = [response objectForKey:kCTAPIKeyOriginal];
        NSArray *files = [originalsDict objectForKey:kCTAPIKeyFiles];
        
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {

            CTDocumentFeed *feed = [originalFeed MR_inContext:localContext];
            
            CTOriginalDocuments *originalDocuments = [CTOriginalDocuments MR_createEntityInContext:localContext];
            originalDocuments.count = [originalsDict objectForKey:kCTAPIKeyCount];
            originalDocuments.displayTitle = @"Originals";
            
            for (NSDictionary *aDocumentDict in files) {
                CTDocument *aDocument = [weakSelf createDocumentEntityFromDict:aDocumentDict inContext:localContext];
                [originalDocuments addFilesObject:aDocument];
            }
            
            [feed addDocumentsObject:originalDocuments];

        }];
    }];
    
    [origalsSaveOp addDependency:prepareParseOp];
    
    /**
     *  Saving Signed
     */
    NSBlockOperation *signedSaveOp = [NSBlockOperation blockOperationWithBlock:^{
        
        NSDictionary *signedDict = [response objectForKey:kCTAPIKeySigned];
        NSArray *files = [signedDict objectForKey:kCTAPIKeyFiles];

        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            
            CTDocumentFeed *feed = [originalFeed MR_inContext:localContext];
            
            CTSignedDocuments *signedDocuments = [CTSignedDocuments MR_createEntityInContext:localContext];
            signedDocuments.count = [signedDict objectForKey:kCTAPIKeyCount];
            signedDocuments.displayTitle = @"Signed";
            
            for (NSDictionary *aDocumentDict in files) {
                CTDocument *aDocument = [weakSelf createDocumentEntityFromDict:aDocumentDict inContext:localContext];
                [signedDocuments addFilesObject:aDocument];
            }
            
            [feed addDocumentsObject:signedDocuments];

        }];
    }];
    
    [signedSaveOp addDependency:prepareParseOp];
    
    NSBlockOperation *saveCompltionOp = [NSBlockOperation blockOperationWithBlock:^{
        //just here to know when everything is finisehd
    }];
    [saveCompltionOp addDependency:prepareParseOp];
    [saveCompltionOp addDependency:draftsSaveOp];
    [saveCompltionOp addDependency:origalsSaveOp];
    [saveCompltionOp addDependency:signedSaveOp];
    
    [saveCompltionOp setCompletionBlock:^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (completion) {
                completion();
            }
        }];
    }];

    [_operationQueue addOperation:draftsSaveOp];
    [_operationQueue addOperation:origalsSaveOp];
    [_operationQueue addOperation:signedSaveOp];
    [_operationQueue addOperation:prepareParseOp];
    [_operationQueue addOperation:saveCompltionOp];

}

- (CTDocument *) createDocumentEntityFromDict:(NSDictionary *) dict inContext:(NSManagedObjectContext *) context
{
    CTDocument *aDocument = [CTDocument MR_createEntityInContext:context];
    aDocument.identifier = [dict objectForKey:kCTAPIKeyID];
    aDocument.name = [dict objectForKey:kCTAPIKeyName];
    aDocument.createdTime = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:kCTAPIKeyCreatedTime] doubleValue]];
    aDocument.modifiedDate = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:kCTAPIKeyLastModifiedTime] doubleValue]];
    
    return aDocument;
}

@end
