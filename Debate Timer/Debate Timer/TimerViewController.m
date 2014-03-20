//
//  TimerViewController.m
//  Debate Timer
//
//  Created by Cormac Chester on 3/18/14.
//  Copyright (c) 2014 Testman Industries. All rights reserved.
//

#import "TimerViewController.h"
#import "ViewController.h"
#import "SettingsViewController.h"

@interface TimerViewController ()

@end

@implementation TimerViewController
@synthesize policyTimes, policySpeeches, ldTimes, ldSpeeches, pfTimes, pfSpeeches, timerLabel, speechLabel, storeData, startTimerButton, pickerData, singlePicker;

int minutes, seconds, centiseconds, countdownTimeCentiseconds;
int placeHolderMin;
int speechCounter;
int styleChosen;
BOOL alertShown = NO;
BOOL timerStarted = NO;
BOOL timerPaused = NO;
BOOL pickerIsShowing = NO;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Set up data storage
    storeData = [NSUserDefaults standardUserDefaults];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isCenti"];
    
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

    singlePicker.center = CGPointMake(singlePicker.center.x, singlePicker.center.y + self.view.frame.size.height);
    
    styleChosen = [storeData integerForKey:@"styleKey"];
    NSLog(@"Style of debate: %i", styleChosen);
    
    if (styleChosen == 1)
    {
        //Policy
        [self setDataForPolicy];
        
        //Set picker data
        self.pickerData = policySpeeches;
        
        self.styleLabel.text = [NSString stringWithFormat:@"Policy"];
        NSLog(@"Policy timing selected");
    }
    else if (styleChosen == 2)
    {
        //Lincoln-Douglas
        [self setDataForLD];
        
        //Set picker data
        self.pickerData = ldSpeeches;
        
        self.styleLabel.text = [NSString stringWithFormat:@"Lincoln-Douglas"];
        NSLog(@"LD timing selected");
    }
    else if (styleChosen == 3)
    {
        //Public Forum
        [self setDataForPFD];
        
        //Set picker data
        self.pickerData = pfSpeeches;
        
        self.styleLabel.text = [NSString stringWithFormat:@"Public Forum"];
        NSLog(@"PFD timing selected");
    }
    
    //Determines if centiseconds are shown
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isCenti"])
    {
        self.timerLabel.text = [NSString stringWithFormat:@"%02d:00:00", placeHolderMin];
        NSLog(@"Showing centiseconds");
    }
    else if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isCenti"])
    {
        self.timerLabel.text = [NSString stringWithFormat:@"%02d:00", placeHolderMin];
        NSLog(@"Not showing centiseconds");
    }
    
}

- (void)setDataForPolicy
{
    speechLabel.text = [policySpeeches objectAtIndex:speechCounter];
    placeHolderMin = [[policyTimes objectAtIndex:speechCounter] intValue];
    countdownTimeCentiseconds = [[policyTimes objectAtIndex:speechCounter] intValue] * 6000;
}

- (void)setDataForLD
{
    speechLabel.text = [ldSpeeches objectAtIndex:speechCounter];
    placeHolderMin = [[ldTimes objectAtIndex:speechCounter] intValue];
    countdownTimeCentiseconds = [[ldTimes objectAtIndex:speechCounter] intValue] * 6000;
}

- (void)setDataForPFD
{
    speechLabel.text = [pfSpeeches objectAtIndex:speechCounter];
    placeHolderMin = [[pfTimes objectAtIndex:speechCounter] intValue];
    countdownTimeCentiseconds = [[pfTimes objectAtIndex:speechCounter] intValue] * 6000;
}

//Start button tap
- (IBAction)startTimerButtonTap:(id)sender
{
    if (!timerStarted)
    {
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
    self.speechTimer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(updateLabel:) userInfo:nil repeats:YES];
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
        
        //Determines if centiseconds are shown
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isCenti"])
        {
            self.timerLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", minutes, seconds, centiseconds];
        }
        else if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isCenti"])
        {
            self.timerLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
        }
            
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
        [self.speechTimer invalidate];
    }
}

//Pauses timer
- (void)pauseTimer
{
    [self.speechTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:31536000]];
    [startTimerButton setTitle:@"Resume Timer" forState:UIControlStateNormal];
}

//Resumes timer
- (void)resumeTimer
{
    [self.speechTimer setFireDate:[NSDate date]];
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
    [self.speechTimer invalidate];
    
    //Changes view controller back to main view
    ViewController *vC = [self.storyboard instantiateViewControllerWithIdentifier:@"viewController"];
    [self presentViewController:vC animated:YES completion:nil];
}

- (IBAction)settingsButtonTap:(id)sender
{

}

- (IBAction)prepButtonTap:(id)sender
{

}

- (IBAction)showPickerButtonTap:(id)sender
{
    
    if (!pickerIsShowing)
    {
        CGPoint newPickerCenter = CGPointMake(singlePicker.center.x, singlePicker.center.y - self.view.frame.size.height);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        singlePicker.center = newPickerCenter;
        [UIView commitAnimations];
        pickerIsShowing = YES;
    }
    else if (pickerIsShowing)
    {
        CGPoint newPickerCenter = CGPointMake(singlePicker.center.x, singlePicker.center.y + self.view.frame.size.height);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        singlePicker.center = newPickerCenter;
        [UIView commitAnimations];
        pickerIsShowing = NO;
    }
}

//Pick specific speech
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [pickerData count];
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return[pickerData objectAtIndex:row];
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    speechCounter = row;
    
    if (styleChosen == 1)
    {
        [self setDataForPolicy];
    }
    else if (styleChosen == 2)
    {
        [self setDataForLD];
    }
    else if (styleChosen == 3)
    {
        [self setDataForPFD];
    }
    
    timerStarted = NO;
    [self.speechTimer invalidate];
    
    [startTimerButton setTitle:@"Start Timer" forState:UIControlStateNormal];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isCenti"])
    {
        self.timerLabel.text = [NSString stringWithFormat:@"%02d:00:00", placeHolderMin];
    }
    else if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isCenti"])
    {
        self.timerLabel.text = [NSString stringWithFormat:@"%02d:00", placeHolderMin];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
