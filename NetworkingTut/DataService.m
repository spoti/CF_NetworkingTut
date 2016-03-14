//
//  DataService.m
//  NetworkingTut
//
//  Created by Norbert Spot on 09/10/15.
//  Copyright © 2015 CodeFluegel GmbH. All rights reserved.
//

#import "DataService.h"
#import <AFNetworking/AFNetworking.h>

static NSString *const kJsonUrl = @"https://dl.dropboxusercontent.com/u/2000203/AFNetworkingBlocksTut/testfiles.json";

@implementation DataService

#pragma mark - AFNetworking Request

+ (void)requestWithUrl:(NSString *)url andIfSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(NSError *error))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // sometimes it just won't load the up to date json so ignore the cache to load the newest one
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:url parameters:nil success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

#pragma mark - Services

+ (void)requestJsonWithSuccessBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(NSError *error))failure {
    [DataService requestWithUrl:kJsonUrl andIfSuccess:success failure:failure];
}

#pragma mark - Helper methods

// Returns the URL to the application's Documents directory.
+ (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (void)saveFile:(NSData *)fileData withFilename:(NSString *)filename {
    NSString *path = [DataService applicationDocumentsDirectory].path;
    path = [path stringByAppendingPathComponent:filename];
    [fileData writeToFile:path atomically:YES];
}

@end
