//
//  ViewController.m
//  UniMarble
//
//  Created by Kiran_నాని on 28-03-11.
//  Copyright (c) 2011 ipap. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    holeBounds = [[NSArray alloc]initWithObjects:
                        @"2",@"3",@"4",
                        @"12",@"13",@"14",
            @"20",@"21",@"22",@"23",@"24",@"25",@"26",
            @"30",@"31",@"32",@"33",@"34",@"35",@"36",
            @"40",@"41",@"42",@"43",@"44",@"45",@"46",
                        @"52",@"53",@"54",
                        @"62",@"63",@"64", nil];
    
    //tap gesture for holes
    for (Holes *holes in self.view.subviews)
    {
        if (holes.tag >= 2 && holes.tag <= 64) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
            [holes addGestureRecognizer:tap];
            [tap release];
            
            // making all holes with objects
            holes.containsBall = YES;
           
          //  NSLog(@"%d -> %d",holes.tag,holes.containsBall);
        }
    }
    // making middle hole with no object
    ((Holes *)[self.view viewWithTag:33]).containsBall = NO;
    
    //pan gesture for balls
    for (UIImageView *balls in self.view.subviews)
    {
        if (balls.tag >= 111 && balls.tag <= 142) {
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
            [balls addGestureRecognizer:pan];
            [pan release];
        }
    }	
}

-(void) handleTap:(UITapGestureRecognizer *) sender
{
        NSLog(@"-------tap---------");
    int tag = ((Holes *)sender.view).tag;
    
    if ([self containsBall:tag at:@"right"]) {
        NSLog(@"glow right");
    }
    if ([self containsBall:tag at:@"left"]) {
        NSLog(@"glow left");
    }
    if ([self containsBall:tag at:@"up"]) {
        NSLog(@"glow up");
    }
    if ([self containsBall:tag at:@"down"]) {
        NSLog(@"glow down");
    }
}


-(BOOL) containsBall:(int)tag at:(NSString *)direction
{
    int nextTag = [self requiredTag:tag inDirection:direction];
    if ([self checkingBall:nextTag]) {
        return [self checkingBall:[self requiredTag:nextTag inDirection:direction]];
    }
    return  NO;
}


-(void) handlePan:(UIPanGestureRecognizer *) sender
{
    
    //[sender.view bringSubviewToFront:self.view];

    CGPoint translation  = [sender translationInView:sender.view];
    sender.view.center = CGPointMake(sender.view.center.x + translation.x, sender.view.center.y + translation.y);
    [sender setTranslation:CGPointMake(0,0) inView:sender.view];
    
}


-(BOOL) checkingBall:(int)tag
{
    if ([self isValidHole:tag]){
        return (((Holes *)[self.view viewWithTag:tag]).containsBall);
    }
    else
        return NO;
    
}

-(int) requiredTag:(int)tag inDirection:(NSString *)direction
{
    
    if (direction == @"right")
        return tag + 1;
    else if (direction == @"left")
        return tag - 1;
    else if (direction == @"up")
        return tag - 10;
    else
        return tag + 10;
}

-(BOOL) isValidHole:(int) tag
{
    return [holeBounds containsObject:[NSString stringWithFormat:@"%d",tag]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [holeBounds release];
    [super dealloc];
}
@end
