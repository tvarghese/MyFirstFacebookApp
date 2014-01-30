//
//  LoginUIViewController.m
//  MyFirstFacebookApp
//
//  Created by Tom on 23/01/14.
//  Copyright (c) 2014 Thomson. All rights reserved.
//

#import "LoginUIViewController.h"
#import "TabController.h"

@interface LoginUIViewController ()
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *monitorMyFeedButton;
@property (strong, nonatomic) id <FBGraphUser> loginUser;
@property (strong, nonatomic) NSMutableArray *relevantFeedStories;
- (void) initateUsersFeed;
@end

@implementation LoginUIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // Create a FBLoginView to log the user in with basic, email and likes permissions
        // You should ALWAYS ask for basic permissions (basic_info) when logging the user in
        FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"user_likes",@"user_checkins",@"user_friends",@"friends_checkins", @"friends_likes",@"read_stream" ]];
        
        // Set this loginUIViewController to be the loginView button's delegate
        loginView.delegate = self;
        
        // Align the button in the center horizontally
        loginView.frame = CGRectOffset(loginView.frame,
                                       (self.view.center.x - (loginView.frame.size.width / 2)),
                                       5);
        
        // Align the button in the center vertically
        loginView.center = self.view.center;
        
        // Add the button to the view
        [self.view addSubview:loginView];
    }
    return self;
}


// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    self.profilePictureView.profileID = user.id;
    self.nameLabel.text = user.name;
    self.loginUser = user;
}

// Implement the loginViewShowingLoggedInUser: delegate method to modify your app's UI for a logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    self.statusLabel.text = @"You're logged in as";
    [self initateUsersFeed];
}

// Implement the loginViewShowingLoggedOutUser: delegate method to modify your app's UI for a logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.profilePictureView.profileID = nil;
    self.nameLabel.text = @"";
    self.statusLabel.text= @"You're not logged in!";
    self.monitorMyFeedButton.hidden = YES;
}

// You need to override loginView:handleError in order to handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures since that happen outside of the app.
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"user_friends",@"user_photos", @"user_videos",@"user_photo_video_tags", @"friends_photo_video_tags", @"friends_photos",@"read_stream" ]];
    
    //@[@"user_videos",@"user_friends",@"user_photo_video_tags",@"user_status",@"user_photos",@"friends_photo_video_tags",@"friends_status", @"friends_photos",@"friends_videos",@"read_stream" ]
    
    // Set this loginUIViewController to be the loginView button's delegate
    loginView.delegate = self;
    
    // Align the button in the center horizontally
    loginView.frame = CGRectOffset(loginView.frame,
                                   (self.view.center.x - (loginView.frame.size.width / 2)),
                                   5);
    
    // Align the button in the center vertically
    loginView.center = self.view.center;
    
    // Add the button to the view
    [self.view addSubview:loginView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initateUsersFeed {
    /*[FBRequestConnection startWithGraphPath:@"/me?fields=albums.fields(name)"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
     
                              for (id <FBGraphObject> graphObject in (result[@"albums"])[@"data"] ) {
                                  if([graphObject[@"name"] isEqualToString:@"Profile Pictures"]){
                                      
                                      NSString *graphPath = [NSString stringWithFormat:@"%@?fields=photos.fields(picture,source,id,likes.limit(25))",graphObject[@"id"]];
                                      
                                      [FBRequestConnection startWithGraphPath:graphPath
                                                                   parameters:nil
                                                                   HTTPMethod:@"GET"
                                                            completionHandler:^(
                                                                                FBRequestConnection *connection,
                                                                                id result,
                                                                                NSError *error
                                                                                ) {
                                                                
                                                                for (id <FBGraphObject> graphObject in result[@"photos"][@"data"]){
                                                                    NSLog(@"%@",result);
                                                                    
                                                                    if (!_relevantFeedStories) {
                                                                        _relevantFeedStories = [[NSMutableArray alloc] init];
                                                                    }
                                                                    [self.relevantFeedStories addObject:graphObject];
                                                                    
                                                                }
                                                                
                                                            }];
                                      
                                  }
                              }
                            self.monitorMyFeedButton.hidden = NO;
                          }];
    
 */

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //    if ([[segue identifier] isEqualToString:@"showDetail"]) {
    //        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    //        NSDate *object = _objects[indexPath.row];
    //        [[segue destinationViewController] setDetailItem:object];
    //    }
    
    [(TabController *)[segue destinationViewController] setRelevantFeed:self.relevantFeedStories] ;
    
}
@end
