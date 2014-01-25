//
//  MasterViewController.h
//  MyFirstFacebookApp
//
//  Created by Tom on 22/01/14.
//  Copyright (c) 2014 Thomson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (nonatomic) NSArray *relevantFeedStories;

@end
