//
//  DataLoader.h
//  CodeSample
//  Edited by: John Solsma
//  Copyright (c) 2014 Golden Frog, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DataReceiver.h"

@interface DataLoader : NSObject

- (id)dataLoaderWithDelegate:(id<DataReceiver>)delegate;
- (void)getDataAndupdateTableView:(UITableView *)table onStartup:(BOOL)startup;
@property NSString *searchTerm;
@property NSArray *titlesAndThumbnails;

@end
