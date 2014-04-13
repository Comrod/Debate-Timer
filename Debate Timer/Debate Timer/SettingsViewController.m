//
//  SettingsViewController.m
//  Debate Timer
//
//  Created by Cormac Chester on 3/19/14.
//  Copyright (c) 2014 Testman Industries. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize centisecondSegControl, prepTimeLabel, storeData, prepStepper;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
