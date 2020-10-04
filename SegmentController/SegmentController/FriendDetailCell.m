//
//  FriendDetailCell.m
//  SegmentController
//
//  Created by ketan khare on 19/09/20.
//  Copyright © 2020. All rights reserved.
//

#import "FriendDetailCell.h"

@implementation FriendDetailCell
@synthesize lableOfCell, isFavCheckBox, selectCheckBox;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
