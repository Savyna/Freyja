//
//  ChatsViewController.m
//  Freyja
//
//  Created by Jose Manuel Ramirez Martinez on 10/01/15.
//  Copyright (c) 2015 Jose Manuel Ramírez Martínez. All rights reserved.
//

#import "ChatsViewController.h"
#import "Constants.h"

@interface ChatsViewController ()

@property (strong, nonatomic) PFUser *withUser;
@property (strong, nonatomic) PFUser *currentUser;

@property (strong, nonatomic) NSTimer *chatsTimer;
@property (nonatomic) BOOL initialLoadComplete;

@property (strong, nonatomic) NSMutableArray *chats;
@property (strong, nonatomic) PFObject *photo;

@end

@implementation ChatsViewController

- (NSMutableArray *)chats
{
    if ( !_chats ) {
        _chats = [[NSMutableArray alloc] init];
    }
    return _chats;
}

- (void)viewDidLoad {
    
    self.delegate   = self;
    self.dataSource = self;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // [[JSBubbleView appearance] setFont:[UIFont systemFontOfSize:16.0f]];
    [[JSBubbleView appearance] setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0f]];
    self.messageInputView.textView.placeHolder = @"New Message";
    [self setBackgroundColor:[UIColor whiteColor]];
    
    self.currentUser    = [PFUser currentUser];
    PFUser *testUser1   = self.chatRoom[kChatRoomUser1Key];
    
    if ( [testUser1.objectId isEqual:self.currentUser.objectId] ) {
        self.withUser = self.chatRoom[kChatRoomUser2Key];
    }
    else {
        self.withUser = self.chatRoom[kChatRoomUser1Key];
    }
    
    self.title                  = self.withUser[kUserProfileKey][kUserProfileFirstNameKey];
    self.initialLoadComplete    = NO;
    
    [self checkForNewChats];
    self.chatsTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(checkForNewChats) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.chatsTimer invalidate];
    self.chatsTimer = nil;
}


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
 
#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.chats count];
}

#pragma mark - TableView Delegate - REQUIRED

- (void)didSendText:(NSString *)text
{
    if ( text.length != 0 ) {
        
        PFObject *chat = [PFObject objectWithClassName:kChatClassKey];
        
        [chat setObject:self.chatRoom    forKey:kChatChatroomKey];
        [chat setObject:self.currentUser forKey:kChatFromUserKey];
        [chat setObject:self.withUser    forKey:kChatToUserKey];
        [chat setObject:text             forKey:kChatTextKey];
        
        [chat saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            [self.chats addObject:chat];
//            NSLog(@"%@", chat);
            [JSMessageSoundEffect playMessageSentSound];
            [self.tableView reloadData];
            [self finishSend];
            [self scrollToBottomAnimated:YES];
            
            PFQuery *pushQuery = [PFInstallation query];
            
            [pushQuery whereKey:@"deviceType" equalTo:@"ios"];
            // Send push notification to query
            [PFPush sendPushMessageToQueryInBackground:pushQuery
                                           withMessage:[chat objectForKey:@"text"]];
        }];
        
    }
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *chat          = self.chats[indexPath.row];
    PFUser *testFromUser    = chat[kChatFromUserKey];
    
    if ( [testFromUser.objectId isEqual:self.currentUser.objectId ] ) {
        return JSBubbleMessageTypeOutgoing;
    }
    else {
        return JSBubbleMessageTypeIncoming;
    }
}

- (UIImageView *)bubbleImageViewWithType:(JSBubbleMessageType)type forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *chat          = self.chats[indexPath.row];
    PFUser *testFromUser    = chat[kChatFromUserKey];
    
    if ( [testFromUser.objectId isEqual:self.currentUser.objectId ] ) {
        return [JSBubbleImageViewFactory bubbleImageViewForType:type color:[UIColor js_bubbleBlueColor]];
    }
    else {
        return [JSBubbleImageViewFactory bubbleImageViewForType:type color:[UIColor js_bubbleLightGrayColor]];
    }
}

- (JSMessagesViewTimestampPolicy)timestampPolicy
{
    return JSMessagesViewTimestampPolicyAll;
}

- (JSMessagesViewAvatarPolicy)avatarPolicy
{
    return JSMessagesViewAvatarPolicyNone;
}

- (JSMessagesViewSubtitlePolicy)subtitlePolicy
{
    return JSMessagesViewSubtitlePolicyNone;
}

- (JSMessageInputViewStyle)inputViewStyle
{
    return JSMessageInputViewStyleFlat;
}

#pragma mark - Messages View Delegate - OPTIONAL

- (void)configureCell:(JSBubbleMessageCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if ( [cell messageType] == JSBubbleMessageTypeOutgoing ) {
        cell.bubbleView.textView.textColor = [UIColor whiteColor];
    }
}

- (BOOL)shouldPreventScrollToBottomWhileUserScrolling
{
    return YES;
}

#pragma mark - Messages View Data Source - REQUIRED

- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *chat      = self.chats[indexPath.row];
    NSString *message   = chat[kChatTextKey];
    
    return message;
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (UIImageView *)avatarImageViewForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSString *)subtitleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - Helper Methods

- (void)checkForNewChats
{
    int oldChatCount        = [self.chats count];
    PFQuery *queryForChats  = [PFQuery queryWithClassName:kChatClassKey];
    
    [queryForChats whereKey:kChatChatroomKey equalTo:self.chatRoom];
    [queryForChats orderByAscending:@"createdAt"];
    
    [queryForChats findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if ( !error ) {
            if ( self.initialLoadComplete == NO || oldChatCount != [objects count] ) {
                
                self.chats = [objects mutableCopy];
                
                [self.tableView reloadData];
                
                if ( self.initialLoadComplete == YES ) {
                    [JSMessageSoundEffect playMessageReceivedSound];
                }
                
                self.initialLoadComplete = YES;
                [self scrollToBottomAnimated:YES];
            }
        }
    }];
}

@end
