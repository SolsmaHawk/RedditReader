//
//  DataReceiver.h
//  CodeSample


#import <Foundation/Foundation.h>

@protocol DataReceiver<NSObject>

-(void)receivedData:(NSArray *)data;
-(void)updateCount:(NSUInteger)newCount;

@end