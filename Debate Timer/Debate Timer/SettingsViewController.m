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

@synthesize centisecondSegControl, prepTimeLabel, storeData, prepStepper, blueColor, redColor, greenColor, orangeColor, yellowColor, pinkColor;

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
    
    //Colors
    blueColor = [UIColor colorWithRed:0 green:122 blue:255 alpha:1];
    redColor = [UIColor colorWithRed:255 green:59 blue:66 alpha:1];
    greenColor = [UIColor colorWithRed:78 green:194 blue:48 alpha:1];
    orangeColor = [UIColor colorWithRed:255 green:170 blue:49 alpha:1];
    yellowColor = [UIColor colorWithRed:246 green:219 blue:65 alpha:1];
    pinkColor = [UIColor colorWithRed:255 green:83 blue:176 alpha:1];
    
    //Set up data storage
    storeData = [NSUserDefaults standardUserDefaults];
    
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
        if (styleChosen == 1)
        {
            //Policy base prep
            basePrep = 5;
        }
        else if (styleChosen == 2)
        {
            //LD base prep
            basePrep = 4;
        }
        else if (styleChosen == 3)
        {
            //PFD base prep
            basePrep = 2;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
