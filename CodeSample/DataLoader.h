//
//  DataLoader.h
//  CodeSample
//  Edited by: John Solsma


#import <Foundation/Foundation.h>

#import "DataReceiver.h"

@interface DataLoader : NSObject

- (id)dataLoaderWithDelegate:(id<DataReceiver>)delegate;
- (void)getDataAndupdateTableView:(UITableView *)table onStartup:(BOOL)startup withActivityIndicator:(UIActivityIndicatorView *)indicator;
@property NSString *searchTerm;
@property NSArray *titlesAndThumbnails;

@end
