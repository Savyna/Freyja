//
//  MatchViewController.m
//  Freyja
//
//  Created by Jose Manuel Ramirez Martinez on 04/01/15.
//  Copyright (c) 2015 Jose Manuel Ramírez Martínez. All rights reserved.
//

#import "MatchViewController.h"
#import <Parse/Parse.h>
#import "Constants.h"

@interface MatchViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *matchedUserImageView;
@property (strong, nonatomic) IBOutlet UIImageView *currentUserImageView;
@property (strong, nonatomic) IBOutlet UIButton *viewChatsButton;
@property (strong, nonatomic) IBOutlet UIButton *keepSearchingButton;
@property (strong, nonatomic) IBOutlet UIView *matchContainerView;
@property (strong, nonatomic) IBOutlet UIView *user1ContainerView;
@property (strong, nonatomic) IBOutlet UIView *user2ContainerView;

@end

@implementation MatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    [self addShadowForView:self.matchContainerView];
    [self addShadowForView:self.user1ContainerView];
    [self addShadowForView:self.user2ContainerView];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gplaypattern_@2X.png"]];
    
    PFQuery *query = [PFQuery queryWithClassName:kPhotoClassKey];
    
    [query whereKey:kPhotoUserKey equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        // User has a photo, download it in background
        if ( [objects count] > 0 ) {
            
            PFObject *photo     = objects[0];
            PFFile *pictureFile = photo[kPhotoPictureKey];
            
            [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                
                self.currentUserImageView.image = [UIImage imageWithData:data];
                self.currentUserImageView.contentMode  = UIViewContentModeScaleAspectFit;
                self.matchedUserImageView.image = self.matchedUserImage;
                self.matchedUserImageView.contentMode  = UIViewContentModeScaleAspectFit;
            }];
        }
    }];
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

- (IBAction)viewChatsButtonPressed:(id)sender
{
//    NSLog(@"Enter viewChatsButtonPressed");
    [self.delegate presentMatchesViewController];
}


- (IBAction)keepSearchingButtonPressed:(id)sender
{
//    NSLog(@"Enter keepSearchingButtonPressed");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
