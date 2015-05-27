//
//  ViewController.h
//  CodeSample
//  Edited by: John Solsma


#import <UIKit/UIKit.h>

#import "DataReceiver.h"

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, DataReceiver, UITextFieldDelegate>

@end
