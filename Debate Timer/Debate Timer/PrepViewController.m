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

@synthesize yourPrepButton, theirPrepButton, yourPrepLabel, theirPrepLabel, yourPrepTimer, theirPrepTimer, storeData, affNameLabel, negNameLabel;

BOOL isYourPrepStarted = NO;
BOOL isYourPrepPaused = NO;

BOOL isTheirPrepStarted = NO;
BOOL isTheirPrepPaused = NO;

//Your prep
int yourCountUpCentiseconds = 0;
int yourCentiseconds;
int yourSeconds;
int yourMinutes;

//Their prep
int theirCountUpCentiseconds = 0;
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
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"goneHome"])
    {
        //Resets prep time if you have gone to the home screen
        [self resetYourPrep];
        [self resetTheirPrep];
    }
    else
    {
        //Your prep time
        yourCountUpCentiseconds = (int)[storeData integerForKey:@"yourCentiseconds"];
        isYourPrepStarted = YES;
        isYourPrepPaused = YES;
        
        //Their prep time
        theirCountUpCentiseconds = (int)[storeData integerForKey:@"theirCentiseconds"];
        isTheirPrepStarted = YES;
        isTheirPrepPaused = YES;
        
        NSLog(@"Using old timing data");
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"goneHome"];
    
    //Convert your centiseconds
    yourCentiseconds = yourCountUpCentiseconds % 100;
    yourSeconds = (yourCountUpCentiseconds / 100) % 60;
    yourMinutes = (yourCountUpCentiseconds / 100) / 60;
    
    //Convert their centiseconds
    theirCentiseconds = theirCountUpCentiseconds % 100;
    theirSeconds = (theirCountUpCentiseconds / 100) % 60;
    theirMinutes = (theirCountUpCentiseconds / 100) / 60;
    
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
    
    if (styleChosen == 1 || styleChosen == 2)
    {
        affNameLabel.text = @"Aff Prep Time";
        negNameLabel.text = @"Neg Prep Time";
    }
    else if (styleChosen == 3)
    {
        affNameLabel.text = @"Pro Prep Time";
        negNameLabel.text = @"Con Prep Time";
    }
}

 #pragma mark - Your Prep Time
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
    
    //Sets your label
    [self setYourLabel];

    [storeData setInteger:yourCountUpCentiseconds forKey:@"yourCentiseconds"];
    //NSLog(@"Your total prep time in centiseconds: %i", yourCountUpCentiseconds);
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
    if (yourCountUpCentiseconds > 0)
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
    }
    else if (!isYourPrepPaused)
    {
        [self pauseYourTimer];

    }
    else if (isYourPrepPaused)
    {
        [self resumeYourTimer];
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
    yourCountUpCentiseconds = 0;
    [storeData setInteger:yourCountUpCentiseconds forKey:@"yourCentiseconds"];
    isYourPrepStarted = NO;
    isYourPrepPaused = NO;
    yourMinutes = 0;
    yourSeconds = 0;
    yourCentiseconds = 0;
    [self setYourLabel];
    [yourPrepButton setTitle:@"Start" forState:UIControlStateNormal];
    NSLog(@"Resetting your prep time");
}
- (IBAction)resetYourPrepTap:(id)sender
{
    [self.yourPrepTimer invalidate];
    [self resetYourPrep];
}


 #pragma mark - Their Prep Time
//Runs their timer
- (void)runTheirTimer
{
    self.theirPrepTimer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(updateTheirLabel:) userInfo:nil repeats:YES];
}
- (void)updateTheirLabel:(NSTimer *)timer
{
    theirCountUpCentiseconds ++;
    theirCentiseconds = theirCountUpCentiseconds % 100;
    theirSeconds = (theirCountUpCentiseconds / 100) % 60;
    theirMinutes = (theirCountUpCentiseconds / 100) / 60;

    //Sets their label
    [self setTheirLabel];
    
    [storeData setInteger:theirCountUpCentiseconds forKey:@"theirCentiseconds"];
    //NSLog(@"Their total prep time in centiseconds: %i", theirCountUpCentiseconds);
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
    if (theirCountUpCentiseconds > 0)
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
    }
    else if (!isTheirPrepPaused)
    {
        [self pauseTheirTimer];
        
    }
    else if (isTheirPrepPaused)
    {
        [self resumeTheirTimer];
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
    theirCountUpCentiseconds = 0;
    [storeData setInteger:theirCountUpCentiseconds forKey:@"theirCentiseconds"];
    isTheirPrepStarted = NO;
    isTheirPrepPaused = NO;
    theirMinutes = 0;
    theirSeconds = 0;
    theirCentiseconds = 0;
    [self setTheirLabel];
    [theirPrepButton setTitle:@"Start" forState:UIControlStateNormal];
    NSLog(@"Resetting their prep time");
}
- (IBAction)resetTheirPrepTap:(id)sender
{
    [self.theirPrepTimer invalidate];
    [self resetTheirPrep];
}

- (IBAction)backButtonTap:(id)sender
{
    [self performSegueWithIdentifier:@"segueFromPrep" sender:self];
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
