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

@property (nonatomic) int currentPhotoIndex;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.likeButton.enabled = NO;
    self.dislikeButton.enabled = NO;
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
    
}

- (IBAction)dislikeButtonPressed:(UIButton *)sender
{
    
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
            }
            else NSLog(@"%@", error);
        }];
        
    }
}







@end
