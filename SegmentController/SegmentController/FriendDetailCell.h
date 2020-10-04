//
//  FriendDetailCell.h
//  SegmentController
//
//  Created by ketan khare on 19/09/20.
//  Copyright © 2020. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FriendDetailCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lableOfCell;
@property (strong, nonatomic) IBOutlet UIButton *isFavCheckBox;
@property (strong, nonatomic) IBOutlet UIImageView *selectCheckBox;

@end

NS_ASSUME_NONNULL_END
