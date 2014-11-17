//
//  LoginViewController.m
//  Freyja
//
//  Created by Jose Manuel Ramirez Martinez on 17/11/14.
//  Copyright (c) 2014 Jose Manuel Ramírez Martínez. All rights reserved.
//

#import "LoginViewController.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "Constants.h"
#import <Parse/PFFile.h>

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSMutableData *imageData;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.activityIndicator.hidden = YES;
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

- (IBAction)loginButtonPressed:(UIButton *)sender
{
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    NSArray *permissionsArray = @[@"user_about_me", @"user_interests", @"user_relationships", @"user_birthday", @"user_location", @"user_relationship_details"];
    
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
        if ( !user ) {
            if ( !error ) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"The Facebook Login was Canceled" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alertView show];
            }
            else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login Error" message:[error description] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alertView show];
            }
        }
        else {
            [self updateUserInformation];
            [self performSegueWithIdentifier:@"loginToTabBarSegue" sender:self];
        }
    }];
}

#pragma mark - Helper Methods

- (void)updateUserInformation
{
    FBRequest *request = [FBRequest requestForMe];
    
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if ( !error ) {
            NSDictionary *userDictionary = (NSDictionary *)result;
            
            // create URL
            NSString *facebookID = userDictionary[@"id"];
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            NSMutableDictionary *userProfile = [[NSMutableDictionary alloc] initWithCapacity:8];

//            Use this to log the response into the console.
//            NSLog(@"%@", result);
            
            if ( userDictionary[@"name"] ) {
                userProfile[KUserProfileNameKey] = userDictionary[@"name"];
            }
            if ( userDictionary[@"first_name"]  ) {
                userProfile[KUserProfileFirstNameKey] = userDictionary[@"first_name"];
            }
            if ( userDictionary[@"location"][@"name"] ) {
                userProfile[KUserProfileLocationKey] = userDictionary[@"location"][@"name"];
            }
            if ( userDictionary[@"gender"] ) {
                userProfile[KUserProfileGenderKey] = userDictionary[@"gender"];
            }
            if ( userDictionary[@"birthday"] ) {
                userProfile[KUserProfileBirthdayKey] = userDictionary[@"birthday"];
            }
            if ( userDictionary[@"interested_in"] ) {
                userProfile[KUserProfileInterestedInKey] = userDictionary[@"interested_in"];
            }
            if ( [pictureURL absoluteString] ) {
                userProfile[kUserProfilePictureURL] = [pictureURL absoluteString];
            }
            
            [[PFUser currentUser] setObject:userProfile forKey:kUserProfileKey];
            [[PFUser currentUser] saveInBackground];
        }
        else {
            NSLog(@"Error in FB request %@", error);
        }
        
    }];
}

- (void)uploadPFFileToParse:(UIImage *)image
{
    NSLog(@"upload called");
    
    // JPEG to decrease file size and enable faster uploads & downloads
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    
    if ( !imageData ) {
        NSLog(@"imageData was not found.");
        return;
    }
    
    PFFile *photoFile = [PFFile fileWithData:imageData];
    [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ( succeeded ) {
            NSLog(@"Photo uploaded successfully");
            PFObject *photo = [PFObject objectWithClassName:kPhotoClassKey];
            [photo setObject:[PFUser currentUser] forKey:kPhotoUserKey];
            [photo setObject:photoFile forKey:kPhotoPictureKey];
            [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"Photo saved successfully");
            }];
        }
    }];
    
}

@end
