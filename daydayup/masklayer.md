## layer.mask

最近有个动画的需求，UI说json的不能导出来流光效果，问能不能代码写，那必须没问题啊。

项目中原有的FBShimmering不支持倾斜的光束，所以还是自己来写了。

实现原理 ：使用图片做layer的mask 将光束放到maskview上 移动positionx

由于自己写图层最终也是生成一张图片，所以是让UI同学给切了一张光线的图片。
代码很简单 

```
		UIImageView * imageV = [[UIImageView alloc] initWithFrame:self.imageView.bounds];
		imageV.image = [UIImage imageNamed:@"iconVip72"];	
		UIView * maskView = [[UIView alloc] initWithFrame:imageV.frame];
		maskView.layer.mask = imageV.layer;
		maskView.layer.masksToBounds = YES;
		
		self.lightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Rectangle"]];
		self.lightImageView.backgroundColor = [UIColor clearColor];
		self.lightImageView.x = self.imageView.layer.position.x - self.lightImageView.width;
		[maskView addSubview:self.lightImageView];
		[self.imageView addSubview:maskView];
```
动画部分

```
CGFloat lightDuration = 1.0;
	
	CABasicAnimation *lightAniamtion = [CABasicAnimation animationWithKeyPath:@"position.x"];
    lightAniamtion.duration = lightDuration;
    lightAniamtion.fromValue = @(self.imageView.layer.position.x - self.lightImageView.width);
    lightAniamtion.toValue = @(self.imageView.layer.width);
    lightAniamtion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    lightAniamtion.repeatCount = 1;
    lightAniamtion.removedOnCompletion = NO;
    lightAniamtion.fillMode = kCAFillModeForwards;
    [self.lightImageView.layer addAnimation:lightAniamtion forKey:@"lightAnimation"];
```

需要注意的地方：
##### view.layer作为其他view的mask之后不再显示view本身了。

这里讲一下为什么会这样。

###mask的理解
mask本质还是一个CALayer。但是不是add到layer上的另一个layer，而是控制layer本身渲染的一个layer。


###masklayer的透明度会影响mask最终效果。

* CALayer里有两个主要的属性和透明度有关，就是contents属性和backgroundCorlor属性。我们用contents最多的就是给它赋值一个图片，而图片是有透明通道和无透明通道的，backgroundColor属性也是有透明度的（mask不关心是什么颜色，只关心颜色的透明度），而且clearColor的透明度是0。

* 另外，maskLayer可以不跟imageLayer大小一样，如果maskLayer比view自己的layer要小，那默认的maskLayer之外的地方都是透明的，都不会渲染。

效果是：

* 当mask图层完全透明时，即透明度为0，view就不会渲染，而是变透明，遮罩区域不显示，显示出view之后的内容。
* 当mask图层完全不透明时，即透明度为1，view就会正常渲染，则遮罩区域显示出view本来的内容 。
* 当mask图层的透明度值在0~1之间，则mask图层会和被遮罩层内容混合



> 看到这里已经了解了为什么 [view.layer作为其他view的mask之后不再显示本身了]。 作为mask的view.layer并没有被添加到targetView.layer上，只是作为一个mask来影响渲染结果，其本身是不会显示出来的。


