//
//  ViewController.h
//  Debate Timer
//
//  Created by Cormac Chester on 3/18/14.
//  Copyright (c) 2014 Extreme Images Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *policyButton;
@property (strong, nonatomic) IBOutlet UIButton *ldButton;
@property (strong, nonatomic) IBOutlet UIButton *pfButton;
@property (nonatomic) NSInteger whatStyle;
@property (nonatomic) NSInteger prepTime;
@property (nonatomic) NSUserDefaults *storeData;

- (IBAction)tapPolicyButton:(id)sender;
- (IBAction)tapLDButton:(id)sender;
- (IBAction)tapPFButton:(id)sender;


@end
