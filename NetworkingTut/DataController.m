//
//  DataController.m
//  NetworkingTut
//
//  Created by Norbert Spot on 12/01/16.
//  Copyright © 2016 CodeFluegel GmbH. All rights reserved.
//

#import "DataController.h"

#import <AFNetworking/AFHTTPRequestOperation.h>
#import "DataService.h"

@implementation DataController

+ (DataController *)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)loadData {
    NSLog(@"Documents directory: %@", [DataService applicationDocumentsDirectory]);
    
    [self.delegate requesting];
    
    [DataService requestJsonWithSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray *mutableOperations = [NSMutableArray new];
        
        // looping through the root object ("testfiles") and creating a download task for the files
        for (NSDictionary *fileDictionary in [responseObject objectForKey:@"testfiles"]) {
            // now lets create a download task for each file in the array
            NSURL *URL = [NSURL URLWithString:[[fileDictionary objectForKey:@"file"] objectForKey:@"url"]];
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            
            // set the completion block of the download task to save the file
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                [DataService saveFile:responseObject withFilename:[[fileDictionary objectForKey:@"file"] objectForKey:@"name"]];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", [error localizedDescription]);
                [self.delegate errorOccured:error];
            }];
            
            // add the download task to the operations array
            [mutableOperations addObject:operation];
        }
        
        // start the operations array with a completion block
        NSArray *operations = [AFURLConnectionOperation batchOfRequestOperations:mutableOperations progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
            NSLog(@"%lu of %lu complete", numberOfFinishedOperations, totalNumberOfOperations);
            [self.delegate status:[NSString stringWithFormat:@"%lu of %lu complete", numberOfFinishedOperations, totalNumberOfOperations]];
        } completionBlock:^(NSArray *operations) {
            NSLog(@"All operations in batch complete");
            [self.delegate batchComplete];
        }];
        [[NSOperationQueue mainQueue] addOperations:operations waitUntilFinished:NO];
        
    } failure:^(NSError *error) {
        NSLog(@"ERROR: %@", [error localizedDescription]);
        [self.delegate errorOccured:error];
    }];
}

@end
