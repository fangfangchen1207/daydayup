//
//  HWUnderLineLabel.m
//  HOLLA
//
//  Created by 陈方方 on 2019/11/28.
//  Copyright © 2019 HOLLA. All rights reserved.
//

#import "HWUnderLineLabel.h"
#import <CoreText/CoreText.h>

@implementation HWUnderLineLabel


+(HWUnderLineLabel *)createLabelWithFrame:(CGRect)frame
							  contentText:(nonnull NSString *)text
							 textAligment:( NSTextAlignment )alignment
									 font:(nonnull UIFont *)font
								textColor:(nonnull UIColor *)textColor
						  underLineHeight:(float)underLineHeight
						   underLineColor:(nonnull UIColor *)underLineColor
								lineSpace:(float)lineSpace
{
	
	HWUnderLineLabel *desLabel = [[HWUnderLineLabel alloc] initWithFrame:frame];
	desLabel.textColor = textColor;
	desLabel.numberOfLines = 0;
	desLabel.textAlignment = alignment;
	desLabel.lineBreakMode = NSLineBreakByWordWrapping;
	
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	paragraphStyle.lineSpacing = lineSpace;  //设置行间距
	paragraphStyle.lineBreakMode = desLabel.lineBreakMode;
	//阿拉伯语需要强制反向
	paragraphStyle.alignment = desLabel.textAlignment;

	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
	[attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
	[attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [text length])];

	desLabel.attributedText = attributedString;
	desLabel.lineSpace =lineSpace;
	desLabel.underLineHeight = underLineHeight;
	desLabel.underLineColor = underLineColor;

	//计算属性文本高度
	CGRect paragraphRect = [attributedString boundingRectWithSize:CGSizeMake(CGRectGetWidth(desLabel.frame), MAXFLOAT)  options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
	paragraphRect.origin = frame.origin;
	desLabel.frame = paragraphRect;
	
	return desLabel;
}

- (instancetype)initWithFrame:(CGRect)frame{
	if (self = [super initWithFrame:frame]) {
		self.font = [UIFont systemFontOfSize:20];
		self.underLineHeight = 1;
		self.underLineColor = [UIColor blackColor];

	}
	return self;
}

- (void)drawRect:(CGRect)rect{
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSetTextMatrix(ctx , CGAffineTransformIdentity);
	//x，y轴方向移动
	CGContextTranslateCTM(ctx , 0 ,self.bounds.size.height);
	//缩放x，y轴方向缩放，－1.0为反向1.0倍,坐标系转换,沿x轴翻转180度
	CGContextScaleCTM(ctx, 1.0 ,-1.0);

	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedText);
	CGMutablePathRef Path = CGPathCreateMutable();
	//坐标点在左下角
	CGPathAddRect(Path, NULL ,CGRectMake(0 ,0 ,self.bounds.size.width, self.bounds.size.height));
	CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
	CFArrayRef Lines = CTFrameGetLines(frame);
	CFIndex linecount = CFArrayGetCount(Lines);
	CGPoint origins[linecount];
	CTFrameGetLineOrigins(frame,CFRangeMake(0, 0), origins);
	NSInteger lineIndex = 0;
	NSArray *linesArray = (__bridge NSArray *)Lines;
	
	//设置颜色
	CGContextSetStrokeColorWithColor(ctx, self.underLineColor.CGColor);
	for (id oneLine in linesArray)
	{
		CGRect lineBounds = CTLineGetImageBounds((CTLineRef)oneLine, ctx);
		lineBounds.origin.x += origins[lineIndex].x;
		lineBounds.origin.y += origins[lineIndex].y;
		lineIndex++;
		//设置线宽
		CGContextSetLineWidth(ctx, self.underLineHeight);
		CGContextMoveToPoint(ctx, lineBounds.origin.x, lineBounds.origin.y);
		CGContextAddLineToPoint(ctx, lineBounds.origin.x+lineBounds.size.width, lineBounds.origin.y);
		CGContextStrokePath(ctx);
	}

	CTFrameDraw(frame,ctx);
	CGPathRelease(Path);
	CFRelease(framesetter);
}
@end
