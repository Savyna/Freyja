//
//  SettingsViewController.m
//  Freyja
//
//  Created by Jose Manuel Ramirez Martinez on 18/11/14.
//  Copyright (c) 2014 Jose Manuel Ramírez Martínez. All rights reserved.
//

#import "SettingsViewController.h"
#import "Constants.h"
#import <Parse/Parse.h>

@interface SettingsViewController ()

@property (strong, nonatomic) IBOutlet UISlider *ageSlider;
@property (strong, nonatomic) IBOutlet UISwitch *menSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *womenSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *singleSwitch;
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) IBOutlet UIButton *editProfileButton;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.ageSlider.value    = [[NSUserDefaults standardUserDefaults] integerForKey:kAgeMaxKey];
    self.menSwitch.on       = [[NSUserDefaults standardUserDefaults] boolForKey:kMenEnabledKey];
    self.womenSwitch.on     = [[NSUserDefaults standardUserDefaults] boolForKey:kWomenEnabledKey];
    self.singleSwitch.on    = [[NSUserDefaults standardUserDefaults] boolForKey:kSingleEnabledKey];
    
    [self.ageSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.menSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.womenSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.singleSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.ageLabel.text      = [NSString stringWithFormat:@"%i", (int)self.ageSlider.value];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IBActions

- (IBAction)logoutButtonPressed:(UIButton *)sender
{
    [PFUser logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)editProfileButtonPressed:(UIButton *)sender
{
    
}

#pragma mark - Helper Methods

- (void)valueChanged:(id)sender
{
    // Instead of saving the user settings in Parse, we save it locally in the device for convenience.
    if ( sender == self.ageSlider ) {
        [[NSUserDefaults standardUserDefaults] setInteger:(int)self.ageSlider.value forKey:kAgeMaxKey];
        self.ageLabel.text = [NSString stringWithFormat:@"%i", (int)self.ageSlider.value];
    }
    else if ( sender == self.menSwitch ) {
        [[NSUserDefaults standardUserDefaults] setBool:self.menSwitch.isOn forKey:kMenEnabledKey];
    }
    else if ( sender == self.womenSwitch ) {
        [[NSUserDefaults standardUserDefaults] setBool:self.womenSwitch.isOn forKey:kWomenEnabledKey];
    }
    else if ( sender == self.singleSwitch ) {
        [[NSUserDefaults standardUserDefaults] setBool:self.singleSwitch.isOn forKey:kSingleEnabledKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}

@end
