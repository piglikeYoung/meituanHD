//
//  MTBusiness.h
//  美团HD
//
//  Created by piglikeyoung on 15/11/13.
//  Copyright © 2015年 pikeYoung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTBusiness : NSObject
/** 店名 */
@property (nonatomic, copy) NSString *name;
/** 纬度 */
@property (nonatomic, assign) float latitude;
/** 经度 */
@property (nonatomic, assign) float longitude;
@end
