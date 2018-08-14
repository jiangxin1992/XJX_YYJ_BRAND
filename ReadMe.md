# iOS开发规范
### 请认真阅读
##### 注：本文档适用于所有使用Objective-C语言开发的项目

#### 一 通用说明
1. 代码中若用到 “iOS” 字样，应该写成 “iOS”，而不是ios或者其他任何写法
2. 代码缩进以4个空格为准，在xcode设置中可修改
3. 代码文件必须以YY开头(第三方除外)

```
 header.h
 UIKIT_EXTERN NSString * const JRIp;
```
```
 header.m
 static NSString * const JRIp = @"192.168.188.100";
```

#### 二 空格的使用
1. 方法大括号和其它大括号（比如if/else/switch/while等等）应在语句的同一行开始，
例如：

```
 if (user.isHappy) {
     //Do something
 }else {
     //Do something else
 }
```

2. 在每个方法之间应"提供且仅提供"```空一行```。方法内部不同罗技块之间"提供且仅提供"```空一行```。例如：

```
 -(void)A{
     //Do something

     //Do other something
 }
            
 -(void)B{
     //Do something
 }
```

3. .h文件中若引用@class，则@class与@interface之间空1行
4. 即使条件语句只有一行，也必须用大括号包起来。该条适用于所有条件语句

#### 三 三目运算符
1. 仅当使用该运算子可以让代码显得更清晰易懂时方可使用三元运算子。更多情况下应使用条件语句，
或使用实例变量。
恰当用法：

```
result = a > b ? x : y;
```
不当用法：

```
result = a > b ? x = c > d ? c : d : y;
```

#### 四 声明
1. 采用驼峰式命名,属性名称第一个字母小写，方法声明中 - / + 之后要添加一个空格
2. 除for()循环外，所有命名都尽可能具有自解释性，也应该添加注释说明，应避免使用单字符变量命名
3. 除非是常量，星号应紧贴变量名称表示指向变量的指针，比如：
```
NSString *text;
```
不恰当用法

```
NSString* text;
NSString * text;
```
4. 应尽可能使用属性定义替代单一的实例变量。避免在初始化方法,
dealloc方法和自定义的setter和getter方法中直接读取实例变量参数（init,initWithCoder:，等等）。
属性声明尽量手动指定锁类型```nonatomic, atomic```,和指针类型```strong, weak, retain, assign, copy```
例如：恰当用法

```
 @interface NYTSection: NSObject

 @property (nonatomic, copy) NSString *headline;

 @end
```
不恰当用法

```
 @interface NYTSection : NSObject {
 NSString *headline;
 }
```

5. 鼓励使用长的描述性的方法和变量名称
恰当用法

```
UIButton *settingsButton;
```
不恰当用法

```
UIButton *setBtn;
```

6. 当使用属性变量时，应通过self.来获取和更改实例变量。这就意味着所有的属性将是独特的，
因为它们的名称前会加上self.。本地变量名称中不应包含下划线

7. 如果是区分yco／buyer／brand 请在命名后面加上"下划线+识别名" 例如：kSeriesList_brand

#### 五 注释
1. 代码块使用行注释，声明属性时应该使用块注释
2. 对于修改属性的地方，用行注释标注作用

#### 六 常量
2. 能用常量定义的地方避免使用宏定义。使用static方式定义常量。const应该写在＊之后。例如

```
static NSString * const text;
```

#### 七 枚举
1. 非特殊情况下，不允许出现神秘数字 0, 1, 2 等等，请用枚举代替
2. 在使用enum的时候，推荐适用最新的fixed underlying type(WWDC 2012 session 405- Modern Objective-C)规范，因为它具备更强的类型检查和代码完成功能。 例如

```
 typedef NS_ENUM(NSInteger, JRAdRequestState){
     mYYAdRequestStateInactive,
     mYYRAdRequestStateLoading
 };
```

3.枚举命名：

```
1.系统相关枚举：  以E开头; 
2.非系统相关枚举：以YY开头
```

#### 八 容器
1. 在创建NSString,NSDictionary,NSArray和NSNumber等对象的immutable实例，时，应使用字面量。
需要注意的是，不应将nil传递给NSArray和NSDictionary字面量，否则会引起程序崩溃。

