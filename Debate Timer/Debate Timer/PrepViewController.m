//
//  PrepViewController.m
//  Debate Timer
//
//  Created by Cormac Chester on 3/20/14.
//  Copyright (c) 2014 Testman Industries. All rights reserved.
//

#import "PrepViewController.h"
#import "ViewController.h"

@interface PrepViewController ()

@end

@implementation PrepViewController

@synthesize yourPrepButton, theirPrepButton, yourPrepLabel, theirPrepLabel, yourPrepTimer, theirPrepTimer, storeData;

BOOL isPrepStarted = NO;
BOOL isPrepPaused = NO;

//Your prep
int yourCountUpCentiseconds = 0;
int yourCentiseconds;
int yourSeconds;
int yourMinutes;

//Their prep
int theirCentiseconds;
int theirSeconds;
int theirMinutes;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    storeData = [NSUserDefaults standardUserDefaults];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"goneHome"])
    {
        yourCountUpCentiseconds = 0;
        isPrepStarted = NO;
        isPrepPaused = NO;
        NSLog(@"Resetting prep time");
    }
    else
    {
        yourCountUpCentiseconds = [storeData integerForKey:@"yourCentiseconds"];
        NSLog(@"Using old timing data");
        isPrepStarted = YES;
        isPrepPaused = YES;
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"goneHome"];
    
    yourCentiseconds = yourCountUpCentiseconds % 100;
    yourSeconds = (yourCountUpCentiseconds / 100) % 60;
    yourMinutes = (yourCountUpCentiseconds / 100) / 60;
    
    if (yourCountUpCentiseconds != 0)
    {
        [yourPrepButton setTitle:@"Resume" forState:UIControlStateNormal];
    }
    else
    {
        [yourPrepButton setTitle:@"Start" forState:UIControlStateNormal];
    }
    
    //Determines if centiseconds are shown
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isCenti"])
    {
        self.yourPrepLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", yourMinutes, yourSeconds, yourCentiseconds];
        NSLog(@"Showing centiseconds");
    }
    else if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isCenti"])
    {
        self.yourPrepLabel.text = [NSString stringWithFormat:@"%02d:%02d", yourMinutes, yourSeconds];
        NSLog(@"Not showing centiseconds");
    }
}

- (void)runYourTimer
{
    self.yourPrepTimer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(updateYourLabel:) userInfo:nil repeats:YES];
}

- (void)updateYourLabel:(NSTimer *)timer
{
    yourCountUpCentiseconds ++;
    yourCentiseconds = yourCountUpCentiseconds % 100;
    yourSeconds = (yourCountUpCentiseconds / 100) % 60;
    yourMinutes = (yourCountUpCentiseconds / 100) / 60;
    
    //Determines if centiseconds are shown
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isCenti"])
    {
        self.yourPrepLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", yourMinutes, yourSeconds, yourCentiseconds];
    }
    else if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isCenti"])
    {
        self.yourPrepLabel.text = [NSString stringWithFormat:@"%02d:%02d", yourMinutes, yourSeconds];
    }

    [storeData setInteger:yourCountUpCentiseconds forKey:@"yourCentiseconds"];
    NSLog(@"Your total prep time in centiseconds: %i", yourCountUpCentiseconds);
}

- (IBAction)yourPrepButtonTap:(id)sender
{
    if (!isPrepStarted)
    {
        [self runYourTimer];
        [yourPrepButton setTitle:@"Pause" forState:UIControlStateNormal];
        isPrepStarted = YES;
    }
    else if (!isPrepPaused)
    {
        [self pauseYourTimer];

    }
    else if (isPrepPaused)
    {
        [self resumeYourTimer];
    }
}

- (IBAction)theirPrepButtonTap:(id)sender
{
    
}

//Pauses timer
- (void)pauseYourTimer
{
    //[self.yourPrepTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:31536000]];
    [self.yourPrepTimer invalidate];
    [yourPrepButton setTitle:@"Resume" forState:UIControlStateNormal];
    isPrepPaused = YES;
    NSLog(@"Paused timer");
}

//Resumes timer
- (void)resumeYourTimer
{
    //[self.yourPrepTimer setFireDate:[NSDate date]];
    [self runYourTimer];
    [yourPrepButton setTitle:@"Pause" forState:UIControlStateNormal];
    isPrepPaused = NO;
    NSLog(@"Resume timer");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     
    [self pauseYourTimer];
 }


@end
