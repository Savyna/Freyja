//
//  TestUser.m
//  Freyja
//
//  Created by Jose Manuel Ramirez Martinez on 30/12/14.
//  Copyright (c) 2014 Jose Manuel Ramírez Martínez. All rights reserved.
//

#import "TestUser.h"
#import "Constants.h"
#import <Parse/Parse.h>

@implementation TestUser

+(void)saveTestUserToParse
{
    
    // GIRLS
    PFUser *newUser     = [PFUser user];
    newUser.username    = @"user1";
    newUser.password    = @"password1";
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ( !error ) {
            
            NSDictionary *profile = @{
                @"age" : @28,
                @"birthday" : @"11/22/1985",
                @"firstName" : @"Julie",
                @"gender" : @"female",
                @"location" : @"Berlin, Germany",
                @"name" : @"Julie Adams"
            };
            
            [newUser setObject:profile forKey:@"profile"];
            [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                UIImage *profileImage   = [UIImage imageNamed:@"User_Image.jpg"];
                NSLog(@"%@", profileImage);
                NSData *imageData       = UIImageJPEGRepresentation(profileImage, 0.8);
                PFFile *photoFile       = [PFFile fileWithData:imageData];
                
                [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
                    if ( succeeded ) {
                        
                        PFObject *photo = [PFObject objectWithClassName:kPhotoClassKey];
                        [photo setObject:newUser forKey:kPhotoUserKey];
                        [photo setObject:photoFile forKey:kPhotoPictureKey];
                        
                        [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            
                            NSLog(@"Photo saved successfully");
                        }];
                    }
                }];
            }];
        }
    }];
    
    
    PFUser *user2     = [PFUser user];
    user2.username    = @"user2";
    user2.password    = @"password1";
    
    [user2 signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ( !error ) {
            
            NSDictionary *profile = @{
                                      @"age" : @23,
                                      @"birthday" : @"07/06/1993",
                                      @"firstName" : @"Clare",
                                      @"gender" : @"female",
                                      @"location" : @"Barcelona, Spain",
                                      @"name" : @"Clare Smith"
                                      };
            
            [user2 setObject:profile forKey:@"profile"];
            [user2 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                UIImage *profileImage   = [UIImage imageNamed:@"girl1.jpg"];
                NSLog(@"%@", profileImage);
                NSData *imageData       = UIImageJPEGRepresentation(profileImage, 0.8);
                PFFile *photoFile       = [PFFile fileWithData:imageData];
                
                [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
                    if ( succeeded ) {
                        
                        PFObject *photo = [PFObject objectWithClassName:kPhotoClassKey];
                        [photo setObject:user2 forKey:kPhotoUserKey];
                        [photo setObject:photoFile forKey:kPhotoPictureKey];
                        
                        [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            
                            NSLog(@"Photo saved successfully");
                        }];
                    }
                }];
            }];
        }
    }];
    
    
    PFUser *user3     = [PFUser user];
    user3.username    = @"user3";
    user3.password    = @"password1";
    
    [user3 signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ( !error ) {
            
            NSDictionary *profile = @{
                                      @"age" : @28,
                                      @"birthday" : @"12/27/1987",
                                      @"firstName" : @"Marta",
                                      @"gender" : @"female",
                                      @"location" : @"Sabadell, Spain",
                                      @"name" : @"Marta Garcia"
                                      };
            
            [user3 setObject:profile forKey:@"profile"];
            [user3 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                UIImage *profileImage   = [UIImage imageNamed:@"girl2.jpg"];
                NSLog(@"%@", profileImage);
                NSData *imageData       = UIImageJPEGRepresentation(profileImage, 1.0);
                PFFile *photoFile       = [PFFile fileWithData:imageData];
                
                [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
                    if ( succeeded ) {
                        
                        PFObject *photo = [PFObject objectWithClassName:kPhotoClassKey];
                        [photo setObject:user3 forKey:kPhotoUserKey];
                        [photo setObject:photoFile forKey:kPhotoPictureKey];
                        
                        [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            
                            NSLog(@"Photo saved successfully");
                        }];
                    }
                }];
            }];
        }
    }];
    
    
    PFUser *user4     = [PFUser user];
    user4.username    = @"user4";
    user4.password    = @"password1";
    
    [user4 signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ( !error ) {
            
            NSDictionary *profile = @{
                                      @"age" : @24,
                                      @"birthday" : @"02/15/1990",
                                      @"firstName" : @"Sofia",
                                      @"gender" : @"female",
                                      @"location" : @"Sant Cugat, Spain",
                                      @"name" : @"Sofia Hernandez"
                                      };
            
            [user4 setObject:profile forKey:@"profile"];
            [user4 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                UIImage *profileImage   = [UIImage imageNamed:@"girl3.jpg"];
                NSLog(@"%@", profileImage);
                NSData *imageData       = UIImageJPEGRepresentation(profileImage, 0.8);
                PFFile *photoFile       = [PFFile fileWithData:imageData];
                
                [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
                    if ( succeeded ) {
                        
                        PFObject *photo = [PFObject objectWithClassName:kPhotoClassKey];
                        [photo setObject:user4 forKey:kPhotoUserKey];
                        [photo setObject:photoFile forKey:kPhotoPictureKey];
                        
                        [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            
                            NSLog(@"Photo saved successfully");
                        }];
                    }
                }];
            }];
        }
    }];
    
    
    PFUser *user5     = [PFUser user];
    user5.username    = @"user5";
    user5.password    = @"password1";
    
    [user5 signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ( !error ) {
            
            NSDictionary *profile = @{
                                      @"age" : @32,
                                      @"birthday" : @"04/08/1982",
                                      @"firstName" : @"Somai",
                                      @"gender" : @"female",
                                      @"location" : @"Terrassa, Spain",
                                      @"name" : @"Somai Berg"
                                      };
            
            [user5 setObject:profile forKey:@"profile"];
            [user5 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                UIImage *profileImage   = [UIImage imageNamed:@"girl4.jpg"];
                NSLog(@"%@", profileImage);
                NSData *imageData       = UIImageJPEGRepresentation(profileImage, 0.8);
                PFFile *photoFile       = [PFFile fileWithData:imageData];
                
                [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
                    if ( succeeded ) {
                        
                        PFObject *photo = [PFObject objectWithClassName:kPhotoClassKey];
                        [photo setObject:user5 forKey:kPhotoUserKey];
                        [photo setObject:photoFile forKey:kPhotoPictureKey];
                        
                        [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            
                            NSLog(@"Photo saved successfully");
                        }];
                    }
                }];
            }];
        }
    }];
    
    
    PFUser *user6     = [PFUser user];
    user6.username    = @"user6";
    user6.password    = @"password1";
    
    [user6 signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ( !error ) {
            
            NSDictionary *profile = @{
                                      @"age" : @23,
                                      @"birthday" : @"06/18/1991",
                                      @"firstName" : @"Marina",
                                      @"gender" : @"female",
                                      @"location" : @"Sabadell, Spain",
                                      @"name" : @"Marina Grey"
                                      };
            
            [user6 setObject:profile forKey:@"profile"];
            [user6 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                UIImage *profileImage   = [UIImage imageNamed:@"girl5.jpg"];
                NSLog(@"%@", profileImage);
                NSData *imageData       = UIImageJPEGRepresentation(profileImage, 0.8);
                PFFile *photoFile       = [PFFile fileWithData:imageData];
                
                [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
                    if ( succeeded ) {
                        
                        PFObject *photo = [PFObject objectWithClassName:kPhotoClassKey];
                        [photo setObject:user6 forKey:kPhotoUserKey];
                        [photo setObject:photoFile forKey:kPhotoPictureKey];
                        
                        [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            
                            NSLog(@"Photo saved successfully");
                        }];
                    }
                }];
            }];
        }
    }];
    
    
    /*
    // GUYS
    PFUser *user7     = [PFUser user];
    user7.username    = @"user7";
    user7.password    = @"password1";
    
    [user7 signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ( !error ) {
            
            NSDictionary *profile = @{
                                      @"age" : @28,
                                      @"birthday" : @"11/22/1992",
                                      @"firstName" : @"Mark",
                                      @"gender" : @"male",
                                      @"location" : @"Sant Cugat, Spain",
                                      @"name" : @"Mark Pleiton"
                                      };
            
            [user7 setObject:profile forKey:@"profile"];
            [user7 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                UIImage *profileImage   = [UIImage imageNamed:@"guy1.jpg"];
                NSLog(@"%@", profileImage);
                NSData *imageData       = UIImageJPEGRepresentation(profileImage, 0.8);
                PFFile *photoFile       = [PFFile fileWithData:imageData];
                
                [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
                    if ( succeeded ) {
                        
                        PFObject *photo = [PFObject objectWithClassName:kPhotoClassKey];
                        [photo setObject:user7 forKey:kPhotoUserKey];
                        [photo setObject:photoFile forKey:kPhotoPictureKey];
                        
                        [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            
                            NSLog(@"Photo saved successfully");
                        }];
                    }
                }];
            }];
        }
    }];
    
    
    PFUser *user8     = [PFUser user];
    user8.username    = @"user8";
    user8.password    = @"password1";
    
    [user8 signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ( !error ) {
            
            NSDictionary *profile = @{
                                      @"age" : @26,
                                      @"birthday" : @"01/12/1988",
                                      @"firstName" : @"Lucas",
                                      @"gender" : @"male",
                                      @"location" : @"Rubi, Spain",
                                      @"name" : @"Lucas Aguilar"
                                      };
            
            [user8 setObject:profile forKey:@"profile"];
            [user8 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                UIImage *profileImage   = [UIImage imageNamed:@"guy2.jpg"];
                NSLog(@"%@", profileImage);
                NSData *imageData       = UIImageJPEGRepresentation(profileImage, 0.8);
                PFFile *photoFile       = [PFFile fileWithData:imageData];
                
                [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
                    if ( succeeded ) {
                        
                        PFObject *photo = [PFObject objectWithClassName:kPhotoClassKey];
                        [photo setObject:user8 forKey:kPhotoUserKey];
                        [photo setObject:photoFile forKey:kPhotoPictureKey];
                        
                        [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            
                            NSLog(@"Photo saved successfully");
                        }];
                    }
                }];
            }];
        }
    }];
    
    
    PFUser *user9     = [PFUser user];
    user9.username    = @"user9";
    user9.password    = @"password1";
    
    [user9 signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ( !error ) {
            
            NSDictionary *profile = @{
                                      @"age" : @25,
                                      @"birthday" : @"11/22/1990",
                                      @"firstName" : @"Daniel",
                                      @"gender" : @"male",
                                      @"location" : @"Terrassa, Spain",
                                      @"name" : @"Daniel Alonso"
                                      };
            
            [user9 setObject:profile forKey:@"profile"];
            [user9 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                UIImage *profileImage   = [UIImage imageNamed:@"guy3.jpg"];
                NSLog(@"%@", profileImage);
                NSData *imageData       = UIImageJPEGRepresentation(profileImage, 0.8);
                PFFile *photoFile       = [PFFile fileWithData:imageData];
                
                [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
                    if ( succeeded ) {
                        
                        PFObject *photo = [PFObject objectWithClassName:kPhotoClassKey];
                        [photo setObject:user9 forKey:kPhotoUserKey];
                        [photo setObject:photoFile forKey:kPhotoPictureKey];
                        
                        [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            
                            NSLog(@"Photo saved successfully");
                        }];
                    }
                }];
            }];
        }
    }];
    */
}

@end
