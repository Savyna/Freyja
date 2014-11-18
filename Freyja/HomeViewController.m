//
//  HomeViewController.m
//  Freyja
//
//  Created by Jose Manuel Ramirez Martinez on 18/11/14.
//  Copyright (c) 2014 Jose Manuel Ramírez Martínez. All rights reserved.
//

#import "HomeViewController.h"
#import <Parse/Parse.h>

@interface HomeViewController ()

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
    
    //self.likeButton.enabled = NO;
    //self.dislikeButton.enabled = NO;
    self.infoButton.enabled = NO;
    
    self.currentPhotoIndex = 0;
    
    // Query to the Photo Class in Parse
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query includeKey:@"user"];
    
    // Asynchronous access Parse API and get the items in a background thread
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ( !error ) {
            self.photos = objects;
            [self queryForCurrentPhotoIndex];
        }
        else NSLog(@"%@", error);
    }];
    
    // do additional
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
    [self checkLike];
}

- (IBAction)dislikeButtonPressed:(UIButton *)sender
{
    [self checkDislike];
}

- (IBAction)infoButtonPressed:(UIButton *)sender
{
    
}

- (IBAction)chatBarButtonPressed:(UIBarButtonItem *)sender
{
    
}

- (IBAction)settingsBarButtonItemPressed:(UIBarButtonItem *)sender
{
    
    
}

#pragma marks - Helper Methods

- (void)queryForCurrentPhotoIndex
{
    if ( [self.photos count] > 0 ) {
        self.photo = self.photos[self.currentPhotoIndex];
        
        // Pointer to the file
        PFFile *file = self.photo[@"image"];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if ( !error ) {
                UIImage *image = [UIImage imageWithData:data];
                self.photoImageView.image = image;
                [self updateView];
            }
            else NSLog(@"%@", error);
        }];
        
    }
}

- (void)updateView
{
    self.firstNameLabel.text = self.photo[@"user"][@"profile"][@"firstName"];
    self.ageLabel.text = [NSString stringWithFormat:@"%@", self.photo[@"user"][@"profile"][@"age"]];
    self.tagLineLabel.text = self.photo[@"user"][@"tagLine"];
}

- (void)setupNextPhoto
{
    if ( self.currentPhotoIndex +1 < self.photos.count ) {
        self.currentPhotoIndex ++;
        [self queryForCurrentPhotoIndex];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No More Users to View" message:@"Check back later for more people!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)saveLike
{
    // Creates a new class called Activity in Parse
    PFObject *likeActivity = [PFObject objectWithClassName:@"Activity"];
    
    // Store the like in the background for the key type, the user from is doing the liking, adn the user who is being liked
    // and the photo involved in the liking as well.
    [likeActivity setObject:@"like" forKey:@"type"];
    [likeActivity setObject:[PFUser currentUser] forKey:@"fromUser"];
    [likeActivity setObject:[self.photo objectForKey:@"user"] forKey:@"toUser"];
    [likeActivity setObject:self.photo forKey:@"photo"];
    
    [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.isLikedByCurrentUser = YES;
        self.isDislikedByCurrentUser = NO;
        [self.activities addObject:likeActivity];
        
        // Setup the next photo, and save the like of the current one to Parse
        [self setupNextPhoto];
    }];
}

- (void)saveDislike
{
    // Creates a new class called Activity in Parse
    PFObject *dislikeActivity = [PFObject objectWithClassName:@"Activity"];
    
    // Store the dislike in the background for the key type, the user from is doing the disliking, adn the user who is being disliked
    // and the photo involved in the disliking as well.
    [dislikeActivity setObject:@"dislike" forKey:@"type"];
    [dislikeActivity setObject:[PFUser currentUser] forKey:@"fromUser"];
    [dislikeActivity setObject:[self.photo objectForKey:@"user"] forKey:@"toUser"];
    [dislikeActivity setObject:self.photo forKey:@"photo"];
    
    [dislikeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.isLikedByCurrentUser = NO;
        self.isDislikedByCurrentUser = YES;
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

@end
