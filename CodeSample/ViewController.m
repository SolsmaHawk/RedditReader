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
@property (strong, nonatomic) IBOutlet UITextField *searchBar;
@property NSMutableArray *tableDataSource;


@end

@implementation ViewController
@synthesize managedObjectContext = _managedObjectContext;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchBar.delegate = self;
    
    /*
    self.stack = [CoreDataStack coreDataStackWithModelName:@"CodeSampleDataModel"];
    NSEntityDescription* entityDesc = [self.stack entityForClass:[_tableData class]];
    
    NSManagedObject *mo = [NSEntityDescription insertNewObjectForEntityForName:@"TableData"
                                                        inManagedObjectContext:self.stack.managedObjectContext];
   // [mo setValue:@"doog" forKey:@"headlines"];
   // id aValue=[mo valueForKey:@"aKeyName"];

   NSDictionary *attributes = [[mo entity] attributesByName];
    */
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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
    
    newCell.loadingIndicator.hidden=YES;
    newCell.title.numberOfLines=0;
    newCell.title.adjustsFontSizeToFitWidth=YES;
    
    if([self.data.titlesAndThumbnails count]==0)
    {
    }
    else
    {
        newCell.title.text = self.data.titlesAndThumbnails[indexPath.row][0];
        
        newCell.thumbnailImage.image=nil;
        if([self.data.titlesAndThumbnails[indexPath.row] count]==2) // this article has a thumbnail
            {
                newCell.loadingIndicator.hidden=NO;
                NSString *ImageURL = self.data.titlesAndThumbnails[indexPath.row][1];
                NSURL *imagePath = [[NSURL alloc]initWithString:ImageURL];
                [self loadFromURL:imagePath toImageView:newCell.thumbnailImage withIndicator:newCell.loadingIndicator];
            }
    }

    return newCell;
}

-(void) loadFromURL: (NSURL*) url toImageView:(UIImageView *)imageView withIndicator:(UIActivityIndicatorView *)indicator
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            indicator.hidden=YES;
            UIImage *loadedImage = [UIImage imageWithData:imageData];
            imageView.image=loadedImage;
        });
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data.titlesAndThumbnails count];
}

#pragma mark UITableViewDelegate

// TODO:

#pragma mark Helper Methods

- (void)refreshData
{
    self.data = [[DataLoader alloc] dataLoaderWithDelegate:self];
    NSString *searchTextConcatonatedWithUnderscores = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    self.data.searchTerm=searchTextConcatonatedWithUnderscores;
    [self.data getDataAndupdateTableView:self.tableView];
    
    
    //[self.tableView reloadData];
    
}

#pragma mark Action Methods

- (IBAction)refreshAction:(id)sender {
    
    if([self.searchBar.text isEqualToString:@""])
    {
        NSLog(@"No search term entered into search bar");
    }
    else
    {
        [self refreshData];
    }


}


#pragma mark Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self refreshData];
    return YES;
}

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
