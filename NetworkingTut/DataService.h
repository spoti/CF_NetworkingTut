//
//  DataService.h
//  NetworkingTut
//
//  Created by Norbert Spot on 09/10/15.
//  Copyright © 2015 CodeFluegel GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPRequestOperation;

@interface DataService : NSObject

+ (void)requestJsonWithSuccessBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(NSError *error))failure;

+ (NSURL *)applicationDocumentsDirectory;
+ (void)saveFile:(NSData *)fileData withFilename:(NSString *)filename;

@end
