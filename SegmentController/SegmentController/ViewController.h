//
//  ViewController.h
//  SegmentController
//
//  Created by ketan khare on 19/09/20.
//  Copyright © 2020. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic) IBOutlet UITableView *friendsListTable;

@end

