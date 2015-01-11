//
//  Constants.m
//  Freyja
//
//  Created by Jose Manuel Ramirez Martinez on 17/11/14.
//  Copyright (c) 2014 Jose Manuel Ramírez Martínez. All rights reserved.
//

#import "Constants.h"

@implementation Constants

#pragma mark - User Class

NSString *const KUserTagLineKey                     = @"tagLine";

NSString *const kUserProfileKey                     = @"profile";
NSString *const KUserProfileNameKey                 = @"name";
NSString *const KUserProfileFirstNameKey            = @"firstName";
NSString *const KUserProfileLocationKey             = @"location";
NSString *const KUserProfileGenderKey               = @"gender";
NSString *const KUserProfileBirthdayKey             = @"birthday";
NSString *const KUserProfileInterestedInKey         = @"interestedIn";
NSString *const kUserProfilePictureURL              = @"pictureURL";
NSString *const kUserProfileRelationshipStatusKey   = @"relationshipStatus";
NSString *const kUserProfileAgeKey                  = @"age";

#pragma mark - Photo Class

NSString *const kPhotoClassKey                      = @"Photo";
NSString *const kPhotoUserKey                       = @"user";
NSString *const kPhotoPictureKey                    = @"image";

#pragma mark - Activity Class

NSString *const kActivityClassKey                   = @"Activity";
NSString *const kActivityTypeKey                    = @"type";
NSString *const kActivityFromUserKey                = @"fromUser";
NSString *const kActivityToUserKey                  = @"toUser";
NSString *const kActivityPhotoKey                   = @"photo";
NSString *const kActivityTypeLikeKey                = @"like";
NSString *const kActivityTypeDislikeKey             = @"dislike";

#pragma mark - Settings

NSString *const kMenEnabledKey                      = @"men";
NSString *const kWomenEnabledKey                    = @"women";
NSString *const kSingleEnabledKey                   = @"single";
NSString *const kAgeMaxKey                          = @"ageMax";

#pragma mark - ChatRoom

NSString *const kChatRoomClassKey                   = @"ChatRoom";
NSString *const kChatRoomUser1Key                   = @"user1";
NSString *const kChatRoomUser2Key                   = @"user2";

#pragma mark - Chat

NSString *const kChatClassKey                       = @"Chat";
NSString *const kChatChatroomKey                    = @"chatroom";
NSString *const kChatFromUserKey                    = @"fromUser";
NSString *const kChatToUserKey                      = @"toUser";
NSString *const kChatTextKey                        = @"text";

@end
