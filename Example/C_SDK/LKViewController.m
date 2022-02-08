//
//  LKViewController.m
//  C_SDK
//
//  Created by likai89 on 02/08/2022.
//  Copyright (c) 2022 likai89. All rights reserved.
//

#import "LKViewController.h"
#import "AAA.h"
#import "AFNetworking.h"
@interface LKViewController ()

@end

@implementation LKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    AAA * test_a = [[AAA alloc]init];
    [test_a testP];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
