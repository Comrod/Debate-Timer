//
//  ViewController.m
//  Debate Timer
//
//  Created by Cormac Chester on 3/18/14.
//  Copyright (c) 2014 Testman Industries. All rights reserved.
//

#import "ViewController.h"
#import "TimerViewController.h"
#import "PrepViewController.h"

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapPolicyButton:(id)sender
{
    self.whatStyle = 1;
    [storeData setInteger:self.whatStyle forKey:@"styleKey"];
    
    [self performSegueWithIdentifier:@"segueToTimer" sender:self];
    
    //TimerViewController *timerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"timerViewController"];
    //[self presentViewController:timerVC animated:YES completion:nil];
}

- (IBAction)tapLDButton:(id)sender
{
    self.whatStyle = 2;
    [storeData setInteger:self.whatStyle forKey:@"styleKey"];
    
    [self performSegueWithIdentifier:@"segueToTimer" sender:self];
    
    //TimerViewController *timerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"timerViewController"];
    //[self presentViewController:timerVC animated:YES completion:nil];
}

- (IBAction)tapPFButton:(id)sender
{
    self.whatStyle = 3;
    [storeData setInteger:self.whatStyle forKey:@"styleKey"];
    
    [self performSegueWithIdentifier:@"segueToTimer" sender:self];
    
    //TimerViewController *timerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"timerViewController"];
    //[self presentViewController:timerVC animated:YES completion:nil];
}
@end
