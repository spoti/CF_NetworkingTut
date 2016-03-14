//
//  ViewController.m
//  NetworkingTut
//
//  Created by Norbert Spot on 09/10/15.
//  Copyright © 2015 CodeFluegel GmbH. All rights reserved.
//

#import "ViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "DataController.h"

@interface ViewController () <DataControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[DataController sharedInstance] setDelegate:self];
    [[DataController sharedInstance] loadData];
}

#pragma mark - DataControllerDelegate

- (void)requesting {
    [SVProgressHUD show];
}

- (void)batchComplete {
    [SVProgressHUD showSuccessWithStatus:@"All operations in batch complete"];
}

- (void)status:(NSString *)status {
    [SVProgressHUD showWithStatus:status];
}

- (void)errorOccured:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"Error: %@", [error localizedDescription]]];
}

@end
