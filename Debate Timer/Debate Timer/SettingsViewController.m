//
//  SettingsViewController.m
//  Debate Timer
//
//  Created by Cormac Chester on 3/19/14.
//  Copyright (c) 2014 Extreme Images Inc. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize centisecondSegControl, primaryStyleSegControl, homeSkipSwitch, prepTimeLabel, storeData, prepStepper, blueColor, redColor, greenColor, orangeColor, yellowColor, pinkColor;

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
    
    //Set up data storage
    storeData = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"Value of Home Skip Switch: %ld", (long)[storeData integerForKey:@"homeSkip"]);
    if ([storeData integerForKey:@"homeSkip"] == 1)
    {
        [homeSkipSwitch setOn:YES];
        NSLog(@"Set switch on");
    }
    else if ([storeData integerForKey:@"homeSkip"] == 0)
    {
        [homeSkipSwitch setOn:NO];
        NSLog(@"Set switch off");
    }
    
    //Colors
    blueColor = [UIColor colorWithRed:0 green:122 blue:255 alpha:1];
    redColor = [UIColor colorWithRed:255 green:59 blue:66 alpha:1];
    greenColor = [UIColor colorWithRed:78 green:194 blue:48 alpha:1];
    orangeColor = [UIColor colorWithRed:255 green:170 blue:49 alpha:1];
    yellowColor = [UIColor colorWithRed:246 green:219 blue:65 alpha:1];
    pinkColor = [UIColor colorWithRed:255 green:83 blue:176 alpha:1];
    
    
    //Decimals
    //
    //
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isCenti"])
    {
        [self.centisecondSegControl setSelectedSegmentIndex:0];
    }
    else if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isCenti"])
    {
        [self.centisecondSegControl setSelectedSegmentIndex:1];
    }
    
    
    //Prep Time
    //
    //
    int basePrep;
    int styleChosen = (int)[storeData integerForKey:@"styleKey"];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"shouldResetPrep"])
    {
        if (styleChosen == 0)
        {
            //Policy base prep
            basePrep = 5;
            [self.primaryStyleSegControl setSelectedSegmentIndex:0];
        }
        else if (styleChosen == 1)
        {
            //LD base prep
            basePrep = 4;
            [self.primaryStyleSegControl setSelectedSegmentIndex:1];
        }
        else if (styleChosen == 2)
        {
            //PFD base prep
            basePrep = 2;
            [self.primaryStyleSegControl setSelectedSegmentIndex:2];
        }
        prepValue = basePrep;
        prepStepper.value = prepValue;
        prepTimeLabel.text = [NSString stringWithFormat:@"%i", prepValue];
        [storeData setInteger:prepValue forKey:@"prepValue"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"shouldResetPrep"];
        NSLog(@"Using new prep time");
    }
    else
    {
        prepValue = (int)[storeData integerForKey:@"prepValue"];
        prepStepper.value = prepValue;
        NSLog(@"Old prep value: %i", prepValue);
        prepTimeLabel.text = [NSString stringWithFormat:@"%i", prepValue];
        NSLog(@"Using old prep time");
    }
    
    
    //Primary Style
    
    if (![storeData boolForKey:@"firstSettingsVisit"])
    {
        [self.primaryStyleSegControl setSelectedSegmentIndex:styleChosen];
        [self pickPrimaryStyle];
    }
    else
    {
        [self.primaryStyleSegControl setSelectedSegmentIndex:[storeData integerForKey:@"primaryStyle"]];
    }
    [storeData setBool:YES forKey:@"firstSettingsVisit"];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"fromSettings"];
}


- (IBAction)centisecondValueChanged:(id)sender
{
    if ([self.centisecondSegControl selectedSegmentIndex] == 0)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isCenti"];
    }
    else if ([self.centisecondSegControl selectedSegmentIndex] == 1)
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isCenti"];
    }
}

- (IBAction)primaryStyleValueChanged:(id)sender
{
    [self pickPrimaryStyle];
}

- (void)pickPrimaryStyle
{
    if ([self.primaryStyleSegControl selectedSegmentIndex] == 0)
    {
        //Policy selected
        [storeData setInteger:0 forKey:@"primaryStyle"];
        NSLog(@"Policy selected as primary style");
    }
    else if ([self.primaryStyleSegControl selectedSegmentIndex] == 1)
    {
        //LD selected
        [storeData setInteger:1 forKey:@"primaryStyle"];
        NSLog(@"LD selected as primary style");
    }
    else if ([self.primaryStyleSegControl selectedSegmentIndex] == 2)
    {
        //PFD selected
        [storeData setInteger:2 forKey:@"primaryStyle"];
        NSLog(@"PFD selected as primary style");
    }
}

- (IBAction)homeSkipSwitchValueChanged:(id)sender
{
    [storeData setInteger:homeSkipSwitch.on forKey:@"homeSkip"];
    NSLog(@"Value of Home Skip Switch: %d", homeSkipSwitch.on);
}

- (IBAction)backButtonTap:(id)sender
{
    [self performSegueWithIdentifier:@"segueFromSettings" sender:self];
}

- (IBAction)prepStepperValueChanged:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setInteger:YES forKey:@"shouldResetPrep"];
    prepValue = prepStepper.value;
    [storeData setInteger:prepValue forKey:@"prepValue"];
    prepTimeLabel.text = [NSString stringWithFormat:@"%i", prepValue];
    NSLog(@"Prep value: %i", prepValue);
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [storeData setInteger:prepValue forKey:@"prepValue"];
    NSLog(@"Home Skip before segue: %d", homeSkipSwitch.on);
    [storeData setInteger:homeSkipSwitch.on forKey:@"homeSkip"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
