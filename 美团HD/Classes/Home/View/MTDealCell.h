//
//  MTDealCell.h
//  美团HD
//
//  Created by piglikeyoung on 15/11/9.
//  Copyright © 2015年 pikeYoung. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTDeal, MTDealCell;

@protocol MTDealCellDelegate <NSObject>

@optional
- (void)dealCellCheckingStateDidChange:(MTDealCell *)cell;

@end

@interface MTDealCell : UICollectionViewCell
@property (nonatomic, strong) MTDeal *deal;
@property (nonatomic, weak) id<MTDealCellDelegate> delegate;
@end
