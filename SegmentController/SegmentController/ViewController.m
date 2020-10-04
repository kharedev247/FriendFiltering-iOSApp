//
//  ViewController.m
//  SegmentController
//
//  Created by ketan khare on 19/09/20.
//  Copyright © 2020. All rights reserved.
//

#import "ViewController.h"
#import "FriendDetailCell.h"
#import "FriendDetail.h"

@interface ViewController () {
    NSMutableArray *favouriteFriends;
    NSMutableArray *friends;
    NSMutableArray *schoolFriendsList;
    NSMutableArray *collegeFriendList;
    NSMutableArray *headerTitleList;
    NSMutableArray *isCollapsed;
    NSMutableArray *allSelectedForSection;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.friendsListTable registerNib:[UINib nibWithNibName:@"FriendDetailCell" bundle:nil] forCellReuseIdentifier:@"FriendDetailCell"];
    [self.segmentControl addTarget:self action:@selector(segmentControlAction:) forControlEvents:UIControlEventValueChanged];
    favouriteFriends = [[NSMutableArray alloc] init];
    [self initialiseFriendsList:@"Sc"];
    [self initialiseFriendsList:@"Co"];
    isCollapsed = [[NSMutableArray alloc] initWithObjects:@YES, @YES, nil];
    allSelectedForSection = [[NSMutableArray alloc] initWithObjects:@NO, @NO, nil];
    headerTitleList = [[NSMutableArray alloc] initWithObjects:@"My School Friends",@"My College Friends", nil];
    friends = [[NSMutableArray alloc] initWithObjects:schoolFriendsList, collegeFriendList, nil];
}

#pragma mark - TableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.segmentControl.selectedSegmentIndex == 1) {
        return 1;
    }
    return friends.count;
}

// this we will take from the json file which will have friends info
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.segmentControl.selectedSegmentIndex == 1) {
        return favouriteFriends.count;
    } else {
        if ([isCollapsed[section] isEqual:@YES]) {
            return 0;
        } else {
            switch (section) {
                case 0:
                    return schoolFriendsList.count;
                case 1:
                    return collegeFriendList.count;
                default:
                    return 0;
            }
        }
    }
}

// update header view here
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView  *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    
    UIButton *collapseButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 10, 20, 20)];
    if ([isCollapsed[section] isEqual:@YES]) {
        [collapseButton setImage:[UIImage imageNamed:@"expand-arrow"] forState:UIControlStateNormal];
    } else {
        [collapseButton setImage:[UIImage imageNamed:@"collapse-arrow"] forState:UIControlStateNormal];
    }
    [collapseButton setTag:section];
    [collapseButton addTarget:self action:@selector(collapseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *selectAllButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40, 5, 30, 30)];
    if ([allSelectedForSection[section] isEqual:@NO]) {
        [selectAllButton setImage:[UIImage imageNamed:@"unchecked-checkbox"] forState:UIControlStateNormal];
    } else {
        [selectAllButton setImage:[UIImage imageNamed:@"checked-checkbox"] forState:UIControlStateNormal];
    }
    [selectAllButton setTag:section];
    [selectAllButton addTarget:self action:@selector(selectAllSectionClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, self.view.frame.size.width, 40)];
    [headerView setBackgroundColor:[UIColor yellowColor]];
    if (self.segmentControl.selectedSegmentIndex == 0) {
        label.text = headerTitleList[section];
    } else {
        label.text = @"Favourite Friends";
    }
    label.textColor = [UIColor blackColor];
   
    [headerView addSubview: collapseButton];
    [headerView addSubview: label];
    [headerView addSubview: selectAllButton];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.segmentControl.selectedSegmentIndex == 1) {
        return 0;
    }
    return 40;
}

