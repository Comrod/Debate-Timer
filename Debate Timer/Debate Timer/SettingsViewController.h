//
//  SettingsViewController.h
//  Debate Timer
//
//  Created by Cormac Chester on 3/19/14.
//  Copyright (c) 2014 Extreme Images Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
{
    int prepValue;
}


@property (strong, nonatomic) IBOutlet UISegmentedControl *centisecondSegControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *primaryStyleSegControl;
@property (strong, nonatomic) IBOutlet UISwitch *homeSkipSwitch;
@property (strong, nonatomic) IBOutlet UILabel *prepTimeLabel;
@property (nonatomic) NSUserDefaults *storeData;
@property (strong, nonatomic) IBOutlet UIStepper *prepStepper;
@property (strong, nonatomic) UIColor *blueColor;
@property (strong, nonatomic) UIColor *redColor;
@property (strong, nonatomic) UIColor *greenColor;
@property (strong, nonatomic) UIColor *orangeColor;
@property (strong, nonatomic) UIColor *yellowColor;
@property (strong, nonatomic) UIColor *pinkColor;


- (IBAction)centisecondValueChanged:(id)sender;
- (IBAction)primaryStyleValueChanged:(id)sender;
- (IBAction)homeSkipSwitchValueChanged:(id)sender;
- (IBAction)backButtonTap:(id)sender;
- (IBAction)prepStepperValueChanged:(id)sender;


@end
