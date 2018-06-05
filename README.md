# ZZExtension


## 功能介绍
在自定义的tabbarController中一句代码实现超出tabbar的按钮，类似简书的发表按钮。

···Objective-C
//核心代码:普通效果:传入的按钮就直接作为中间的按钮了,给了一个回调,可以获取按钮的点击事件,请注意block的循环引用!
[self.tabBar zz_setCenterButtonWithButton:self.centerButton selectIndexWhenThisButtonClick:1 callBack:nil];

/**核心代码:present效果:一样的参数,传入selectIndexWhenThisButtonClick<0的值,不会改变选中的item,但仍然会回调callBack!(点击查看)
__weak typeof (self)weakSelf = self;
[self.tabBar zz_setCenterButtonWithButton:button selectIndexWhenThisButtonClick:-1 callBack:^{
UIViewController *vc = [[UIViewController alloc] init];
vc.view.backgroundColor = [UIColor darkGrayColor];
[weakSelf presentViewController:vc animated:YES completion:nil];
}];
*/
···


cocoapods导入：
pod 'ZZExtension'

普通方式使用：
将工程目录学习的ZZExtension文件拖入到你的工程中
