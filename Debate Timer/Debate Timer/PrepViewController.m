//
//  PrepViewController.m
//  Debate Timer
//
//  Created by Cormac Chester on 3/20/14.
//  Copyright (c) 2014 Extreme Images Inc. All rights reserved.
//

#import "PrepViewController.h"
#import "ViewController.h"
#import "PlaySound.h"

@interface PrepViewController ()

@end

@implementation PrepViewController

@synthesize yourPrepButton, theirPrepButton, yourPrepLabel, theirPrepLabel, yourPrepTimer, theirPrepTimer, storeData, affNameLabel, negNameLabel;

BOOL yourPrep;
BOOL theirPrep;

BOOL isYourPrepStarted = NO;
BOOL isYourPrepPaused = NO;

BOOL isTheirPrepStarted = NO;
BOOL isTheirPrepPaused = NO;

//Your prep
int yourPrepCentiseconds = 0;
int yourCentiseconds;
int yourSeconds;
int yourMinutes;

//Their prep
int theirPrepCentiseconds = 0;
int theirCentiseconds;
int theirSeconds;
int theirMinutes;

int styleChosen = 0;

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
    
    styleChosen = (int)[storeData integerForKey:@"styleKey"];
    
    prepValue = (int)[storeData integerForKey:@"prepValue"];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"shouldResetPrep"])
    {
        //Resets prep time if you have gone to the home screen
        [self resetYourPrep];
        [self resetTheirPrep];
        
        NSLog(@"New prep times");
    }
    else
    {
        //Your prep time
        yourPrepCentiseconds = (int)[storeData integerForKey:@"yourCentiseconds"];
        NSLog(@"yourPrepCentiseconds: %i", yourPrepCentiseconds);
        
        int prepChecker = prepValue*6000;
        
        NSLog(@"PrepChecker: %i, PrepValue: %i", prepChecker, prepValue);
        
        if (yourPrepCentiseconds < prepChecker)
        {
            isYourPrepStarted = YES;
            isYourPrepPaused = YES;
        }
        else
        {
            isYourPrepStarted = NO;
            isYourPrepPaused = NO;
            NSLog(@"Your Prep hasn't started");
        }
        
        //Their prep time
        theirPrepCentiseconds = (int)[storeData integerForKey:@"theirCentiseconds"];
        if (theirPrepCentiseconds < prepChecker)
        {
            isTheirPrepStarted = YES;
            isTheirPrepPaused = YES;
        }
        else
        {
            isTheirPrepStarted = NO;
            isTheirPrepPaused = NO;
            NSLog(@"Their Prep hasn't started");
        }
        
        NSLog(@"Using old prep time");

    }
    
    //Convert your centiseconds
    yourCentiseconds = yourPrepCentiseconds % 100;
    yourSeconds = (yourPrepCentiseconds / 100) % 60;
    yourMinutes = (yourPrepCentiseconds / 100) / 60;
    
    //Convert their centiseconds
    theirCentiseconds = theirPrepCentiseconds % 100;
    theirSeconds = (theirPrepCentiseconds / 100) % 60;
    theirMinutes = (theirPrepCentiseconds / 100) / 60;
    
    //Set prep button titles
    [self setYourButton];
    [self setTheirButton];
    
    //Determines if centiseconds are shown
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isCenti"])
    {
        self.yourPrepLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", yourMinutes, yourSeconds, yourCentiseconds];
        self.theirPrepLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", theirMinutes, theirSeconds, theirCentiseconds];
        NSLog(@"Showing centiseconds");
    }
    else if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isCenti"])
    {
        self.yourPrepLabel.text = [NSString stringWithFormat:@"%02d:%02d", yourMinutes, yourSeconds];
        self.theirPrepLabel.text = [NSString stringWithFormat:@"%02d:%02d", theirMinutes, theirSeconds];
        NSLog(@"Not showing centiseconds");
    }
    
    if (styleChosen == 0 || styleChosen == 1)
    {
        affNameLabel.text = @"Aff Prep Time";
        negNameLabel.text = @"Neg Prep Time";
    }
    else if (styleChosen == 2)
    {
        affNameLabel.text = @"Pro Prep Time";
        negNameLabel.text = @"Con Prep Time";
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"shouldResetPrep"];
}

 #pragma mark - Your Prep Time
