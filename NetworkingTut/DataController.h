//
//  DataController.h
//  NetworkingTut
//
//  Created by Norbert Spot on 12/01/16.
//  Copyright © 2016 CodeFluegel GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataController;

@protocol DataControllerDelegate <NSObject>

- (void)status:(NSString *)status;
- (void)errorOccured:(NSError *)error;
- (void)requesting;
- (void)batchComplete;

@end

@interface DataController : NSObject

@property (nonatomic, weak) id <DataControllerDelegate> delegate;

+ (DataController *)sharedInstance;
- (void)loadData;

@end
