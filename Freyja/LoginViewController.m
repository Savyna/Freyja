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
#import <Parse/Parse.h>

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

- (void)viewDidAppear:(BOOL)animated
{
    // Method to check if the user is logged in, and if they are you can segue past login
    if ( [PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]] ) {
        
        // If user changes his Facebook information, I want it to be reflected on my App
        [self updateUserInformation];
        [self performSegueWithIdentifier:@"loginToHomeSegue" sender:self];
        
    }
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
    NSLog(@"loginButtonPressed");
    // Unhide the activity indicator and start animating it
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    
    // Create an array with the information we will request access to from our user.
    NSArray *permissionsArray = @[@"user_about_me", @"user_interests", @"user_relationships", @"user_birthday", @"user_location", @"user_relationship_details"];
    
    // Use PFFacebookUtilis to request permission to login with facebook.
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
            // If the sign in is successful we update the users information and perform the segue to the Home Controller in the completion block.
            NSLog(@"Sign in success!");
            [self updateUserInformation];
            [self performSegueWithIdentifier:@"loginToHomeSegue" sender:self];
        }
    }];
}

#pragma mark - Helper Methods

- (void)updateUserInformation
{
    NSLog(@"updateUserInformation");
    // Issue a request to Facebook for the information we asked for access to in the permissions array
    FBRequest *request = [FBRequest requestForMe];
    
    // Start the request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if ( !error ) {
            // If we do not get an error in our Facebook request we use its information to create an NSMutableDictionary named userProfile
            NSDictionary *userDictionary = (NSDictionary *)result;
            
            // create URL
            NSString *facebookID = userDictionary[@"id"];
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=350&height=350&return_ssl_resources=1", facebookID]];
            
            NSMutableDictionary *userProfile = [[NSMutableDictionary alloc] initWithCapacity:8];

            // Use this to log the response into the console.
            // NSLog(@"%@", result);
            
            if ( userDictionary[@"name"] ) {
                userProfile[kUserProfileNameKey] = userDictionary[@"name"];
            }
            if ( userDictionary[@"first_name"]  ) {
                userProfile[kUserProfileFirstNameKey] = userDictionary[@"first_name"];
            }
            if ( userDictionary[@"location"][@"name"] ) {
                userProfile[kUserProfileLocationKey] = userDictionary[@"location"][@"name"];
            }
            if ( userDictionary[@"gender"] ) {
                userProfile[kUserProfileGenderKey] = userDictionary[@"gender"];
            }
            if ( userDictionary[@"birthday"] ) {
                
                userProfile[kUserProfileBirthdayKey] = userDictionary[@"birthday"];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateStyle:NSDateFormatterShortStyle];
                
                NSDate *date    = [formatter dateFromString:userDictionary[@"birthday"]];
                NSDate *now     = [NSDate date];
                NSTimeInterval seconds = [now timeIntervalSinceDate:date];
                int age = seconds / 31536000;
                userProfile[kUserProfileAgeKey] = @(age);
            }
            if ( userDictionary[@"interested_in"] ) {
                userProfile[kUserProfileInterestedInKey] = userDictionary[@"interested_in"];
            }
            if ( userDictionary[@"relationship_status"] ) {
                userProfile[kUserProfileRelationshipStatusKey] = userDictionary[@"relationship_status"];
            }
            if ( [pictureURL absoluteString] ) {
                userProfile[kUserProfilePictureURL] = [pictureURL absoluteString];
            }
            
            // Save the userProfile dictionary as the value for the key kUserProfileKey
            [[PFUser currentUser] setObject:userProfile forKey:kUserProfileKey];
            [[PFUser currentUser] saveInBackground];
            
            [self requestImage];
        }
        else {
            NSLog(@"Error in FB request %@", error);
        }
        
    }];
}


// Upload image file to Parse
- (void)uploadPFFileToParse:(UIImage *)image
{
    NSLog(@"upload called");
    
    // JPEG to decrease file size and enable faster uploads & downloads
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    
    if ( !imageData ) {
        NSLog(@"imageData was not found.");
        return;
    }
    
    // Create a PFFile with the NSData object to be stored in Parse
    PFFile *photoFile = [PFFile fileWithData:imageData];
    [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ( succeeded ) {
            
            // Create a PFObject of class Photo. Set the current user for its' user key and set the PFFile for its image key.
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

// Request our image from Parse
- (void)requestImage
{
    NSLog(@"requestImage called");
    // Create a query for the Photo class. Then constrain the query to search for only Photos for the current user. Finally, ask for the count of the number of Photos for the current user
    PFQuery *query = [PFQuery queryWithClassName:kPhotoClassKey];
    [query whereKey:kPhotoUserKey equalTo:[PFUser currentUser]];
    
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if ( number == 0 )
        {
            // Access the current user and then allocate and initialize the NSMutableData property named imageData.
            PFUser *user = [PFUser currentUser];
            self.imageData = [[NSMutableData alloc] init];
            
            // Create an NSURL object with the facebook picture URL we saved in the updateUserInformation method
            NSURL *profilePictureURL = [NSURL URLWithString:user[kUserProfileKey][kUserProfilePictureURL]];
            
            // Create a URL request using the default cache policy and a timeout of 4.0.
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:4.0f];
            
            // Make our request with NSURLConnection
            NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
            
            if ( !urlConnection ) {
                NSLog(@"Failed to Download Picture");
            }
        }
    }];
}

// Method will recieve the data from facebook's API and we will build our property imageData with the data.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"receiving data from facebook's API");
    // As chuncks of the image are received, we build our data file
    [self.imageData appendData:data];
}

// When the download finishes finishes upload the photo to Parse with the helper method uploadPFFileToParse.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectionDidFinishLoading");
    
    // All data has been downloaded, now we can set the image in the header image view
    UIImage *profileImage = [UIImage imageWithData:self.imageData];
    [self uploadPFFileToParse:profileImage];
}

@end
