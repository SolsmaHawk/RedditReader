//
//  DataLoader.m
//  CodeSample
//
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


@implementation DataLoader

- (id)dataLoaderWithDelegate:(id<DataReceiver>)delegate
{
    DataLoader *loader = [[DataLoader alloc] init];
    loader.loadDelegate = delegate;
    
    return loader;
}

-(void)handleCoreDataCache
{
    [CoreDataManager sharedManager].modelName = @"CodeSampleDataModel";
    
    NSArray *entries = [TableEntry all];
    
    NSLog(@"Here are the number entries: %lu",(unsigned long)[entries count]);
    
    
    for(TableEntry *entry in entries)
    {
        [entry delete];
    }
    

}

-(void)loadFromCacheToTable:(UITableView *)table
{
    [CoreDataManager sharedManager].modelName = @"CodeSampleDataModel";
    
    NSArray *entries = [TableEntry all];
    
    NSLog(@"Here are the number entries: %lu",(unsigned long)[entries count]);
    
    self.titlesAndThumbnails = [[NSArray alloc]init];
    
    NSMutableArray *titlesAndThumbnails = [[NSMutableArray alloc]init];
    for(TableEntry *entry in entries)
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

- (void)getDataAndupdateTableView:(UITableView *)table onStartup:(BOOL)startup
{
    // TODO: Add a parameter that is entered in a search field at the top of the table view. - complete
    // You will need to add this search field, grab the search value, and use this value as the search term. - complete

    if(startup)
    {
       [self loadFromCacheToTable:table];
    }
    
    else
    {
    self.titlesAndThumbnails = [[NSArray alloc]init];
    NSString *searchTerm = self.searchTerm; // default search term
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.reddit.com/search.json?q=%@", searchTerm]]];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue,
    ^{
        [self handleCoreDataCache];
        NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        dispatch_async(dispatch_get_main_queue(),
        ^{
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
                    NSDictionary *results = object;
                    NSDictionary *dataNew=[results valueForKey:@"data"];
                    NSArray *dataNew2=[dataNew valueForKey:@"children"];
                    [self.loadDelegate updateCount:dataNew2.count];
                    [self.loadDelegate receivedData:dataNew2];
                    NSMutableArray *titlesAndThumbnails = [[NSMutableArray alloc]init];
                    for(int i=0; i< [dataNew2 count]; i++)
                    {
                        NSDictionary *temp =dataNew2[i];
                        NSDictionary *temp2 = [temp objectForKey:@"data"];
                        #ifdef DEBUGGING
                        NSLog(@"\n\n Title:%@\n\n",[temp2 objectForKey:@"title"]);
                        #endif
                        NSString *title = [temp2 objectForKey:@"title"];
                        #ifdef DEBUGGING
                        NSLog(@"\n\n Thumbnail:%@\n\n",[temp2 objectForKey:@"thumbnail"]);
                        #endif
                        NSString *thumbnail = [temp2 objectForKey:@"thumbnail"];
                        NSArray *titleAndThumbnail = [[NSArray alloc]init];
                        if([thumbnail isEqualToString:@""] || [thumbnail isEqualToString:@"self"]) // no thumbnail
                        {
                            titleAndThumbnail=@[title];
                            #ifdef DEBUGGING
                            NSLog(@"No thumbnail detected");
                            #endif
                            
                            // Save to Core Data Cache
                            TableEntry *newEntry = [TableEntry create];
                            newEntry.title = title;
                            [newEntry save];
       
                            
                        }
                        else
                        {
                            titleAndThumbnail=@[title,thumbnail];
                            
                            // Save to Core Data Cache
                            TableEntry *newEntry = [TableEntry create];
                            newEntry.title = title;
                            newEntry.thumbnail=thumbnail;
                            [newEntry save];
                     
                        }
                        [titlesAndThumbnails addObject:titleAndThumbnail];
                        
                    }
                
                    
             
            self.titlesAndThumbnails=titlesAndThumbnails;
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

@end
