//
//  HomeViewController.m
//  Freyja
//
//  Created by Jose Manuel Ramirez Martinez on 18/11/14.
//  Copyright (c) 2014 Jose Manuel Ramírez Martínez. All rights reserved.
//

#import "HomeViewController.h"
#import "ProfileViewController.h"
#import "MatchViewController.h"
#import "Constants.h"
#import <Parse/Parse.h>
#import "TestUser.h"

@interface HomeViewController () <MatchViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *chatBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *settingsBarButtonItem;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *tagLineLabel;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) IBOutlet UIButton *dislikeButton;

@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) PFObject *photo;
@property (strong, nonatomic) NSMutableArray *activities;

@property (nonatomic) int currentPhotoIndex;
@property (nonatomic) BOOL isLikedByCurrentUser;
@property (nonatomic) BOOL isDislikedByCurrentUser;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[TestUser saveTestUserToParse];
    
    // do additional
}

- (void)viewDidAppear:(BOOL)animated
{
    self.photoImageView.image   = nil;
    self.firstNameLabel.text    = nil;
    self.ageLabel.text          = nil;
    
    self.likeButton.enabled     = NO;
    self.dislikeButton.enabled  = NO;
    self.infoButton.enabled     = NO;
    self.currentPhotoIndex      = 0;
    
    // Query to the Photo Class in Parse
    PFQuery *query = [PFQuery queryWithClassName:kPhotoClassKey];
    [query whereKey:kPhotoUserKey notEqualTo:[PFUser currentUser]];
    [query includeKey:kPhotoUserKey];
    
    // Asynchronous access Parse API and get the items in a background thread
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ( !error ) {
            
            self.photos = objects;
            
            if ( [self allowPhoto] == NO ) {
                [self setupNextPhoto];
            }
            else {
                [self queryForCurrentPhotoIndex];
            }
        }
        else NSLog(@"%@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSLog(@"prepareForSegue called in HomeViewController");
    NSLog(@"segue.identifier: %@, %@", segue.identifier, sender);
    
    if ( [segue.identifier isEqualToString:@"homeToProfileSegue"] ) {
        
        ProfileViewController *profileVC = segue.destinationViewController;
        profileVC.photo = self.photo;
    }
    else if ( [segue.identifier isEqualToString:@"homeToMatchSegue"] ) {

        MatchViewController *matchVC    = segue.destinationViewController;
        matchVC.matchedUserImage        = self.photoImageView.image;
        matchVC.delegate                = self;
    }
}


#pragma mark - IBActions

- (IBAction)likeButtonPressed:(UIButton *)sender
{
    [self checkLike];
}

- (IBAction)dislikeButtonPressed:(UIButton *)sender
{
    [self checkDislike];
}

- (IBAction)infoButtonPressed:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"homeToProfileSegue" sender:nil];
}

- (IBAction)chatBarButtonPressed:(UIBarButtonItem *)sender
{
    
}

- (IBAction)settingsBarButtonItemPressed:(UIBarButtonItem *)sender
{
    
    
}

#pragma mark - Helper Methods

- (void)queryForCurrentPhotoIndex
{
    if ( [self.photos count] > 0 ) {
        
        self.photo      = self.photos[self.currentPhotoIndex];
        // Pointer to the file
        PFFile *file    = self.photo[kPhotoPictureKey];
        
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if ( !error ) {
                
                UIImage *image = [UIImage imageWithData:data];
                self.photoImageView.image = image;
                [self updateView];
            }
            else NSLog(@"%@", error);
        }];
        
        PFQuery *queryForLike = [PFQuery queryWithClassName:kActivityClassKey];
        [queryForLike whereKey:kActivityTypeKey equalTo:kActivityTypeLikeKey];
        [queryForLike whereKey:kActivityPhotoKey equalTo:self.photo];
        [queryForLike whereKey:kActivityFromUserKey equalTo:[PFUser currentUser]];
        
        PFQuery *queryForDislike = [PFQuery queryWithClassName:kActivityClassKey];
        [queryForDislike whereKey:kActivityTypeKey equalTo:kActivityTypeDislikeKey];
        [queryForDislike whereKey:kActivityPhotoKey equalTo:self.photo];
        [queryForDislike whereKey:kActivityFromUserKey equalTo:[PFUser currentUser]];
        
        // Join Queries
        PFQuery *likeAndDislikeQuery = [PFQuery orQueryWithSubqueries:@[queryForLike, queryForDislike]];
        // Run Query in a background thread
        [likeAndDislikeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if ( !error ) {
                
                self.activities = [objects mutableCopy];
                
                if ( [self.activities count] == 0 ) {
                    
                    self.isLikedByCurrentUser        = NO;
                    self.isDislikedByCurrentUser     = NO;
                }
                else {
                    PFObject *activity = self.activities[0];
                    
                    if ( [activity[kActivityTypeKey] isEqualToString:kActivityTypeLikeKey] ) {
                        
                        self.isLikedByCurrentUser    = YES;
                        self.isDislikedByCurrentUser = NO;
                    }
                    else if ( [activity[kActivityTypeKey] isEqualToString:kActivityTypeDislikeKey] ) {
                        
                        self.isLikedByCurrentUser    = NO;
                        self.isDislikedByCurrentUser = YES;
                    }
                    else {
                        // Some other type of activity
                    }
                }
                self.likeButton.enabled     = YES;
                self.dislikeButton.enabled  = YES;
                self.infoButton.enabled     = YES;
            }
        }];
    }
}

