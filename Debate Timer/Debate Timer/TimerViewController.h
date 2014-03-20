//
//  TimerViewController.h
//  Debate Timer
//
//  Created by Cormac Chester on 3/18/14.
//  Copyright (c) 2014 Testman Industries. All rights reserved.
//

#import "ViewController.h"

@interface TimerViewController : UIViewController <UIPickerViewDataSource , UIPickerViewDelegate>
{
    IBOutlet UIPickerView *singlePicker;
}

@property (nonatomic) NSArray *policyTimes;
@property (nonatomic) NSArray *policySpeeches;
@property (nonatomic) NSArray *ldTimes;
@property (nonatomic) NSArray *ldSpeeches;
@property (nonatomic) NSArray *pfTimes;
@property (nonatomic) NSArray *pfSpeeches;
@property (nonatomic) NSUserDefaults *storeData;
@property (nonatomic) NSTimer *speechTimer;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) IBOutlet UILabel *speechLabel;
@property (strong, nonatomic) IBOutlet UILabel *styleLabel;
@property (strong, nonatomic) IBOutlet UIButton *startTimerButton;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *settingsButton;

@property (strong, nonatomic) IBOutlet UIButton *showPickerButton;


@property (nonatomic) NSArray *pickerData;
@property(nonatomic, retain) UIPickerView *singlePicker;

- (IBAction)startTimerButtonTap:(id)sender;
- (IBAction)backButtonTap:(id)sender;
- (IBAction)showPickerButtonTap:(id)sender;
- (IBAction)settingsButtonTap:(id)sender;



@end
