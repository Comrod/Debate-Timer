//
//  TimerViewController.m
//  Debate Timer
//
//  Created by Cormac Chester on 3/18/14.
//  Copyright (c) 2014 Testman Industries. All rights reserved.
//

#import "TimerViewController.h"
#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface TimerViewController ()

@end

@implementation TimerViewController
@synthesize policyTimes, policySpeeches, ldTimes, ldSpeeches, pfTimes, pfSpeeches, timerLabel, speechLabel, storeData, startTimerButton;

int minutes, seconds, centiseconds, countdownTimeCentiseconds;
int placeHolderMin;
int speechCounter;
int styleChosen;
BOOL alertShown = NO;
BOOL timerStarted = NO;
BOOL timerPaused = NO;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Set up data storage
    storeData = [NSUserDefaults standardUserDefaults];
    
    [startTimerButton setTitle:@"Start Timer" forState:UIControlStateNormal];
    
    //Set preliminary variables
    speechCounter = 0;
    alertShown = NO;
    timerStarted = NO;
    timerPaused = NO;
    
    //Policy Arrays
    policyTimes = [NSArray arrayWithObjects: @1, @3, @8, @3, @8, @3, @8, @3, @5, @5, @5, @5, @0, nil];
    policySpeeches = [NSArray arrayWithObjects:@"1AC", @"1st CX", @"1NC", @"2nd CX", @"2AC", @"3rd CX", @"2NC", @"4th CX", @"1NR", @"1AR", @"2NR", @"2AR", @"Round Finished", nil];
    
    //Lincoln-Douglas Arrays
    ldTimes = [NSArray arrayWithObjects:@6, @3, @7, @3, @4, @6, @3, @0, nil];
    ldSpeeches = [NSArray arrayWithObjects:@"AC", @"1st CX", @"NC (1NR)", @"2nd CX", @"1AR", @"NR (2NR)", @"2AR", @"Round Finished", nil];
    
    //Public Forum
    pfTimes = [NSArray arrayWithObjects:@4, @4, @3, @4, @4, @3, @2, @2, @3, @2, @2, @0, nil];
    pfSpeeches = [NSArray arrayWithObjects:@"Team A Constructive", @"Team B Constructive", @"Crossfire", @"Team A Rebuttal", @"Team B Rebuttal", @"Crossfire", @"Team A Summary", @"Team B Summary", @"Grand Crossfire", @"Team A Final", @"Team B Final", @"Round Finished", nil];

    styleChosen = [storeData integerForKey:@"styleKey"];
    NSLog(@"Style of debate: %i", styleChosen);
    
    if (styleChosen == 1)
    {
        //Policy
        [self setDataForPolicy];
        
        NSLog(@"Policy timing selected");
    }
    else if (styleChosen == 2)
    {
        //Lincoln-Douglas
        [self setDataForLD];
        
        NSLog(@"LD timing selected");
    }
    else if (styleChosen == 3)
    {
        //Public Forum
        [self setDataForPFD];
        
        NSLog(@"PFD timing selected");
    }
    
    self.timerLabel.text = [NSString stringWithFormat:@"%02d:00:00", placeHolderMin];
}

- (void)setDataForPolicy
{
    speechLabel.text = [policySpeeches objectAtIndex:speechCounter];
    placeHolderMin = [[policyTimes objectAtIndex:speechCounter] intValue];
}

- (void)setDataForLD
{
    speechLabel.text = [ldSpeeches objectAtIndex:speechCounter];
    placeHolderMin = [[ldTimes objectAtIndex:speechCounter] intValue];
}

- (void)setDataForPFD
{
    speechLabel.text = [pfSpeeches objectAtIndex:speechCounter];
    placeHolderMin = [[pfTimes objectAtIndex:speechCounter] intValue];
}

//Start button tap
- (IBAction)startTimerButtonTap:(id)sender
{
    if (!timerStarted)
    {
        //Starts timer
        if (styleChosen == 1)
        {
            countdownTimeCentiseconds = [[policyTimes objectAtIndex:speechCounter] intValue] * 6000;
        }
        else if (styleChosen == 2)
        {
            countdownTimeCentiseconds = [[ldTimes objectAtIndex:speechCounter] intValue] * 6000;
        }
        else if (styleChosen == 3)
        {
            countdownTimeCentiseconds = [[pfTimes objectAtIndex:speechCounter] intValue] * 6000;
        }
        
        if (countdownTimeCentiseconds > 0)
        {
            [self timerRuns];
            
            [startTimerButton setTitle:@"Pause Timer" forState:UIControlStateNormal];
            
            timerStarted = YES;
        }
        else
        {
            //Round is over
            [self roundOver];
        }
    }
    else if (timerStarted)
    {
        if (!timerPaused)
        {
            //Pauses timer
            [self pauseTimer];
            timerPaused = YES;
        }
        else if (timerPaused)
        {
            //Resumes timer
            [self resumeTimer];
            timerPaused = NO;
        }
    }
}

//Runs the timer
- (void)timerRuns
{
    speechTimer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(updateLabel:) userInfo:nil repeats:YES];
    speechCounter ++;
    NSLog(@"Timer has started");
}

//Effectively the timer
- (void)updateLabel:(NSTimer *)timer
{
    if (countdownTimeCentiseconds > 0)
    {
        countdownTimeCentiseconds --;
        centiseconds = countdownTimeCentiseconds % 100;
        seconds = (countdownTimeCentiseconds / 100) % 60;
        minutes = (countdownTimeCentiseconds / 100) / 60;
        
        self.timerLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", minutes, seconds, centiseconds];
        NSLog(@"Total countdown time: %i", countdownTimeCentiseconds);
    }
    else
    {
        //Shows alert that the speech is finished
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Timer done" message:@"Speech is finished" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        
        //Set labels for next speech
        if (styleChosen == 1)
        {
            [self setDataForPolicy];
            NSLog(@"Next speech: %@", speechLabel.text);
        }
        else if (styleChosen == 2)
        {
            [self setDataForLD];
            NSLog(@"Next speech: %@", speechLabel.text);
        }
        else if (styleChosen == 3)
        {
            [self setDataForPFD];
            NSLog(@"Next speech: %@", speechLabel.text);
        }
        
        //Set placeholder time
        self.timerLabel.text = [NSString stringWithFormat:@"%02d:00", placeHolderMin];
        
        //Reset pausing mechanism and button label
        timerStarted = NO;
        [startTimerButton setTitle:@"Start Timer" forState:UIControlStateNormal];
        
        //Stops timer
        [speechTimer invalidate];
    }
}

//Pauses timer
- (void)pauseTimer
{
    [speechTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:31536000]];
    [startTimerButton setTitle:@"Start Timer" forState:UIControlStateNormal];
}

//Resumes timer
- (void)resumeTimer
{
    [speechTimer setFireDate:[NSDate date]];
    [startTimerButton setTitle:@"Pause Timer" forState:UIControlStateNormal];
}

- (void)roundOver
{
    UIAlertView *roundOverAlert = [[UIAlertView alloc] initWithTitle:@"Round is Over" message:@"Round is over, you've been sent back to the selection screen" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [roundOverAlert show];
    
    ViewController *vC = [self.storyboard instantiateViewControllerWithIdentifier:@"viewController"];
    [self presentViewController:vC animated:YES completion:nil];
}

//Back button tap
- (IBAction)backButtonTap:(id)sender
{
    //Stops timer
    [speechTimer invalidate];
    
    //Changes view controller back to main view
    ViewController *vC = [self.storyboard instantiateViewControllerWithIdentifier:@"viewController"];
    [self presentViewController:vC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
