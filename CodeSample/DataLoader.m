//
//  DataLoader.m
//  CodeSample
//
//  Copyright (c) 2014 Golden Frog, Inc. All rights reserved.
//

#import "DataLoader.h"

#import "LoadCounter.h"

@interface DataLoader ()
@property(nonatomic, strong) id<DataReceiver> loadDelegate;
@property(nonatomic, strong) NSDictionary *data;
@end

@implementation DataLoader

- (id)dataLoaderWithDelegate:(id<DataReceiver>)delegate
{
    DataLoader *loader = [[DataLoader alloc] init];
    loader.loadDelegate = delegate;
    
    return loader;
}

- (void)getData
{
    // TODO: Add a parameter that is entered in a search field at the top of the table view.
    // You will need to add this search field, grab the search value, and use this value as the search term.
    NSString *searchTerm = @"ferrari"; // default search term
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.reddit.com/search.json?q=%@", searchTerm]]];
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *apiResponse = [NSJSONSerialization JSONObjectWithData:urlData options:0 error:nil];
    NSDictionary *apiData = apiResponse[@"data"];
    NSArray *apiChildren = apiData[@"children"];
    self.data = apiChildren;
    // Call delegate after loading data
    [self.loadDelegate updateCount:self.data.count];
    [self.loadDelegate receivedData:self.data];
}

@end
