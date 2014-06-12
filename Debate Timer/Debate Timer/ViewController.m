//
//  ViewController.m
//  Debate Timer
//
//  Created by Cormac Chester on 3/18/14.
//  Copyright (c) 2014 Extreme Images Inc. All rights reserved.
//

#import "ViewController.h"
#import "TimerViewController.h"
#import "PrepViewController.h"
#import "DejalActivityView.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize storeData;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    storeData = [NSUserDefaults standardUserDefaults];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"goneHome"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"shouldResetPrep"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"fromSettings"];

    NSLog(@"HomeSkipInt: %i", (int)[storeData integerForKey:@"homeSkip"]);
    
    if ([storeData boolForKey:@"firstLaunch"])
    {
        if ([storeData integerForKey:@"homeSkip"] == 1)
        {
            [DejalBezelActivityView activityViewForView:self.view];
            [self performSelector:@selector(skipHome) withObject:self afterDelay:1.0F];
        }
    }
}

- (void)skipHome
{
    NSLog(@"Going to skip home");
    self.whatStyle = [storeData integerForKey:@"primaryStyle"];
    if (self.whatStyle == 0)
    {
        self.prepTime = 5;
    }
    else if (self.whatStyle == 1)
    {
        self.prepTime = 4;
    }
    else if (self.whatStyle == 2)
    {
        self.prepTime = 2;
    }
    
    [storeData setInteger:self.whatStyle forKey:@"styleKey"];
    [storeData setInteger:self.prepTime forKey:@"prepValue"];
    
    NSLog(@"Setup finished");
    [DejalBezelActivityView removeViewAnimated:YES];
    
    [self performSegueWithIdentifier:@"segueToTimer" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapPolicyButton:(id)sender
{
    self.whatStyle = 0;
    self.prepTime = 5;
    [storeData setInteger:self.whatStyle forKey:@"styleKey"];
    [storeData setInteger:self.prepTime forKey:@"prepValue"];
    [self performSegueWithIdentifier:@"segueToTimer" sender:self];
    
    //TimerViewController *timerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"timerViewController"];
    //[self presentViewController:timerVC animated:YES completion:nil];
}

- (IBAction)tapLDButton:(id)sender
{
    self.whatStyle = 1;
    self.prepTime = 4;
    [storeData setInteger:self.whatStyle forKey:@"styleKey"];
    [storeData setInteger:self.prepTime forKey:@"prepValue"];
    [self performSegueWithIdentifier:@"segueToTimer" sender:self];
    
    //TimerViewController *timerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"timerViewController"];
    //[self presentViewController:timerVC animated:YES completion:nil];
}

- (IBAction)tapPFButton:(id)sender
{
    self.whatStyle = 2;
    self.prepTime = 2;
    [storeData setInteger:self.whatStyle forKey:@"styleKey"];
    [storeData setInteger:self.prepTime forKey:@"prepValue"];
    [self performSegueWithIdentifier:@"segueToTimer" sender:self];
    
    //TimerViewController *timerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"timerViewController"];
    //[self presentViewController:timerVC animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}
@end
