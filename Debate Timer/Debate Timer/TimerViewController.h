//
//  TimerViewController.h
//  Debate Timer
//
//  Created by Cormac Chester on 3/18/14.
//  Copyright (c) 2014 Testman Industries. All rights reserved.
//

#import "ViewController.h"

@interface TimerViewController : ViewController

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

- (IBAction)startTimerButtonTap:(id)sender;
- (IBAction)backButtonTap:(id)sender;

@end
