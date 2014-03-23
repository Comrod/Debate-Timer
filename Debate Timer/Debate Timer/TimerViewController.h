//
//  TimerViewController.h
//  Debate Timer
//
//  Created by Cormac Chester on 3/18/14.
//  Copyright (c) 2014 Testman Industries. All rights reserved.
//

#import "ViewController.h"
#import "SettingsViewController.h"
#include <AudioToolbox/AudioToolbox.h>

@interface TimerViewController : UIViewController <UIPickerViewDataSource , UIPickerViewDelegate, UIAlertViewDelegate>
{
    IBOutlet UIPickerView *speechPicker;
    SystemSoundID soundID;
}

//Speeches and times
@property (nonatomic) NSArray *policyTimes;
@property (nonatomic) NSArray *policySpeeches;
@property (nonatomic) NSArray *ldTimes;
@property (nonatomic) NSArray *ldSpeeches;
@property (nonatomic) NSArray *pfTimes;
@property (nonatomic) NSArray *pfSpeeches;
@property (strong, nonatomic) IBOutlet UILabel *speechLabel;
@property (strong, nonatomic) IBOutlet UILabel *styleLabel;

@property (nonatomic) NSUserDefaults *storeData;

//Timer
@property (nonatomic) NSTimer *speechTimer;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) IBOutlet UIButton *startTimerButton;
@property (strong, nonatomic) IBOutlet UIButton *resetTimerButton;

//Switch
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *settingsButton;
@property (strong, nonatomic) IBOutlet UIButton *prepButton;

//Picker
@property (strong, nonatomic) IBOutlet UIButton *showPickerButton;
@property (nonatomic) NSArray *pickerData;
@property(nonatomic, retain) UIPickerView *speechPicker;

//Alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;


- (IBAction)startTimerButtonTap:(id)sender;
- (IBAction)backButtonTap:(id)sender;
- (IBAction)showPickerButtonTap:(id)sender;
- (IBAction)settingsButtonTap:(id)sender;
- (IBAction)prepButtonTap:(id)sender;
- (IBAction)resetTimerButtonTap:(id)sender;

@end
