//
//  DataLoader.h
//  CodeSample
//
//  Copyright (c) 2014 Golden Frog, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DataLoader : NSObject


- (void)getDataAndupdateTableView:(UITableView *)table onStartup:(BOOL)startup;
@property NSString *searchTerm;
@property NSArray *titlesAndThumbnails;

@end
