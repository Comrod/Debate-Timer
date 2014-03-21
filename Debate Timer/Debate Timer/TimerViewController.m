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
int speechCounter = 0;
int styleChosen;
BOOL alertShown = NO;
BOOL timerStarted = NO;
BOOL timerFinished = NO;
BOOL timerPaused = NO;
BOOL pickerIsShowing = NO;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Set up data storage
    storeData = [NSUserDefaults standardUserDefaults];
    

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"goneHome"])
    {
        //Resets variables if you have gone to the home screen
        speechCounter = 0;
        [self resetTimer];
    }
    else
    {
        [self getDataFromStorage];
        [startTimerButton setTitle:@"Resume Timer" forState:UIControlStateNormal];
        timerStarted = YES;
        timerPaused = YES;
    }
    
    
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
    
    [self getStyleandSetData];
    
    [self setTimerLabelText];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"goneHome"];
}

- (void)getStyleandSetData
{
    styleChosen = [storeData integerForKey:@"styleKey"];
    
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
}

- (void)setTimerLabelText
{
    //Determines if centiseconds are shown
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isCenti"])
    {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"goneHome"] || timerFinished)
        {
            self.timerLabel.text = [NSString stringWithFormat:@"%02d:00:00", placeHolderMin];
        }
        else
        {
            self.timerLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", minutes, seconds, centiseconds];
        }
        
        NSLog(@"Showing centiseconds");
    }
    else if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isCenti"])
    {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"goneHome"] || timerFinished)
        {
            self.timerLabel.text = [NSString stringWithFormat:@"%02d:00", placeHolderMin];
        }
        else
        {
            self.timerLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
        }
        
        NSLog(@"Not showing centiseconds");
    }
}

- (void)setDataToStorage
{
    [storeData setInteger:countdownTimeCentiseconds forKey:@"countdownTime"];
    [storeData setInteger:minutes forKey:@"minutes"];
    [storeData setInteger:seconds forKey:@"seconds"];
    [storeData setInteger:centiseconds forKey:@"centiseconds"];
    [storeData setInteger:speechCounter forKey:@"speechCounter"];
    [storeData setInteger:placeHolderMin forKey:@"placeHolderMin"];
    [storeData setInteger:styleChosen forKey:@"styleChosen"];
    
    NSLog(@"Set data to storage");
}
- (void)getDataFromStorage
{
    countdownTimeCentiseconds = [storeData integerForKey:@"countdownTime"];
    minutes = [storeData integerForKey:@"minutes"];
    seconds = [storeData integerForKey:@"seconds"];
    centiseconds = [storeData integerForKey:@"centiseconds"];
    speechCounter = [storeData integerForKey:@"speechCounter"];
    placeHolderMin = [storeData integerForKey:@"placeHolderMin"];
    styleChosen = [storeData integerForKey:@"styleChosen"];
    
    NSLog(@"Got data from storage");
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
            NSLog(@"Paused timer");
        }
        else if (timerPaused)
        {
            //Resumes timer
            [self resumeTimer];
            NSLog(@"Resumed timer");
        }
    }
}

//Runs the timer
- (void)timerRuns
{
    if (timerStarted)
    {
        [self getDataFromStorage];
    }
    
    self.speechTimer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(updateLabel:) userInfo:nil repeats:YES];
    timerStarted = YES;
    timerFinished = NO;
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
        
        [self setTimerLabelText];
        
        [self setDataToStorage];
        NSLog(@"Total countdown time: %i", countdownTimeCentiseconds);
    }
    else
    {
        timerFinished = YES;
        
        //Shows alert that the speech is finished
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Timer done" message:@"Speech is finished" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        speechCounter ++;
        
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
        [self setTimerLabelText];
        
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
    [self.speechTimer invalidate];
    [startTimerButton setTitle:@"Resume Timer" forState:UIControlStateNormal];
    timerPaused = YES;
}

//Resumes timer
- (void)resumeTimer
{
    [self timerRuns];
    [startTimerButton setTitle:@"Pause Timer" forState:UIControlStateNormal];
    timerPaused = NO;
}

- (void)resetTimer
{
    [self.speechTimer invalidate];
    countdownTimeCentiseconds = 0;
    minutes = 0;
    seconds = 0;
    centiseconds = 0;
    alertShown = NO;
    timerStarted = NO;
    timerPaused = NO;
    timerFinished = YES;
    [self setDataToStorage];
    
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
    
    [self setTimerLabelText];
    
    [startTimerButton setTitle:@"Start Timer" forState:UIControlStateNormal];
    NSLog(@"Reset timer");
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

- (IBAction)resetTimerButtonTap:(id)sender
{
    [self resetTimer];
}

- (IBAction)showPickerButtonTap:(id)sender
{
    
    if (!pickerIsShowing)
    {
        [self showPicker];
    }
    else if (pickerIsShowing)
    {
        [self hidePicker];
    }
}

- (void)showPicker
{
    //Sets picker to selected row
    [singlePicker selectRow:speechCounter inComponent:0 animated:YES];
    
    //Animates picker
    CGPoint newPickerCenter = CGPointMake(singlePicker.center.x, singlePicker.center.y - self.view.frame.size.height);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    singlePicker.center = newPickerCenter;
    [UIView commitAnimations];
    pickerIsShowing = YES;
}
- (void)hidePicker
{
    //Animates picker
    CGPoint newPickerCenter = CGPointMake(singlePicker.center.x, singlePicker.center.y + self.view.frame.size.height);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    singlePicker.center = newPickerCenter;
    [UIView commitAnimations];
    pickerIsShowing = NO;
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
    [storeData setInteger:speechCounter forKey:@"speechCounter"];
    
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

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [self hidePicker];
    
    [self pauseTimer];
    
    [self setDataToStorage];
}

@end
