//
//  SettingsViewController.h
//  Debate Timer
//
//  Created by Cormac Chester on 3/19/14.
//  Copyright (c) 2014 Testman Industries. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UISegmentedControl *centisecondSegControl;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic) NSUserDefaults *storeData;


- (IBAction)backButtonTap:(id)sender;
- (IBAction)centisecondValueChanged:(id)sender;


@end