- (void)updateView
{
    self.firstNameLabel.text    = self.photo[kPhotoUserKey][kUserProfileKey][KUserProfileFirstNameKey];
    self.ageLabel.text          = [NSString stringWithFormat:@"%@", self.photo[kPhotoUserKey][kUserProfileKey][kUserProfileAgeKey]];
    self.tagLineLabel.text      = self.photo[kPhotoUserKey][KUserTagLineKey];
}

- (void)setupNextPhoto
{
    if ( self.currentPhotoIndex +1 < self.photos.count ) {
        
        self.currentPhotoIndex ++;
        
        if ( [self allowPhoto] == NO ) {
            [self setupNextPhoto];
        }
        else {
            [self queryForCurrentPhotoIndex];
        }
    }
    else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No More Users to View" message:@"Check back later for more people!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

- (BOOL)allowPhoto
{
    int maxAge        = [[NSUserDefaults standardUserDefaults] integerForKey:kAgeMaxKey];
    BOOL men          = [[NSUserDefaults standardUserDefaults] boolForKey:kMenEnabledKey];
    BOOL women        = [[NSUserDefaults standardUserDefaults] boolForKey:kWomenEnabledKey];
    BOOL single       = [[NSUserDefaults standardUserDefaults] boolForKey:kSingleEnabledKey];
    
    PFObject *photo   = self.photos[self.currentPhotoIndex];
    PFUser *user      = photo[kPhotoUserKey];
    
    int userAge       = [user[kUserProfileKey][kUserProfileAgeKey] intValue];
    NSString *gender  = user[kUserProfileKey][KUserProfileGenderKey];
    NSString *relationshipStatus = user[kUserProfileKey][kUserProfileRelationshipStatusKey];
    
    if ( userAge > maxAge ) {
        return NO;
    }
    else if ( men == NO && [gender isEqualToString:@"male"] ) {
        return NO;
    }
    else if ( women == NO && [gender isEqualToString:@"female"]) {
        return NO;
    }
    else if ( single == NO && ([relationshipStatus isEqualToString:@"single"] || relationshipStatus == nil )) {
        return NO;
    }
    else {
        return YES;
    }
}

- (void)saveLike
{
    // Creates a new class called Activity in Parse
    PFObject *likeActivity = [PFObject objectWithClassName:kActivityClassKey];
    
    // Store the like in the background for the key type, the user from is doing the liking, adn the user who is being liked
    // and the photo involved in the liking as well.
    [likeActivity setObject:kActivityTypeLikeKey forKey:kActivityTypeKey];
    [likeActivity setObject:[PFUser currentUser] forKey:kActivityFromUserKey];
    [likeActivity setObject:[self.photo objectForKey:kPhotoUserKey] forKey:kActivityToUserKey];
    [likeActivity setObject:self.photo forKey:kActivityPhotoKey];
    
    [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        self.isLikedByCurrentUser       = YES;
        self.isDislikedByCurrentUser    = NO;
        [self.activities addObject:likeActivity];
        
        [self checkForPhotoUserLikes];
        // Setup the next photo, and save the like of the current one to Parse
        [self setupNextPhoto];
    }];
}

