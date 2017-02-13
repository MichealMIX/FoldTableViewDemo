//
//  ViewController.m
//  TestTableView
//
//  Created by zhengrui on 17/1/5.
//  Copyright © 2017年 zhengrui. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL isOpen;
}
@property (nonatomic,strong)UITableView *selectTable;
@property (nonatomic,strong)NSArray *countArray;
@property (nonatomic,strong)NSMutableArray *selectArray;
@end

@implementation ViewController

- (NSMutableArray *)selectArray{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.countArray = @[
                        @[@"1-1",@"1-2",@"1-3"],
                        @[@"2-1",@"2-2"],
                        @[@"3-1",@"3-2",@"3-3",@"3-4"],
                        ];
    
    self.title = @"折叠列表";
    self.selectTable.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    self.selectTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.selectTable.delegate = self;
    self.selectTable.dataSource = self;
    [self.view addSubview:self.selectTable];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//分组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.countArray.count;
}
//每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.selectArray containsObject:[NSString stringWithFormat:@"%ld",section]]) {
        return 0;
    }else{
        NSArray *rowArray;
        for (int i = 0 ; i < self.countArray.count; i++) {
            if (section == i) {
                rowArray = self.countArray[i];
            }
        }
        return rowArray.count;
    }
}
//cell内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor redColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    for (int i = 0; i < self.countArray.count; i++) {
        NSArray *titleArr = self.countArray[i];
        for (int j = 0; j < titleArr.count; j++) {
            if (indexPath.section == i) {
                if (indexPath.row == j) {
                    cell.textLabel.text = [NSString stringWithFormat:@"%@",titleArr[j]];
                    cell.textLabel.textColor = [UIColor blueColor];
                }
            }
        }
    }
    
    return cell;
}
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshSection:)];
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    view.userInteractionEnabled = YES;
    view.tag = 5000+section;
    view.backgroundColor = [UIColor greenColor];
    [view addGestureRecognizer:headerTap];
    return view ;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    view.backgroundColor = [UIColor grayColor];
    return view;
}
//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)refreshSection:(id)tap{

    
    UITapGestureRecognizer *selectTap = (UITapGestureRecognizer *)tap;
    NSString *section = [NSString stringWithFormat:@"%ld",selectTap.view.tag-5000];
    
    if ([self.selectArray containsObject:section]) {
        [self.selectArray removeObject:section];
    }else{
        [self.selectArray addObject:section];
    }
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:selectTap.view.tag-5000];
    [self.selectTable reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}


@end
