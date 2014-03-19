//
//  TimerViewController.m
//  Debate Timer
//
//  Created by Cormac Chester on 3/18/14.
//  Copyright (c) 2014 Testman Industries. All rights reserved.
//

#import "TimerViewController.h"
#import "ViewController.h"

@interface TimerViewController ()

@end

@implementation TimerViewController
@synthesize policyTimes, policySpeeches, ldTimes, ldSpeeches, pfTimes, pfSpeeches, timerLabel, speechLabel, storeData, startTimerButton;

int minutes, seconds, countdownTimeSeconds;
int placeHolderMin;
int speechCounter;
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
    policyTimes = [NSArray arrayWithObjects: @8, @3, @8, @3, @8, @3, @8, @3, @5, @5, @5, @5, nil];
    policySpeeches = [NSArray arrayWithObjects:@"1AC", @"1st CX", @"1NC", @"2nd CX", @"2AC", @"3rd CX", @"2NC", @"4th CX", @"1NR", @"1AR", @"2NR", @"2AR", nil];
    
    //Lincoln-Douglas Arrays
    ldTimes = [NSArray arrayWithObjects:@6, @3, @7, @3, @4, @6, @3, nil];
    ldSpeeches = [NSArray arrayWithObjects:@"AC", @"1st CX", @"NC (1NR)", @"2nd CX", @"1AR", @"NR (2NR)", @"2AR", nil];
    
    //Public Forum
    pfTimes = [NSArray arrayWithObjects:@4, @4, @3, @4, @4, @3, @2, @2, @3, @2, @2, nil];
    pfSpeeches = [NSArray arrayWithObjects:@"Team A Constructive", @"Team B Constructive", @"Crossfire", @"Team A Rebuttal", @"Team B Rebuttal", @"Crossfire", @"Team A Summary", @"Team B Summary", @"Grand Crossfire", @"Team A Final", @"Team B Final", nil];

    ViewController *vC = [[ViewController alloc] init];
    vC.whatStyle = [storeData integerForKey:@"styleKey"];
    NSLog(@"Style of debate: %i", vC.whatStyle);
    
    if (vC.whatStyle == 1)
    {
        //Policy
        
        //Speech label
        speechLabel.text = [policySpeeches objectAtIndex:speechCounter];
        
        //Placeholder time
        placeHolderMin = [[policyTimes objectAtIndex:speechCounter] intValue];
        
        NSLog(@"Policy timing selected");
    }
    else if (vC.whatStyle == 2)
    {
        //Lincoln-Douglas
        
        //Speech label
        speechLabel.text = [ldSpeeches objectAtIndex:speechCounter];
        
        //Placeholder time
        placeHolderMin = [[ldTimes objectAtIndex:speechCounter] intValue];
        
        NSLog(@"LD timing selected");
    }
    else if (vC.whatStyle == 3)
    {
        //Public Forum
        
        //Speech label
        speechLabel.text = [pfSpeeches objectAtIndex:speechCounter];
        
        //Placeholder time
        placeHolderMin = [[pfTimes objectAtIndex:speechCounter] intValue];
        
        NSLog(@"PFD timing selected");
    }
    
    self.timerLabel.text = [NSString stringWithFormat:@"%02d:00", placeHolderMin];
}

//Start button tap
- (IBAction)startTimerButtonTap:(id)sender
{
    ViewController *vC = [[ViewController alloc] init];
    vC.whatStyle = [storeData integerForKey:@"styleKey"];
    
    if (!timerStarted)
    {
        //Starts timer
        if (vC.whatStyle == 1)
        {
            countdownTimeSeconds = [[policyTimes objectAtIndex:speechCounter] intValue] * 60;
        }
        else if (vC.whatStyle == 2)
        {
            countdownTimeSeconds = [[ldTimes objectAtIndex:speechCounter] intValue] * 60;
        }
        else if (vC.whatStyle == 3)
        {
            countdownTimeSeconds = [[pfTimes objectAtIndex:speechCounter] intValue] * 60;
        }
        
        [self timerRuns];
        
        [startTimerButton setTitle:@"Pause Timer" forState:UIControlStateNormal];
        
        timerStarted = YES;
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

//Back button tap
- (IBAction)backButtonTap:(id)sender
{
    //Stops tiemr
    [speechTimer invalidate];
    
    //Changes view controller back to main view
    ViewController *vC = [self.storyboard instantiateViewControllerWithIdentifier:@"viewController"];
    [self presentViewController:vC animated:YES completion:nil];
}

//Runs the timer
- (void)timerRuns
{
    speechTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateLabel:) userInfo:nil repeats:YES];
    speechCounter ++;
    NSLog(@"Timer has started");
}

//Effectively the timer
- (void)updateLabel:(NSTimer *)timer
{
    ViewController *vC = [[ViewController alloc] init];
    
    if (countdownTimeSeconds > 0)
    {
        countdownTimeSeconds --;
        minutes = (countdownTimeSeconds % 3600) / 60;
        seconds = (countdownTimeSeconds % 3600) % 60;
        self.timerLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
        NSLog(@"%02d:%02d", minutes, seconds);
    }
    else if (countdownTimeSeconds == 0)
    {
        //Shows alert that the speech is finished
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Timer done" message:@"Speech is finished" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        //Set labels for next speech
        if (vC.whatStyle == 1)
        {
            speechLabel.text = [policySpeeches objectAtIndex:speechCounter];
            placeHolderMin = [[policyTimes objectAtIndex:speechCounter] intValue];
        }
        else if (vC.whatStyle == 2)
        {
            speechLabel.text = [ldSpeeches objectAtIndex:speechCounter];
            placeHolderMin = [[ldTimes objectAtIndex:speechCounter] intValue];
        }
        else if (vC.whatStyle == 3)
        {
            speechLabel.text = [pfSpeeches objectAtIndex:speechCounter];
            placeHolderMin = [[pfTimes objectAtIndex:speechCounter] intValue];
        }
        
        //Set placeholder time
        self.timerLabel.text = [NSString stringWithFormat:@"%02d:00", placeHolderMin];
        
        //Stops timer
        [speechTimer invalidate];
    }
}

- (void)pauseTimer
{
    [speechTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:31536000]];
    
    [startTimerButton setTitle:@"Start Timer" forState:UIControlStateNormal];
}

- (void)resumeTimer
{
    [speechTimer setFireDate:[NSDate date]];
    
    [startTimerButton setTitle:@"Pause Timer" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
