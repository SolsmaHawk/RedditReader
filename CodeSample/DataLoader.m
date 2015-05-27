//
//  DataLoader.m
//  CodeSample
//  Edited by: John Solsma
//  Copyright (c) 2014 Golden Frog, Inc. All rights reserved.
//

#import "DataLoader.h"
#import "LoadCounter.h"
#import <CoreData/CoreData.h>
#import "ObjectiveRecord.h"
#import "TableEntry.h"

@interface DataLoader ()
@property(nonatomic, strong) id<DataReceiver> loadDelegate;
@property(nonatomic, strong) NSDictionary *data;
@end

//#define DEBUGGING
//#define COREDATADEBUGGING

@implementation DataLoader

- (id)dataLoaderWithDelegate:(id<DataReceiver>)delegate
{
    DataLoader *loader = [[DataLoader alloc] init];
    loader.loadDelegate = delegate;
    
    return loader;
}

#pragma mark Core Data Methods

-(void)handleCoreDataCache
{
    [CoreDataManager sharedManager].modelName = @"CodeSampleDataModel";
    #ifdef COREDATADEBUGGING
    NSLog(@"Here are the number entries: %lu",(unsigned long)[[TableEntry all] count]);
    #endif
    
    for(TableEntry *entry in [TableEntry all])
    {
        [entry delete];
    }
    

}

-(void)loadFromCacheToTable:(UITableView *)table
{
    [CoreDataManager sharedManager].modelName = @"CodeSampleDataModel";
    #ifdef COREDATADEBUGGING
    NSLog(@"Here are the number entries: %lu",(unsigned long)[[TableEntry all] count]);
    #endif
    
    self.titlesAndThumbnails = [[NSArray alloc]init];
    
    NSMutableArray *titlesAndThumbnails = [[NSMutableArray alloc]init];
    for(TableEntry *entry in [TableEntry all])
    {
        //NSLog(@"%@",entry.title);
        NSArray *titleAndThumbnail = [[NSArray alloc]init];
        if(entry.thumbnail==NULL)
        {
            titleAndThumbnail=@[entry.title];
        }
        else
        {
            titleAndThumbnail=@[entry.title,entry.thumbnail];
        }
        [titlesAndThumbnails addObject:titleAndThumbnail];
        [entry delete];
    }
    
    self.titlesAndThumbnails=titlesAndThumbnails;
    [table reloadData];


}

-(void)saveTitleToCache:(NSString *)title withThumbnail:(NSString *)thumbnail
{
    if(thumbnail==NULL)
    {
        TableEntry *newEntry = [TableEntry create];
        newEntry.title = title;
        [newEntry save];
    }
    else
    {
        TableEntry *newEntry = [TableEntry create];
        newEntry.title = title;
        newEntry.thumbnail=thumbnail;
        [newEntry save];
    }
    
}

#pragma mark Fetch Data and Update Table Async Methods

- (void)getDataAndupdateTableView:(UITableView *)table onStartup:(BOOL)startup withActivityIndicator:(UIActivityIndicatorView *)indicator
{
    if(startup)
    {
       [self loadFromCacheToTable:table];
    }
    
    else
    {
    indicator.hidden=NO;
    self.titlesAndThumbnails = [[NSArray alloc]init];
    NSString *searchTerm = self.searchTerm;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.reddit.com/search.json?q=%@", searchTerm]]];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    [self handleCoreDataCache];
    dispatch_async(queue,
    ^{
        NSError        *error = nil;
        NSURLResponse  *response = nil;
        NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        dispatch_async(dispatch_get_main_queue(),
        ^{
            indicator.hidden=YES;
            if(NSClassFromString(@"NSJSONSerialization"))
            {
                NSError *error = nil;
                id object = [NSJSONSerialization
                     JSONObjectWithData:urlData
                     options:0
                     error:&error];
        
                if(error)
                { NSLog(@"JSON was malformed");
                }
    
                if([object isKindOfClass:[NSDictionary class]])
                {
                    NSMutableArray *parsedResults = [self parseResults:object];
                    self.titlesAndThumbnails=parsedResults;
                    [table reloadData];
                }
                else
                {
                    NSLog(@"JSON is in array form");

                }
            }
        });
        });
    }
    
}

-(NSMutableArray *)parseResults:(NSDictionary *)dictionary
{
    NSDictionary *dataNew=[dictionary valueForKey:@"data"];
    NSArray *children=[dataNew valueForKey:@"children"];
    [self.loadDelegate updateCount:children.count];
    [self.loadDelegate receivedData:children];
    NSMutableArray *titlesAndThumbnails = [[NSMutableArray alloc]init];
    for(int i=0; i< [children count]; i++)
    {
        NSDictionary *results =children[i];
        NSDictionary *nestedResults = [results objectForKey:@"data"];
        #ifdef DEBUGGING
        NSLog(@"\n\n Title:%@\n\n",[nestedResults objectForKey:@"title"]);
        #endif
        NSString *title = [nestedResults objectForKey:@"title"];
        #ifdef DEBUGGING
        NSLog(@"\n\n Thumbnail:%@\n\n",[temp2 objectForKey:@"thumbnail"]);
        #endif
        NSString *thumbnail = [nestedResults objectForKey:@"thumbnail"];
        NSArray *titleAndThumbnail = [[NSArray alloc]init];
        if([thumbnail isEqualToString:@""] || [thumbnail isEqualToString:@"self"]) // no thumbnail
        {
            titleAndThumbnail=@[title];
            #ifdef DEBUGGING
            NSLog(@"No thumbnail detected");
            #endif
            
            // Save to Core Data Cache
           [self saveTitleToCache:title withThumbnail:NULL];
            
            
        }
        else
        {
            titleAndThumbnail=@[title,thumbnail];
            
            // Save to Core Data Cache
            [self saveTitleToCache:title withThumbnail:thumbnail];
            
        }
        [titlesAndThumbnails addObject:titleAndThumbnail];
}
    return titlesAndThumbnails;
}

@end