- (void)saveDislike
{
    // Creates a new class called Activity in Parse
    PFObject *dislikeActivity = [PFObject objectWithClassName:kActivityClassKey];
    
    // Store the dislike in the background for the key type, the user from is doing the disliking, adn the user who is being disliked
    // and the photo involved in the disliking as well.
    [dislikeActivity setObject:kActivityTypeDislikeKey forKey:kActivityTypeKey];
    [dislikeActivity setObject:[PFUser currentUser] forKey:kActivityFromUserKey];
    [dislikeActivity setObject:[self.photo objectForKey:kPhotoUserKey] forKey:kActivityToUserKey];
    [dislikeActivity setObject:self.photo forKey:kActivityPhotoKey];
    
    [dislikeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        self.isLikedByCurrentUser       = NO;
        self.isDislikedByCurrentUser    = YES;
        [self.activities addObject:dislikeActivity];
        
        // Setup the next photo, and save the like of the current one to Parse
        [self setupNextPhoto];
    }];
}

- (void)checkLike
{
    if ( self.isLikedByCurrentUser ) {
        
        [self setupNextPhoto];
        return;
    }
    else if ( self.isDislikedByCurrentUser ) {
        
        for ( PFObject *activity in self.activities ) {
            [activity deleteInBackground];
        }
        [self.activities removeLastObject];
        [self saveLike];
    }
    else {
        [self saveLike];
    }
}

- (void)checkDislike
{
    if ( self.isDislikedByCurrentUser ) {
        
        [self setupNextPhoto];
        return;
    }
    else if ( self.isLikedByCurrentUser ) {
        
        for ( PFObject *activity in self.activities ) {
            [activity deleteInBackground];
        }
        [self.activities removeLastObject];
        [self saveDislike];
    }
    else {
        [self saveDislike];
    }
}

- (void)checkForPhotoUserLikes
{
    PFQuery *query = [PFQuery queryWithClassName:kActivityClassKey];
    
    [query whereKey:kActivityFromUserKey equalTo:self.photo[kPhotoUserKey]];
    [query whereKey:kActivityToUserKey equalTo:[PFUser currentUser]];
    [query whereKey:kActivityTypeKey equalTo:kActivityTypeLikeKey];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if ( [objects count] > 0 ) {
            // create our chatroom
            [self createChatRoom];
        }
    }];
}

- (void)createChatRoom
{
    NSLog(@"createChatRoom called");
    
    PFQuery *queryForChatRoom = [PFQuery queryWithClassName:kChatRoomClassKey];
    
    [queryForChatRoom whereKey:kChatRoomUser1Key equalTo:[PFUser currentUser]];
    [queryForChatRoom whereKey:kChatRoomUser2Key equalTo:self.photo[kPhotoUserKey]];
    
    PFQuery *queryForChatRoomInverse = [PFQuery queryWithClassName:kChatRoomClassKey];
    [queryForChatRoomInverse whereKey:kChatRoomUser1Key equalTo:self.photo[kPhotoUserKey]];
    [queryForChatRoomInverse whereKey:kChatRoomUser2Key equalTo:[PFUser currentUser]];
    
    PFQuery *combinedQuery = [PFQuery orQueryWithSubqueries:@[queryForChatRoom, queryForChatRoomInverse]];

    [combinedQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        NSLog(@"Number of ChatRooms: %lu", (unsigned long)[objects count]);
        if ( error ){
            NSLog(@"%@", error);
        }
        
        else if ( [objects count] == 0 ) {

            PFObject *chatroom = [PFObject objectWithClassName:kChatRoomClassKey];
            [chatroom setObject:[PFUser currentUser] forKey:kChatRoomUser1Key];
            [chatroom setObject:self.photo[kPhotoUserKey] forKey:kChatRoomUser2Key];
            
            [chatroom saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"Success: %i", succeeded);
                if ( error ) {
                    NSLog(@"%@", error);
                }

                [self performSegueWithIdentifier:@"homeToMatchSegue" sender:nil];
            }];
        }
    }];
}

#pragma mark - MatchViewControllerDelegate

- (void) presentMatchesViewController
{
    NSLog(@"presentMatchesViewController called");
    [self dismissViewControllerAnimated:NO completion:^{
        [self performSegueWithIdentifier:@"homeToMatchesSegue" sender:nil];
    }];
}

@end
