//
//  DetailViewController.h
//  MyFirstFacebookApp
//
//  Created by Tom on 22/01/14.
//  Copyright (c) 2014 Thomson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
