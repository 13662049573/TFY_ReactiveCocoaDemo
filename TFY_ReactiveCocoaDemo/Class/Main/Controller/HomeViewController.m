//
//  HomeViewController.m
//  ReactiveCocoaDemo
//
//  Created by 叶炯 on 2017/3/13.
//  Copyright © 2017年 叶炯. All rights reserved.
//

#import "HomeViewController.h"
#import "RACSignalController.h"
#import "RACSubscriberController.h"
#import "RACSetViewController.h"
#import "RACMulticastConnectionController.h"
#import "RACCommandController.h"
#import "RACMethodUseViewController.h"
#import "RACOperationMethodController.h"
#import "RACOperationMethodFilteringVC.h"
#import "RACOperationOrderController.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSArray *classArr;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"RAC学习";
    
    self.dataArr = @[@"RACSignal",@"RACSubscriber",@"RAC集合",@"RACMulticastConnection",@"RACCommand",@"RAC常用方法",@"RAC操作方法一",@"RAC操作方法二",@"RAC操作方法三"];
    
    self.classArr = @[@"RACSignalController",@"RACSubscriberController",@"RACSetViewController",@"RACMulticastConnectionController",@"RACCommandController",@"RACMethodUseViewController",@"RACOperationMethodController",@"RACOperationMethodFilteringVC",@"RACOperationOrderController"];
    
    [self.view addSubview:self.tableView];
    [self.tableView tfy_AutoSize:0 top:0 right:0 bottom:0];
    
    
    NSOperationQueue * queueeTest = [[NSOperationQueue alloc]init];
        
        queueeTest.maxConcurrentOperationCount = 1;
        
        NSBlockOperation * optionA = [NSBlockOperation blockOperationWithBlock:^{
            
            for (int i = 0; i<10; i++)
            {
                NSLog(@"A------i的值是:%d",i);
            }
        }];
        NSBlockOperation * optionB = [NSBlockOperation blockOperationWithBlock:^{
            
            for (int j = 0; j<20; j++)
            {
                NSLog(@"B--------j的值是:%d",j);
            }
        }];
        
        //B依赖于A
        [optionB  addDependency:optionA];
        
        [queueeTest addOperation:optionA];
        
        [queueeTest addOperation:optionB];
    
    
    
    // 创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        // 创建全局并行
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_async(group, queue, ^{

            // 请求一
//            [loginCode getUserInfoWithNick:nil andUserId:kUserId onSuc:^(id data) {
//                NSLog(@"yue");
//                dispatch_semaphore_signal(semaphore);
//
//            } andFail:^(NSError *error) {
//            }];

        });
        dispatch_group_async(group, queue, ^{

            // 请求二
//            [CommodityViewModel getPriceTransformForIntegral:nil onSuccess:^(id data) {
//
//                NSLog(@"duihuan11");
//                dispatch_semaphore_signal(semaphore);
//
//            } onFailure:^(NSError *error) {
//            }];
        });
        dispatch_group_async(group, queue, ^{

            // 请求三
//            [CommodityViewModel getPriceTransformForIntegral:nil onSuccess:^(id data) {
//                NSLog(@"duihuan22");
//                dispatch_semaphore_signal(semaphore);
//
//            } onFailure:^(NSError *error) {
//            }];
        });

        dispatch_group_notify(group, queue, ^{

            // 三个请求对应三次信号等待
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

            //在这里 进行请求后的方法，回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{

                //更新UI操作

            });


        });
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.makeChain
        .adJustedContentIOS11()
        .showsVerticalScrollIndicator(NO)
        .showsHorizontalScrollIndicator(NO)
        .delegate(self).dataSource(self)
        .backgroundColor(UIColor.whiteColor)
        .clipsToBounds(YES).rowHeight(80);
        if (@available(iOS 13.0, *)) {
            _tableView.makeChain.automaticallyAdjustsScrollIndicatorInsets(NO);
        }
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    UITableViewCell *cell = [UITableViewCell tfy_cellFromCodeWithTableView:tableView];
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    Class classes = NSClassFromString(self.classArr[indexPath.row]);
    
    [self.navigationController pushViewController:[classes new] animated:YES];
    
}


@end
