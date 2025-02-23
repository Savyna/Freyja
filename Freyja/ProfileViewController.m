//
//  ProfileViewController.m
//  Freyja
//
//  Created by Jose Manuel Ramirez Martinez on 18/11/14.
//  Copyright (c) 2014 Jose Manuel Ramírez Martínez. All rights reserved.
//

#import "ProfileViewController.h"
#import "Constants.h"

@interface ProfileViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UITextView *tagLineTextView;
@property (strong, nonatomic) IBOutlet UIView *likeButtonContainerView;
@property (strong, nonatomic) IBOutlet UIView *dislikeButtonContainerView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PFFile *pictureFile = self.photo[kPhotoPictureKey];
    
    [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        
        self.profilePictureImageView.image = [UIImage imageWithData:data];
    }];
    
    PFUser *user = self.photo[kPhotoUserKey];

    
    if ( user[kUserProfileKey][kUserProfileLocationKey] == nil ) {
        self.locationLabel.text = @"No location avaiable";
    }
    else {
        self.locationLabel.text = user[kUserProfileKey][kUserProfileLocationKey];
    }
    
    if ( user[kUserProfileKey][kUserProfileRelationshipStatusKey] == nil ) {
        self.statusLabel.text = @"Single";
    }
    else {
        self.statusLabel.text = user[kUserProfileKey][kUserProfileRelationshipStatusKey];
    }
    
    if ( user[kUserTagLineKey] == nil ) {
        self.tagLineTextView.text = @"No more additional information avaiable.";
    }
    else {
        self.tagLineTextView.text = user[kUserTagLineKey];
    }
    
    self.ageLabel.text          = [NSString stringWithFormat:@"%@", user[kUserProfileKey][kUserProfileAgeKey]];
    
    self.view.backgroundColor   = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    [self addShadowForView:self.likeButtonContainerView];
    [self addShadowForView:self.dislikeButtonContainerView];
    self.title                  = user[kUserProfileKey][kUserProfileFirstNameKey];
}

- (void)addShadowForView:(UIView *)view
{
    view.layer.masksToBounds    = NO;
    view.layer.cornerRadius     = 4;
    view.layer.shadowRadius     = 1;
    view.layer.shadowOffset     = CGSizeMake(0, 1);
    view.layer.shadowOpacity    = 0.25;
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

- (IBAction)likeButtonPressed:(UIButton *)sender
{
    [self.delegate didPressLike];
}

- (IBAction)dislikeButtonPressed:(UIButton *)sender
{
    [self.delegate didPressDislike];
}

@end