- (void)runYourTimer
{
    self.yourPrepTimer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(updateYourLabel:) userInfo:nil repeats:YES];
}
- (void)updateYourLabel:(NSTimer *)timer
{
    if (yourPrepCentiseconds > 0)
    {
        yourPrepCentiseconds --;
        yourCentiseconds = yourPrepCentiseconds % 100;
        yourSeconds = (yourPrepCentiseconds / 100) % 60;
        yourMinutes = (yourPrepCentiseconds / 100) / 60;
        
        //Sets your label
        [self setYourLabel];
        
        [storeData setInteger:yourPrepCentiseconds forKey:@"yourCentiseconds"];
    }
    else
    {
        UIAlertView *yourAlert = [[UIAlertView alloc] initWithTitle:@"Your prep done" message:@"Your prep time is finished" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [yourAlert show];
        
        [PlaySound playSound];
        
        [self.yourPrepTimer invalidate];
        NSLog(@"Your prep time is finished");

        [self resetYourPrep];
        
    }
}
- (void)setYourLabel
{
    //Determines if centiseconds are shown
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isCenti"])
    {
        self.yourPrepLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", yourMinutes, yourSeconds, yourCentiseconds];
    }
    else if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isCenti"])
    {
        self.yourPrepLabel.text = [NSString stringWithFormat:@"%02d:%02d", yourMinutes, yourSeconds];
    }
}
- (void)setYourButton
{
    if (isYourPrepStarted)
    {
        [yourPrepButton setTitle:@"Resume" forState:UIControlStateNormal];
    }
    else
    {
        [yourPrepButton setTitle:@"Start" forState:UIControlStateNormal];
    }
}
- (IBAction)yourPrepButtonTap:(id)sender
{
    if (!isYourPrepStarted)
    {
        [self runYourTimer];
        [yourPrepButton setTitle:@"Pause" forState:UIControlStateNormal];
        isYourPrepStarted = YES;
        
        if (isTheirPrepStarted)
        {
            [self pauseTheirTimer];
        }
    }
    else if (!isYourPrepPaused)
    {
        [self pauseYourTimer];

    }
    else if (isYourPrepPaused)
    {
        [self resumeYourTimer];
        
        if (isTheirPrepStarted)
        {
            [self pauseTheirTimer];
        }
        
    }
}
//Pauses your timer
- (void)pauseYourTimer
{
    [self.yourPrepTimer invalidate];
    [yourPrepButton setTitle:@"Resume" forState:UIControlStateNormal];
    isYourPrepPaused = YES;
    NSLog(@"Pauses your timer");
}
//Resumes your timer
- (void)resumeYourTimer
{
    [self runYourTimer];
    [yourPrepButton setTitle:@"Pause" forState:UIControlStateNormal];
    isYourPrepPaused = NO;
    NSLog(@"Resumes your timer");
}
- (void)resetYourPrep
{
    [self.yourPrepTimer invalidate];
    
    prepValue = (int)[storeData integerForKey:@"prepValue"];
    [storeData setInteger:prepValue forKey:@"prepValue"];
    
    yourPrepCentiseconds = prepValue * 6000;
    yourMinutes = prepValue;
    yourSeconds = 0;
    yourCentiseconds = 0;
    [storeData setInteger:yourPrepCentiseconds forKey:@"yourCentiseconds"];
    isYourPrepStarted = NO;
    isYourPrepPaused = NO;
    [self setYourLabel];
    [yourPrepButton setTitle:@"Start" forState:UIControlStateNormal];
}
- (IBAction)resetYourPrepTap:(id)sender
{
    [self resetYourPrep];
    NSLog(@"Reset your prep");
}


 #pragma mark - Their Prep Time
//Runs their timer
- (void)runTheirTimer
{
    self.theirPrepTimer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(updateTheirLabel:) userInfo:nil repeats:YES];
}
- (void)updateTheirLabel:(NSTimer *)timer
{
    if (theirPrepCentiseconds > 0)
    {
        theirPrepCentiseconds --;
        theirCentiseconds = theirPrepCentiseconds % 100;
        theirSeconds = (theirPrepCentiseconds / 100) % 60;
        theirMinutes = (theirPrepCentiseconds / 100) / 60;
        
        //Sets their label
        [self setTheirLabel];
        
        [storeData setInteger:theirPrepCentiseconds forKey:@"theirCentiseconds"];
    }
    else
    {
        UIAlertView *theirAlert = [[UIAlertView alloc] initWithTitle:@"Their prep done" message:@"Their prep time is finished" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [theirAlert show];
        
        [PlaySound playSound];
        
        [self.theirPrepTimer invalidate];
        NSLog(@"Their prep times is finished");
        
        [self resetTheirPrep];
    }

}
- (void)setTheirLabel
{
    //Determines if centiseconds are shown
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isCenti"])
    {
        self.theirPrepLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", theirMinutes, theirSeconds, theirCentiseconds];
    }
    else if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isCenti"])
    {
        self.theirPrepLabel.text = [NSString stringWithFormat:@"%02d:%02d", theirMinutes, theirSeconds];
    }
}
- (void)setTheirButton
{
    if (isTheirPrepStarted)
    {
        [theirPrepButton setTitle:@"Resume" forState:UIControlStateNormal];
    }
    else
    {
        [theirPrepButton setTitle:@"Start" forState:UIControlStateNormal];
    }
}
- (IBAction)theirPrepButtonTap:(id)sender
{
    if (!isTheirPrepStarted)
    {
        [self runTheirTimer];
        [theirPrepButton setTitle:@"Pause" forState:UIControlStateNormal];
        isTheirPrepStarted = YES;
        
        if (isYourPrepStarted)
        {
            [self pauseYourTimer];
        }
    }
    else if (!isTheirPrepPaused)
    {
        [self pauseTheirTimer];
        
    }
    else if (isTheirPrepPaused)
    {
        [self resumeTheirTimer];
        
        if (isYourPrepStarted)
        {
           [self pauseYourTimer];
        }
        
    }
}
//Pauses their timer
- (void)pauseTheirTimer
{
    [self.theirPrepTimer invalidate];
    [theirPrepButton setTitle:@"Resume" forState:UIControlStateNormal];
    isTheirPrepPaused = YES;
    NSLog(@"Pauses their timer");
}
//Resumes their timer
- (void)resumeTheirTimer
{
    [self runTheirTimer];
    [theirPrepButton setTitle:@"Pause" forState:UIControlStateNormal];
    isTheirPrepPaused = NO;
    NSLog(@"Resumes their timer");
}
- (void)resetTheirPrep
{
    [self.theirPrepTimer invalidate];
    
    prepValue = (int)[storeData integerForKey:@"prepValue"];
    [storeData setInteger:prepValue forKey:@"prepValue"];
    
    theirPrepCentiseconds = prepValue * 6000;
    theirMinutes = prepValue;
    theirSeconds = 0;
    theirCentiseconds = 0;
    [storeData setInteger:theirPrepCentiseconds forKey:@"theirCentiseconds"];
    isTheirPrepStarted = NO;
    isTheirPrepPaused = NO;
    [self setTheirLabel];
    [theirPrepButton setTitle:@"Start" forState:UIControlStateNormal];
}
- (IBAction)resetTheirPrepTap:(id)sender
{
    [self resetTheirPrep];
    NSLog(@"Reset their prep");
}

- (IBAction)backButtonTap:(id)sender
{
    [self performSegueWithIdentifier:@"segueFromPrep" sender:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        [PlaySound stopSound];
    }
    NSLog(@"Alert has been dismissed");
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
    [self pauseTheirTimer];
 }


@end
