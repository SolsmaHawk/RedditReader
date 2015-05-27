//
//  LoadCounter.h
//  CodeSample
//


#import <Foundation/Foundation.h>

@protocol LoadCounter <NSObject>
- (void)loadCountUpdated:(NSUInteger)count;
@end
