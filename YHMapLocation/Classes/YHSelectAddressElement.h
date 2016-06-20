//
//  YHSelectAddressElement.h
//  YaoHe
//
//  Created by stonedong on 16/5/1.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <ElementKit/ElementKit.h>


@class YHSelectAddressElement;
@class YHLocation;
@protocol YHSelectAddressDelegate <NSObject>

- (void) selectAddressElement:(YHSelectAddressElement*)ele didSelected:(YHLocation*)location;

@end

@interface YHSelectAddressElement : EKAdjustTableElement
@property (nonatomic, weak) NSObject<YHSelectAddressDelegate>* delegate;
@end
