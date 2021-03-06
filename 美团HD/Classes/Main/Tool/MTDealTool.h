//
//  MTDealTool.h
//  美团HD
//
//  Created by piglikeyoung on 15/11/12.
//  Copyright © 2015年 pikeYoung. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MTDeal;

@interface MTDealTool : NSObject
/**
 *  返回第page页的收藏团购数据:page从1开始
 */
+ (NSArray *)collectDeals:(NSInteger)page;
+ (NSInteger)collectDealsCount;
/**
 *  收藏一个团购
 */
+ (void)addCollectDeal:(MTDeal *)deal;
/**
 *  取消收藏一个团购
 */
+ (void)removeCollectDeal:(MTDeal *)deal;
/**
 *  团购是否收藏
 */
+ (BOOL)isCollected:(MTDeal *)deal;
@end
