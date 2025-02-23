//
//  MatchViewController.h
//  Freyja
//
//  Created by Jose Manuel Ramirez Martinez on 04/01/15.
//  Copyright (c) 2015 Jose Manuel Ramírez Martínez. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MatchViewControllerDelegate <NSObject>

- (void)presentMatchesViewController;

@end

@interface MatchViewController : UIViewController

@property (strong, nonatomic) UIImage *matchedUserImage;
@property (weak, nonatomic) id <MatchViewControllerDelegate> delegate;

@end
