//
//  Constants.h
//  Freyja
//
//  Created by Jose Manuel Ramirez Martinez on 17/11/14.
//  Copyright (c) 2014 Jose Manuel Ramírez Martínez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

#pragma mark - User Class

extern NSString *const KUserTagLineKey;

extern NSString *const kUserProfileKey;
extern NSString *const KUserProfileNameKey;
extern NSString *const KUserProfileFirstNameKey;
extern NSString *const KUserProfileLocationKey;
extern NSString *const KUserProfileGenderKey;
extern NSString *const KUserProfileBirthdayKey;
extern NSString *const KUserProfileInterestedInKey;
extern NSString *const kUserProfilePictureURL;
extern NSString *const kUserProfileRelationshipStatusKey;
extern NSString *const kUserProfileAgeKey;

#pragma mark - Photo Class

extern NSString *const kPhotoClassKey;
extern NSString *const kPhotoUserKey;
extern NSString *const kPhotoPictureKey;

#pragma mark - Activity Class

extern NSString *const kActivityClassKey;
extern NSString *const kActivityTypeKey;
extern NSString *const kActivityFromUserKey;
extern NSString *const kActivityToUserKey;
extern NSString *const kActivityPhotoKey;
extern NSString *const kActivityTypeLikeKey;
extern NSString *const kActivityTypeDislikeKey;

#pragma mark - Settings

extern NSString *const kMenEnabledKey;
extern NSString *const kWomenEnabledKey;
extern NSString *const kSingleEnabledKey;
extern NSString *const kAgeMaxKey;

@end
