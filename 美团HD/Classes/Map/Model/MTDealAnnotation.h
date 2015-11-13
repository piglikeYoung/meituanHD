//
//  MTDealAnnotation.h
//  美团HD
//
//  Created by piglikeyoung on 15/11/13.
//  Copyright © 2015年 pikeYoung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MTDealAnnotation : NSObject <MKAnnotation>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
/** 图片名 */
@property (nonatomic, copy) NSString *icon;
@end
