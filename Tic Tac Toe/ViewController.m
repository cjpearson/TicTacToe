//
//  ViewController.m
//  Tic Tac Toe
//
//  Created by MacUser on 1/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

-(void) win:(NSString*) winner
{
    for (UIButton* myButton in buttons)
    {
        [myButton setEnabled:false];
    }
    
    [topLabel setText:[NSString stringWithFormat:@"%@ Wins!", winner]];
    
}
-(void) tie
{
    for (UIButton* myButton in buttons)
    {
        [myButton setEnabled:false];
    }
    
    [topLabel setText:[NSString stringWithFormat:@"Tie!"]];
}
-(void) checkWin
{
    //check for win
    NSString* buttonStates[9];
    
    //check for tie
    
    
    for(int i = 0; i<9; i++)
    {
        buttonStates[i] = [[buttons objectAtIndex:i] titleForState:UIControlStateNormal];
    }
    
    if(([buttonStates[0] isEqualToString:buttonStates[1]] && [buttonStates[0] isEqualToString:buttonStates[2]])
       || ([buttonStates[0] isEqualToString:buttonStates[3]] && [buttonStates[0] isEqualToString:buttonStates[6]]))
    {
        [self win:buttonStates[0]];
        return;
    }
    
    if(([buttonStates[4] isEqualToString:buttonStates[0]] && [buttonStates[4] isEqualToString:buttonStates[8]])
       || ([buttonStates[4] isEqualToString:buttonStates[1]] && [buttonStates[4] isEqualToString:buttonStates[7]])
       || ([buttonStates[4] isEqualToString:buttonStates[2]] && [buttonStates[4] isEqualToString:buttonStates[6]])
       || ([buttonStates[4] isEqualToString:buttonStates[3]] && [buttonStates[4] isEqualToString:buttonStates[5]]))
    {
        [self win:buttonStates[4]];
        return;
    }
    
    if(([buttonStates[8] isEqualToString:buttonStates[6]] && [buttonStates[8] isEqualToString:buttonStates[7]])
       || ([buttonStates[8] isEqualToString:buttonStates[2]] && [buttonStates[8] isEqualToString:buttonStates[5]]))
    {
        [self win:buttonStates[8]];
        return;
    }
    bool tie = true;
    for(int i=0; i<9; i++)
    {
        if(buttonStates[i] == nil)
        {
            tie = false;
        }
    }
    if(tie)
    {
        [self tie];
    }
    
    
}

-(void) connect
{
    //disable buttons so the user can't play
    for (UIButton* myButton in buttons)
    {
        [myButton setEnabled:false];
    }
    
    [topLabel setText:[NSString stringWithFormat:@"Connecting to server..."]];
    //connect to server
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"localhost", 8070, &readStream, &writeStream);
    inputStream = (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [outputStream open];
    
    [topLabel setText:[NSString stringWithFormat:@"Finding player..."]];
    //waits for player
    [topLabel setText:[NSString stringWithFormat:@"Ready to play"]];
    
    for (UIButton* myButton in buttons)
    {
        [myButton setEnabled:true];
    }
    
}
-(void) restart
{
    for (UIButton* myButton in buttons)
    {
        [myButton setEnabled:true];
        [myButton setTitle:nil forState:UIControlStateNormal];
    }
    
    [topLabel setText:[NSString stringWithFormat:@"Tic Tac Toe"]];
    XOIndex = 0;
    
    
}
-(IBAction)restartButton:(id)sender
{
    [self restart];
    if(isOnline)
    {
        NSString *response  = [NSString stringWithFormat:@"move:%d", 10];
        NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
        [outputStream write:[data bytes] maxLength:[data length]];
    }
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
	switch (streamEvent) {
            
		case NSStreamEventOpenCompleted:
			NSLog(@"Stream opened");
			break;
            
		case NSStreamEventHasBytesAvailable:
            if (theStream == inputStream) {
                
                uint8_t buffer[1024];
                int len;
                
                while ([inputStream hasBytesAvailable]) 
                {
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) 
                    {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        
                        if (nil != output) {
                            NSLog(@"Server said:%@", output);
                            
                            //convert to int
                            if([output intValue] == 10)
                            {
                                [self restart];
                            }
                            else
                            {
                                UIButton *sender = [buttons objectAtIndex:[output intValue]];
                                if(XOIndex == 0)
                                {
                                    [sender setTitle:@"X"forState:UIControlStateNormal];
                                    XOIndex = 1;
                                }
                                else
                                {
                                    [sender setTitle:@"0"forState:UIControlStateNormal];
                                    XOIndex = 0;
                                }
                                //enable the buttons for the player
                                for (UIButton* myButton in buttons)
                                {
                                    [myButton setEnabled:true];
                                }
                                [self checkWin];
                            }
                            

                        }
                        
                        
                    }
                    
                }
            }
			break;			
            
		case NSStreamEventErrorOccurred:
			NSLog(@"Can not connect to the host!");
			break;
            
		case NSStreamEventEndEncountered:
			break;
            
		default:
			NSLog(@"Unknown event");
	}
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (isOnline) 
    {
        [self connect];
    }
}

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isOnline:(BOOL) online
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    XOIndex = 0;
    isOnline = online;
    
    return self;
}





-(IBAction)buttonPress:(id)sender
{
    if (nil == [sender titleForState:UIControlStateNormal])
    {
        if(XOIndex == 0)
        {
            [sender setTitle:@"X"forState:UIControlStateNormal];
            XOIndex = 1;
        }
        else
        {
            [sender setTitle:@"0"forState:UIControlStateNormal];
            XOIndex = 0;
        }
    }
    //find what button was clicked and send its index
    if(isOnline)
    {
        for(int i = 0; i<9; i++)
        {
            if([buttons objectAtIndex:i]==sender)
            {
                NSString *response  = [NSString stringWithFormat:@"move:%d", i];
                NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
                [outputStream write:[data bytes] maxLength:[data length]];
            }
        }
    }
    
    [self checkWin];
    //disable buttons if online and let the other person play
    
    if(isOnline)
    {
        for (UIButton* myButton in buttons)
        {
            [myButton setEnabled:false];
        }
    }
    
}
@synthesize buttons;
@end
