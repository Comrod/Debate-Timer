//
//  PlaySound.m
//  Debate Timer
//
//  Created by Cormac Chester on 6/2/14.
//  Copyright (c) 2014 Testman Industries. All rights reserved.
//

#import "PlaySound.h"
#import "AKSystemSound.h"

@implementation PlaySound

+ (void)playSound
{
    [[AKSystemSound soundWithName:@"alarm"] play];
    NSLog(@"Played sound");
}

+ (void)stopSound
{
    [AKSystemSound freeSoundWithName:@"alarm"];
}

@end
