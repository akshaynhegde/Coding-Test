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
    NSBlockOperation *saveOp = [NSBlockOperation blockOperationWithBlock:^{
       
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            
            NSDictionary *draftsDict = [response objectForKey:kCTAPIKeyDraft];
            NSDictionary *originalsDict = [response objectForKey:kCTAPIKeyOriginal];
            NSDictionary *signedDict = [response objectForKey:kCTAPIKeySigned];
           
            /**
             *  Delete the existing feed
             */
            CTDocumentFeed *existingFeed = [CTDocumentFeed MR_findFirstInContext:localContext];
            if (existingFeed) {
                [existingFeed MR_deleteEntity];
            }
            
            CTDocumentFeed *feed = [CTDocumentFeed MR_createEntityInContext:localContext];
            feed.count = [response objectForKey:kCTAPIKeyCount];
            
            /**
             *  Drafts
             */
            NSArray *files = [draftsDict objectForKey:kCTAPIKeyFiles];
            
            CTDraftDocuments *drafDocuments = [CTDraftDocuments MR_createEntityInContext:localContext];
            drafDocuments.count = [draftsDict objectForKey:kCTAPIKeyCount];
            
            for (NSDictionary *aDocumentDict in files) {
                CTDocument *aDocument = [weakSelf createDocumentEntityFromDict:aDocumentDict inContext:localContext];
                [drafDocuments addFilesObject:aDocument];
            }
            
            [feed addDocumentsObject:drafDocuments];
            
            /**
             *  Originals
             */
            files = [originalsDict objectForKey:kCTAPIKeyFiles];
            
            CTOriginalDocuments *originalDocuments = [CTOriginalDocuments MR_createEntityInContext:localContext];
            originalDocuments.count = [originalsDict objectForKey:kCTAPIKeyCount];
            
            for (NSDictionary *aDocumentDict in files) {
                CTDocument *aDocument = [weakSelf createDocumentEntityFromDict:aDocumentDict inContext:localContext];
                [originalDocuments addFilesObject:aDocument];
            }
            
            [feed addDocumentsObject:originalDocuments];

            /**
             *  Signed
             */
            files = [signedDict objectForKey:kCTAPIKeyFiles];
            
            CTSignedDocuments *signedDocuments = [CTSignedDocuments MR_createEntityInContext:localContext];
            signedDocuments.count = [signedDict objectForKey:kCTAPIKeyCount];
            
            for (NSDictionary *aDocumentDict in files) {
                CTDocument *aDocument = [weakSelf createDocumentEntityFromDict:aDocumentDict inContext:localContext];
                [originalDocuments addFilesObject:aDocument];
            }
            
            [feed addDocumentsObject:signedDocuments];
            
        }];
        
    }];
    
    [saveOp setCompletionBlock:^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (completion) {
                completion();
            }
        }];
    }];
    
    [_operationQueue addOperation:saveOp];
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
