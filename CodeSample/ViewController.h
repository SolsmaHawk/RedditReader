//
//  ViewController.h
//  CodeSample
//  Edited by: John Solsma
//  Copyright (c) 2014 Golden Frog, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataReceiver.h"

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, DataReceiver, UITextFieldDelegate>

@end
