//
//  ViewController.m
//  CodeSample
//  Edited by: John Solsma
//  Copyright (c) 2014 Golden Frog, Inc. All rights reserved.
//

#import "ViewController.h"
#import "DataLoader.h"
#import "GFTableViewCell.h"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
@interface ViewController ()
@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *tableData;
@property(nonatomic, strong) DataLoader *data;
@property NSUInteger tableCount;
@property (strong, nonatomic) IBOutlet UITextField *searchBar;
@property NSMutableArray *tableDataSource;
@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self refreshDataOnStartup:YES];
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
                dispatch_async(kBgQueue, ^{
                    NSData *imgData = [NSData dataWithContentsOfURL:imagePath];
                    if (imgData) {
                        UIImage *image = [UIImage imageWithData:imgData];
                        if (image) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                newCell.loadingIndicator.hidden=YES;
                                GFTableViewCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                                if (updateCell)
                                    updateCell.thumbnailImage.image = image;
                            });
                        }
                    }
                });
            }
    }

    return newCell;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data.titlesAndThumbnails count];
}

#pragma mark UITableViewDelegate



#pragma mark Helper Methods

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

- (void)refreshDataOnStartup:(BOOL)startup
{
    self.data = [[DataLoader alloc] dataLoaderWithDelegate:self];
    NSString *searchTextConcatonatedWithUnderscores = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    self.data.searchTerm=searchTextConcatonatedWithUnderscores;
    [self.data getDataAndupdateTableView:self.tableView onStartup:startup];
    
}

#pragma mark Action Methods

- (IBAction)refreshAction:(id)sender {
    
    if([self.searchBar.text isEqualToString:@""])
    {
        NSLog(@"No search term entered into search bar");
    }
    else
    {
        [self refreshDataOnStartup:NO];
    }


}

#pragma mark Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self refreshDataOnStartup:NO];
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
