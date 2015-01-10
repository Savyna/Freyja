//
//  ChatsViewController.h
//  Freyja
//
//  Created by Jose Manuel Ramirez Martinez on 10/01/15.
//  Copyright (c) 2015 Jose Manuel Ramírez Martínez. All rights reserved.
//

#import "JSMessagesViewController.h"
#import <Parse/Parse.h>

@interface ChatsViewController : JSMessagesViewController

@property (strong, nonatomic) PFObject *chatRoom;

@end
