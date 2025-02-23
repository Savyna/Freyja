//
//  MatchesViewController.m
//  Freyja
//
//  Created by Jose Manuel Ramirez Martinez on 04/01/15.
//  Copyright (c) 2015 Jose Manuel Ramírez Martínez. All rights reserved.
//

#import "MatchesViewController.h"
#import "ChatsViewController.h"
#import <Parse/Parse.h>
#import "Constants.h"

@interface MatchesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *avaliableChatRooms;

@end

@implementation MatchesViewController

#pragma mark - Lazy instantiation

-(NSMutableArray *)avaliableChatRooms
{
    if ( !_avaliableChatRooms ) {
        _avaliableChatRooms = [[NSMutableArray alloc] init];
    }
    return _avaliableChatRooms;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate     = self;
    self.tableView.dataSource   = self;

    [self updateAvailableChatRooms];
    NSLog(@"Enter MatchesViewController");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ChatsViewController *chatVC = segue.destinationViewController;
    NSIndexPath *indexPath      = sender;
    chatVC.chatRoom             = [self.avaliableChatRooms objectAtIndex:indexPath.row];
}


#pragma mark - Helper Methods

- (void)updateAvailableChatRooms
{
    PFQuery *query = [PFQuery queryWithClassName:@"ChatRoom"];
    [query whereKey:@"user1" equalTo:[PFUser currentUser]];
    
    PFQuery *queryInverse = [PFQuery queryWithClassName:@"ChatRoom"];

    [query whereKey:@"user2" equalTo:[PFUser currentUser]];
    
    PFQuery *queryCombined = [PFQuery orQueryWithSubqueries:@[query, queryInverse]];
    
    [queryCombined includeKey:@"chat"];
    [queryCombined includeKey:@"user1"];
    [queryCombined includeKey:@"user2"];
    
    [queryCombined findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ( !error ) {
            [self.avaliableChatRooms removeAllObjects];
            self.avaliableChatRooms = [objects mutableCopy];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.avaliableChatRooms count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    PFObject *chatRoom              = [self.avaliableChatRooms objectAtIndex:indexPath.row];
    PFUser *likedUser;
    PFUser *currentUser             = [PFUser currentUser];
    PFUser *testUser1               = chatRoom[@"user1"];
    
    if ( [testUser1.objectId isEqual:currentUser.objectId] ) {
        likedUser = [chatRoom objectForKey:@"user2"];
    }
    else {
        likedUser = [chatRoom objectForKey:@"user1"];
    }
    
    cell.textLabel.text = likedUser[@"profile"][@"name"];
    cell.detailTextLabel.text = @"";

    // cell.imageView.image = placeholder image
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    PFQuery *queryForPhoto = [[PFQuery alloc] initWithClassName:@"Photo"];
    [queryForPhoto whereKey:@"user" equalTo:likedUser];
    
    [queryForPhoto findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if ( [objects count] > 0 ) {
            
            PFObject *photo     = objects[0];
            PFFile *pictureFile = photo[kPhotoPictureKey];
            
            [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                
                // Rounded Image
                cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width / 2;
                cell.imageView.clipsToBounds = YES;
                
                cell.imageView.image        = [UIImage imageWithData:data];
                cell.imageView.contentMode  = UIViewContentModeScaleAspectFill;
                
                CGSize itemSize = CGSizeMake(58, 58);
                UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
                CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                [cell.imageView.image drawInRect:imageRect];
                cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();

            }];
        }
    }];
    
    return cell;
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"matchesToChatSegue" sender:indexPath];
}

@end
