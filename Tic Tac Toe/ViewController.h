//
//  ViewController.h
//  Tic Tac Toe
//
//  Created by MacUser on 1/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController  <NSStreamDelegate>
{
    NSArray *buttons;
    int XOIndex;
    IBOutlet UILabel *topLabel;
    bool isOnline;
    
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    
}
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isOnline:(BOOL) online;
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *buttons;
@end
