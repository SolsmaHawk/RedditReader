//
//  ViewController.h
//  CodeSample
//
//  Copyright (c) 2014 Golden Frog, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataReceiver.h"

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, DataReceiver>

@end
