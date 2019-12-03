//
//  HWUnderLineLabel.h
//  HOLLA
//
//  Created by 陈方方 on 2019/11/28.
//  Copyright © 2019 HOLLA. All rights reserved.
// 支持多行自定义下划线颜色和高度的label

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HWUnderLineLabel : UILabel

/// 行间距
@property (nonatomic, assign) float lineSpace;

/// 下划线高度
@property (nonatomic, assign) float underLineHeight;

/// 下划线颜色
@property (nonatomic, strong) UIColor *underLineColor;

///快速创建；
/// @param frame frame
/// @param text text
/// @param alignment alignment
/// @param font font
/// @param textColor textColor
/// @param underLineHeight 下划线高度
/// @param underLineColor 下划线颜色
/// @param lineSpace 行间距
+ (HWUnderLineLabel *)createLabelWithFrame:(CGRect)frame contentText:(NSString *)text textAligment:(NSTextAlignment )alignment font:(UIFont *)font textColor:(UIColor *)textColor underLineHeight:(float)underLineHeight underLineColor:(UIColor *)underLineColor lineSpace:(float)lineSpace;

@end

NS_ASSUME_NONNULL_END
