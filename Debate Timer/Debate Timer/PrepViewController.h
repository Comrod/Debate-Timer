//
//  PrepViewController.h
//  Debate Timer
//
//  Created by Cormac Chester on 3/20/14.
//  Copyright (c) 2014 Testman Industries. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrepViewController : UIViewController

//Your prep
@property (strong, nonatomic) IBOutlet UILabel *yourPrepLabel;
@property (strong, nonatomic) IBOutlet UIButton *yourPrepButton;
@property (nonatomic) NSTimer *yourPrepTimer;
@property (strong, nonatomic) IBOutlet UILabel *affNameLabel;

//Their prep
@property (strong, nonatomic) IBOutlet UILabel *theirPrepLabel;
@property (strong, nonatomic) IBOutlet UIButton *theirPrepButton;
@property (nonatomic) NSTimer *theirPrepTimer;
@property (strong, nonatomic) IBOutlet UILabel *negNameLabel;

@property (nonatomic) NSUserDefaults *storeData;


- (IBAction)yourPrepButtonTap:(id)sender;
- (IBAction)theirPrepButtonTap:(id)sender;
- (IBAction)resetYourPrepTap:(id)sender;
- (IBAction)resetTheirPrepTap:(id)sender;
- (IBAction)backButtonTap:(id)sender;



@end
