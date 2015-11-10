//
//  MTDealsViewController.h
//  美团HD
//
//  Created by piglikeyoung on 15/11/10.
//  Copyright © 2015年 pikeYoung. All rights reserved.
//  团购列表控制器(父类)

#import <UIKit/UIKit.h>

@interface MTDealsViewController : UICollectionViewController
/**
 *  设置请求参数:交给子类去实现
 */
- (void)setupParams:(NSMutableDictionary *)params;
@end