#### 九 私有属性
1. 私有属性应该在类扩展中声明，可以私有的变量不应该在.h中声明。
2. 控件为私有属性，需要在外部控制内容的控件也必须为声明在.m中的私有属性。
可以使用字符串或着其他数据类型传递值

#### 十 BOOL
1. 命名时需要以is开头。如果一个BOOL属性使用形容词来表达，属性将忽略’is’前缀，
但会强调惯用名称。例如：

```
 @property (assign, getter=isEditable) BOOL editable;
```

2. 因为nil将被解析为NO，因此没有必要在条件语句中进行比较。永远不要将任何东西和YES进行直接比较，
因为YES被定义为1，而一个BOOL变量可以有8个字节。例如：
恰当用法

```
 if(!isSelectType){
 // do something
 }
```
不恰当用法
```
 if(isSelectType == nil){
 // do something
 }
```

#### 十一 单例模式
1. 在创建单例对象的共享实例时，应使用线程安全模式。例如：

```
 -(instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        });

    return sharedInstance;
 }
```

#### 十二 代码结构
1. 不建议使用自定义的控制器做父类，避免过度耦合。
2. 模块化代码结构，即使是一个很小的功能，若不属于其他模块，也要单独开辟一个模块解耦合。
3. 分文件夹管理代码

#### 十三 符号
1. 各种运算符号前后需要一个空格。多个运算符号一起使用，按照运算顺序添加空格。
若运算之后的结果需要再次运算，则本次运算不加空格，再次运算的符号加空格。例如：

```
 a + b;
 a + b - c;
 a*b + c;
 a + b*c;
 a*b + c*d;
 a*b - c/d;
 (a + b) * c;
 (a + b)*c + d;
```

#### 十四 图片
1. 图片都放在Images.xcassets里面。
	1.1 图片按文件夹区分，文件夹以功能区分，命名为 name(名称)
	1.2 图片按照功能分文件夹，每个图片名称见名知意，以文件夹名称开头，下划线分割，全小写

#### 十五 controller 结构

```
@property(nonatomic, strong) UIButton *confirmButtom
...

#pragma mark - --------------生命周期--------------
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self SomePrepare];
//}
//
#pragma mark - --------------SomePrepare--------------
//
//#pragma mark - SomePrepare
//-(void)SomePrepare
//{
//    [self PrepareData];
//    [self PrepareUI];
//}
//-(void)PrepareData{}
//-(void)PrepareUI{}
//
#pragma mark - --------------UI----------------------

// 创建子控件

#pragma mark - --------------系统代理----------------------


#pragma mark - --------------自定义代理/block----------------------


#pragma mark - --------------自定义响应----------------------


#pragma mark - --------------自定义方法----------------------


#pragma mark - --------------other----------------------
...

```
#### 十六 头文件引入规范
####cocoapods引入用< > 例如：
```
#import <Masonry.h>

```
1. .h（声明文件）中
	1.1 如果可能，尽量用class，在实现文件import。
2. .m（实现文件）中
	2.1 导入文件按照以下顺序分类
	1. 当前类
	2. c文件 —> 系统文件（c文件在前）
	3. 控制器
	4. 自定义视图
	5. 分类
	6. 自定义类和三方类（cocoapods类、model、工具类等） cocoapods类 —> model —> 其他

```
#import "YYBrandHomePageViewController.h"

#include <sys/xattr.h>
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>

#import "YYNavigationBarViewController.h"
#import "YYBrandModifyInfoViewController.h"

#import "YYBrandInfoSeriesCell.h"
#import "YYBrandInfoAboutContactCell.h"
#import "YYTypeButton.h"
#import "CMAlertView.h"

#import "UIImage+YYImage.h"
#import "UIColor+KTUtilities.h"

#import <Masonry.h>
#import <MJExtension.h>
#import "YYOrderInfoModel.h"
#import "YYOrderStyleModel.h"
#import "StyleDateRange.h"
#import "YYBuyerInfoTool.h"

```
#### 十七 cocoapods规范
1. Podfile中，每个pod需要写明对应的版本号，方便以后升级管理。

## last git
1. 每完成一段，提交一次。例如完成一个功能的界面、完成一个功能前后端对接等等
2. master做上线备份使用，开发时在work分支。上线前合并到master，然后打包上线，每一次合并后的节点，就是一个版本


