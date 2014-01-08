//
//  MainMenu.m
//  Tic Tac Toe
//
//  Created by MacUser on 1/28/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "MainMenu.h"
#import "ViewController.h"

@implementation MainMenu

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)newLocalGame:(id)sender
{
    ViewController *vc = [[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil isOnline:NO];
    [self presentModalViewController:vc animated:YES];
    //[self.navigationController pushViewController:[[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil] animated:YES];
}

-(IBAction)newOnlineGame:(id)sender
{
    ViewController *vc = [[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil isOnline:YES];
    [self presentModalViewController:vc animated:YES];
    //[self.navigationController pushViewController:[[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil] animated:YES];
}
@end
