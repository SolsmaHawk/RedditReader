//
//  GFTableViewCell.h
//  CodeSample
//
//  Copyright (c) 2014 Golden Frog, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFTableViewCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIImageView *thumbnailImage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end
