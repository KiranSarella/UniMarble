//
//  ViewController.m
//  UniMarble
//
//  Created by Kiran_నాని on 28-03-11.
//  Copyright (c) 2011 ipap. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    int betweenTag;
    int FromTag;
    int ToTag;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    holeNumber = [[NSArray alloc]initWithObjects:
                        @"2", @"3", @"4",
                        @"12",@"13",@"14",
            @"20",@"21",@"22",@"23",@"24",@"25",@"26",
            @"30",@"31",@"32",@"33",@"34",@"35",@"36",
            @"40",@"41",@"42",@"43",@"44",@"45",@"46",
                        @"52",@"53",@"54",
                        @"62",@"63",@"64", nil];
    
    //tap gesture for holes
    for (UIImageView *holes in self.view.subviews)
    {
        if (holes.tag >= 2 && holes.tag <= 64)
        {
            
            // TapGesture for Holes
            UITapGestureRecognizer *tapForHole = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapForHole:)];
            [holes addGestureRecognizer:tapForHole];
            [tapForHole release];
            
            
            
            
            // creating a marble and making subview to hole.
            if (holes.tag != 33)
            {
            UIImageView *marble = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
            marble.image = [UIImage imageNamed:@"Marble.png"];
            marble.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
            [marble addGestureRecognizer:tap];
            [holes addSubview:marble];
            [tap release];
            
            }
        }
    }
}



#pragma mark - handles Holes

-(void) handleTapForHole:(UITapGestureRecognizer *) sender
{
    NSLog(@"backGround:%@",((UIImageView *)sender.view).backgroundColor);
    if ( ((UIImageView *)sender.view).backgroundColor != nil )
    {
              NSLog(@"%d -> no of balls:%d",FromTag,[[[self.view viewWithTag:FromTag] subviews] count]);
        
        
         UIImageView *buffer =  [[[[self.view viewWithTag:FromTag] subviews] objectAtIndex:0] retain];
        [((UIImageView *)[[[self.view viewWithTag:FromTag] subviews] objectAtIndex:0]) removeFromSuperview];
        [(UIImageView *)sender.view addSubview:buffer];
    
        int between = ((UIImageView *)sender.view).tag - FromTag;
        NSLog(@"bet:%d",between);
        switch (between) {
            case -2:
                betweenTag = ((UIImageView *)sender.view).tag + 1;
                break;
            case 2:
                betweenTag = ((UIImageView *)sender.view).tag - 1;
                break;
            case -20:
                betweenTag = ((UIImageView *)sender.view).tag + 10;
                break;
            case 20:
                betweenTag = ((UIImageView *)sender.view).tag - 10;
                break;
            default:
                break;
        }
        
        
        [((UIImageView *)[[[self.view viewWithTag:betweenTag] subviews] objectAtIndex:0]) removeFromSuperview];
        
        for (UIImageView *holes in self.view.subviews)
        {
            if (holes.tag >= 2 && holes.tag <= 64)
            {
                holes.backgroundColor = nil;
            }
        }
    }
    else
    {
        for (UIImageView *holes in self.view.subviews)
        {
            if (holes.tag >= 2 && holes.tag <= 64)
            {
                holes.backgroundColor = nil;
            }
        }

        for (UIImageView *holes in self.view.subviews)
        {
            if (holes.tag >= 2 && holes.tag <= 64)
            {
                if([[holes subviews] count]!=0)
                {
                    ((UIImageView *)[[holes subviews] objectAtIndex:0]).backgroundColor = nil;
                }
            }
        }

        
        int tag = ((UIImageView *)sender.view).tag;
        [self containsMarbleToGlow:tag at:@"right"];
        [self containsMarbleToGlow:tag at:@"left"];
        [self containsMarbleToGlow:tag at:@"up"];
        [self containsMarbleToGlow:tag at:@"down"];
    }
}

-(void) containsMarbleToGlow:(int)tag at:(NSString *)direction
{
    FromTag = tag;
    // going to the required direcion and return YES if hole contains marble
    betweenTag = [self requiredTag:FromTag inDirection:direction];
    if ([self isValidHole:betweenTag]){
        // checking for first level
        if ([self checkingForMarble:betweenTag]) {
            // checking for second level
            ToTag = [self requiredTag:betweenTag inDirection:direction];
            if ([self isValidHole:ToTag]){
                if ([self checkingForMarble:ToTag])
                {
                    ((UIImageView *)[[[self.view viewWithTag:ToTag] subviews] objectAtIndex:0]).backgroundColor = [UIColor blueColor];
                }
            }
        }
    }
    // return  NO;
}


#pragma mark - handles Marble


-(void) handleTap:(UITapGestureRecognizer *) sender
{
    
    // clearing all glowing holes
    for (UIImageView *holes in self.view.subviews)
    {
        if (holes.tag >= 2 && holes.tag <= 64)
        {
            holes.backgroundColor = nil;
        }
    }
    
    for (UIImageView *holes in self.view.subviews)
    {
        if (holes.tag >= 2 && holes.tag <= 64)
        {
            if([[holes subviews] count]!=0)
            {
                ((UIImageView *)[[holes subviews] objectAtIndex:0]).backgroundColor = nil;
            }
        }
    }

    
    NSLog(@"___________%@_____________",NSStringFromSelector(_cmd));
    int tag = [sender.view superview].tag;
    NSLog(@"tag:%d",tag);
    
    [self containsMarble:tag at:@"right"];
    [self containsMarble:tag at:@"left"];
    [self containsMarble:tag at:@"up"];
    [self containsMarble:tag at:@"down"];
    
//    
//    if ([self containsMarble:tag at:@"right"]) {
//        NSLog(@"glow right hole");
//    }
//    if ([self containsMarble:tag at:@"left"]) {
//        NSLog(@"glow left hole");
//    }
//    if ([self containsMarble:tag at:@"up"]) {
//        NSLog(@"glow up hole");
//    }
//    if ([self containsMarble:tag at:@"down"]) {
//        NSLog(@"glow down hole");
   // }
}



-(void) containsMarble:(int)tag at:(NSString *)direction
{
    FromTag = tag;
    // going to the required direcion and return YES if hole contains marble
    betweenTag = [self requiredTag:FromTag inDirection:direction];
    if ([self isValidHole:betweenTag]){
    // checking for first level
    if ([self checkingForMarble:betweenTag]) {
        // checking for second level
        ToTag = [self requiredTag:betweenTag inDirection:direction];
        if ([self isValidHole:ToTag]){
            if (![self checkingForMarble:ToTag])
            {
            [self.view viewWithTag:ToTag].backgroundColor = [UIColor brownColor];
        
       // return [self checkingForMarble:[self requiredTag:nextTag inDirection:direction]];
        }
        }
    }
    }
   // return  NO;
}


//-(void) handlePan:(UIPanGestureRecognizer *) sender
//{
//    
//    //[sender.view bringSubviewToFront:self.view];
//
//    CGPoint translation  = [sender translationInView:sender.view];
//    sender.view.center = CGPointMake(sender.view.center.x + translation.x, sender.view.center.y + translation.y);
//    [sender setTranslation:CGPointMake(0,0) inView:sender.view];
//    
//}


-(BOOL) checkingForMarble:(int)tag
{
      if([[[self.view viewWithTag:tag] subviews] count] == 0)
      {
          return NO;    // No marble
      }
      else
      {
          return YES;   // Contains marble
      }
}


// Giving required tag depending on direction.
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
    return [holeNumber containsObject:[NSString stringWithFormat:@"%d",tag]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [holeNumber release];
    [super dealloc];
}
@end
