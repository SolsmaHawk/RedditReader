//
//  GFTableViewCell.h
//  CodeSample
//  Edited by: John Solsma


#import <UIKit/UIKit.h>

@interface GFTableViewCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIImageView *thumbnailImage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end
