//
//  TableEntry.h
//  SampleProject
//
//  Created by John Solsma on 4/10/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>



@interface TableEntry : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * thumbnail;


@end
