//
//  ViewController.m
//  4-UITableView
//
//  Created by lgh on 15/12/24.
//  Copyright (c) 2015年 lgh. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"tableView的编辑";
    
    // 设置左右barButton:
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(clickEdit:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"插入" style:UIBarButtonItemStylePlain target:self action:@selector(clickInsert:)];
    
    /*
     UITableViewStylePlain 常规样式，sectionView会停留， UITableViewStyleGrouped 偏好样式
     if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
     }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
     }
     设置：
     if (self.edgesForExtendedLayout = UIRectEdgeNone) {
         CGRectMake(0, 0, w, h-64);
     } else {
         滑动时，tableView会隐藏在navigationBar的下面：
         CGRectMake(0, 0, w, h);
         滑动时，tableView不会隐藏在navigationBar的下面：
         CGRectMake(0, 64, w, h-64);
     }
     */
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //分割线样式
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //头尾视图 self.tableView.tableHeaderView ---  tableFooterView
    //自定义sectionHeaderView，sectionFooterView
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    
    /*
     刷新的时候，界面卡顿：
     可能是self.tableView.estimatedRowHeight = 0;
     需要把它设置为一个合理的估算值。
     */
}

#pragma mark - 自定义sectionFooterView:
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIButton *btnL = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    btnL.backgroundColor = [UIColor redColor];
    [btnL addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return btnL;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30;
}

#pragma mark - 左右按钮的回调方法:
// 右边编辑按钮的回调方法:
- (void)clickEdit:(UIBarButtonItem *)button
{
    // 进入编译状态;
    _tableView.editing = !_tableView.editing; // 不带动画;
   // [_tableView setEditing:!_tableView.editing animated:YES]; // 带动画
    if ([button.title isEqualToString:@"编辑"]) {
        button.title = @"取消";
    }else{
        button.title = @"编辑";
    }
}

// 左边插入按钮的回调方法:
- (void)clickInsert:(UIBarButtonItem *)button
{
    // 先改变数据源， 再刷新界面:
    //step1.改变数据:
    [self.dataSource insertObject:@"韶关" atIndex:0];
    //step2.刷新界面:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ]=
//    [_tableView reloadData]; //!< 重新全部加载数据，刷新数据, 重新跑加载数据的代理方法;
    // 插入某些行数据:
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    // 参数一: 刷新某一行数据； NSIndexPath对象放到数组里面;
    [_tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationRight];
}

#pragma mark - tableView的代理方法:

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    // 返回row: 第几行;
    cell.textLabel.text = self.dataSource[indexPath.row];
    
    // 设置cell的辅助按钮:
//    UITableViewCellAccessoryNone,                     无
//    UITableViewCellAccessoryDisclosureIndicator,      >
//    UITableViewCellAccessoryDetailDisclosureButton,   !>
//    UITableViewCellAccessoryCheckmark,                √
//    UITableViewCellAccessoryDetailButton              ！
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    //无选择样式
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
// 返回每行的高度，默认cell的高度是: 44.0
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

//9.是否允许进入编辑模式，返回YES是允许，返回NO不允许，如果不实现，默认返回YES;
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0) {  // 第0行不允许进入编辑模式:
//        return NO;
//    }
    return YES;
}
//10. 进入哪一种编辑模式: (两种模式: 删除和插入)， 默认进入删除编辑模式:
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCellEditingStyleDelete,
//    UITableViewCellEditingStyleInsert
    if (tableView.editing) {
        
        
        if(indexPath.row%2==0){
            return UITableViewCellEditingStyleDelete;
        }else{
            return UITableViewCellEditingStyleInsert;
        }
    }
    return UITableViewCellEditingStyleDelete;
}
//11.处理删除和插入的代理方法: (只要实现这个方法，选择cell往左边拖动，会出现delete按钮)
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除：
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //step1. 先把数据源对应数据删除：
        [self.dataSource removeObjectAtIndex:indexPath.row];
        //step2. 刷新界面:
        // 参数一: NSIndexPath放到数组里面:
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
    
    }else if (editingStyle == UITableViewCellEditingStyleInsert){// 插入:
        
        // step1. 数据源增加数据;
        [self.dataSource insertObject:@"长沙" atIndex:indexPath.row + 1];
        // step2.刷新界面;
        // 注意: 刷新界面的位置要和数据源插入数据的位置一致:
        NSIndexPath *index = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
        
        [tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationRight];
    }
}
//12.设置delete按钮文字:
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"哈哈哈";
}
//13.点击某一行cell调用:
//didDeselectRowAtIndexPath (备注:注意区别这个方法，不要写错, 不选择某一行时调用)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 让选择某一行有个选择的效果:
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"选择:%ld段%ld行", indexPath.section, indexPath.row);
    
    // push新界面:
    SecondViewController *svc = [[SecondViewController alloc] init];
    // 把数据源里面的第row行数据正向传值给第二个界面:
    svc.cityName = self.dataSource[indexPath.row];
    
    // push到第二个界面:
    [self.navigationController pushViewController:svc animated:YES];
    
    // tableView滚动:
    //参数一: indexPath;
    //参数二: 滚动位置;
    //参数三: 是否动画:
//    UITableViewScrollPositionTop,       顶
//    UITableViewScrollPositionMiddle,    中间
//    UITableViewScrollPositionBottom     底部
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
//14.点击辅助按钮是调用:
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
//    UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"%ld段%ld行 敬请期待", indexPath.section, indexPath.row] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [a show];
//    UIActionSheet
    
//    ios8.0 UIAlertController
    // 参数一: title:
    // 参数二: message；
    // 参数三: UIAlertControllerStyleActionSheet  ----> UIActionSheet
//              UIAlertControllerStyleAlert    ---> UIAlertView
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"新控件来袭" preferredStyle:UIAlertControllerStyleAlert];
    
    // 创建按钮action对象:
//    参数一: title;
//    参数二: 类型
//    UIAlertActionStyleDefault      默认
//    UIAlertActionStyleCancel,      取消
//    UIAlertActionStyleDestructive  具有提醒
//    参数三: block回调 (当按钮被点击后会调用改block);
    UIAlertAction *a = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"确定");
    }];
    // ac控件添加a:
    [ac addAction:a];
    
//#warning 如果类型是: UIAlertControllerStyleActionSheet,不能添加textFiled:
    // 添加textFiled:
    [ac addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        // block里面设置textFiled的属性;
        textField.placeholder = @"请输入银行卡密码";
        textField.textColor = [UIColor redColor];
        textField.delegate = self; // 把self设置成textFiled的代理;
    }];
    
    UIAlertAction *a2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"点击取消");
    }];
    
    UIAlertAction *a3 = [UIAlertAction actionWithTitle:@"提醒" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"点击提醒");
    }];
    
    [ac addAction:a2];
    [ac addAction:a3];
    
    // 弹出提示框：
    [self presentViewController:ac animated:YES completion:nil];
}

#pragma mark - textFiled的代理方法:
// 当textFiled结束编辑时会调用该方法:
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"%@", textField.text);
}




#pragma mark - getter
// dataSource的懒加载:
- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] initWithArray:@[@"广州", @"深圳", @"珠海", @"中山", @"东莞", @"佛山", @"惠州", @"汕头", @"汕尾", @"湛江", @"梅州", @"清远", @"茂名", @"阳江"]];
    }
    return _dataSource;
}
@end


















