//
//  ViewController.m
//  CodeSample
//
//  Copyright (c) 2014 Golden Frog, Inc. All rights reserved.
//

#import "ViewController.h"
#import "DataLoader.h"
#import "GFTableViewCell.h"

@interface ViewController ()
@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *tableData;
@property(nonatomic, strong) DataLoader *data;
@property NSUInteger tableCount;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refreshData];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GFTableViewCell *newCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    newCell.title.text = [self.tableData objectAtIndex:indexPath.row];

    return newCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableCount;
}

#pragma mark UITableViewDelegate

// TODO:

#pragma mark Helper Methods

- (void)refreshData
{
    self.data = [[DataLoader alloc] dataLoaderWithDelegate:self];
    _data.getData;
}

#pragma mark Action Methods

- (IBAction)refreshAction:(id)sender
{
    [self refreshData];
}

#pragma mark Delegate Methods

-(void)receivedData:(NSDictionary *)data
{
    for (NSDictionary *dict in data)
    {
        [self.tableData addObject:dict[@"data"][@"title"]];
    }
    
    [self.tableView reloadData];
}

-(void)updateCount:(NSUInteger)newCount
{
    self.tableCount = newCount;
}

@end
