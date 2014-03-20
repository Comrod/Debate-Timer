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
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isCenti"])
    {
        [self.centisecondSegControl setSelectedSegmentIndex:0];
    }
    else if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isCenti"])
    {
        [self.centisecondSegControl setSelectedSegmentIndex:1];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
@end