// this method is from UITableViewDataSourceDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendDetailCell *cell = (FriendDetailCell *)[tableView dequeueReusableCellWithIdentifier:@"FriendDetailCell"];
    if (self.segmentControl.selectedSegmentIndex == 0) {
        FriendDetail *friend;
        switch (indexPath.section) {
            case 0:
                friend = (FriendDetail *)[schoolFriendsList objectAtIndex:indexPath.row];
                cell.lableOfCell.text = friend.name;
                break;
            case 1:
                friend =(FriendDetail *)[collegeFriendList objectAtIndex:indexPath.row];
                cell.lableOfCell.text = friend.name;
            default:
                break;
        }
        if ([favouriteFriends containsObject:friend.name]) {
            [cell.selectCheckBox setImage:[UIImage imageNamed:@"checked-checkbox"]];
        } else {
            [cell.selectCheckBox setImage:[UIImage imageNamed:@"unchecked-checkbox"]];
        }
        cell.isFavCheckBox.tag = indexPath.row;
        cell.selectCheckBox.hidden = false;
        [cell.isFavCheckBox addTarget:self action:@selector(selectedRow:) forControlEvents:UIControlEventTouchUpInside];
    } else if (self.segmentControl.selectedSegmentIndex == 1) {
        if (favouriteFriends.count > indexPath.row) {
            cell.lableOfCell.text = [favouriteFriends objectAtIndex:indexPath.row];
        }
        cell.selectCheckBox.hidden = true;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark - Segment Controller

-(void)segmentControlAction:(UISegmentedControl *)segment {
    [self.friendsListTable reloadData];
}

#pragma mark - Utility functions

-(IBAction)selectedRow:(UIButton *)selectedRow {
    UITableViewCell *cell = (UITableViewCell *)[[selectedRow superview] superview];
    NSIndexPath *indexPath = [self.friendsListTable indexPathForCell:cell];
    NSMutableArray *friendList = [friends objectAtIndex:indexPath.section];
    FriendDetail *friend =((FriendDetail *)[friendList objectAtIndex:selectedRow.tag]);
    if ([favouriteFriends containsObject:friend.name]){
        [favouriteFriends removeObject:friend.name];
    } else {
        [favouriteFriends addObject:friend.name];
    }
    [self.friendsListTable reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
}

-(IBAction)selectAllSectionClick:(UIButton *)selectAllButton {
    if ([allSelectedForSection[selectAllButton.tag] isEqual:@NO]) {
        allSelectedForSection[selectAllButton.tag] = @YES;
        for(int i=0; i<[[friends objectAtIndex: selectAllButton.tag] count]; i ++) {
            if (![favouriteFriends containsObject:((FriendDetail *)[[friends objectAtIndex:selectAllButton.tag] objectAtIndex:i]).name])
            {
                [favouriteFriends addObject:((FriendDetail *)[[friends objectAtIndex:selectAllButton.tag] objectAtIndex:i]).name];
            }
        }
    } else {
        allSelectedForSection[selectAllButton.tag] = @NO;
        for(int i=0; i<[[friends objectAtIndex: selectAllButton.tag] count]; i ++) {
            FriendDetail *friend =(FriendDetail *)[[friends objectAtIndex:selectAllButton.tag] objectAtIndex:i];
            if ([favouriteFriends containsObject:friend.name])
            {
                [favouriteFriends removeObject:friend.name];
            }
        }
    }
   
    [self.friendsListTable reloadSections:[NSIndexSet indexSetWithIndex:selectAllButton.tag] withRowAnimation:UITableViewRowAnimationFade];
}

-(IBAction)collapseButtonClick:(UIButton *)collapseButton {
    if ([isCollapsed[collapseButton.tag] isEqual:@YES]) {
        isCollapsed[collapseButton.tag] = @NO;
    } else {
        isCollapsed[collapseButton.tag] = @YES;
    }
    [self.friendsListTable reloadSections:[NSIndexSet indexSetWithIndex:collapseButton.tag] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)initialiseFriendsList:(NSString *)prefix {
    if ([prefix isEqualToString:@"Sc"]) {
        schoolFriendsList = [[NSMutableArray alloc] init];
        for (int i=1; i<=4; i++) {
            FriendDetail *friendDetail = [[FriendDetail alloc] init];
            friendDetail.name = [NSString stringWithFormat:@"ScFriend%d", i];
            [schoolFriendsList addObject:friendDetail];
        }
    } else if ([prefix isEqualToString:@"Co"]) {
        collegeFriendList = [[NSMutableArray alloc] init];
        for (int i =1; i<=8; i ++) {
            FriendDetail *friendDetail = [[FriendDetail alloc] init];
            friendDetail.name = [NSString stringWithFormat:@"CoFriend%d", i];
            [collegeFriendList addObject:friendDetail];
        }
    }
}
@end
