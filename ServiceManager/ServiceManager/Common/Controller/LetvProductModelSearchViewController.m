//
//  LetvProductModelSearchViewController.m
//  ServiceManager
//
//  Created by will.wang on 16/5/20.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "LetvProductModelSearchViewController.h"

@interface LetvProductModelSearchViewController ()

@end

@implementation LetvProductModelSearchViewController

- (void)queryMachineModels:(NSString*)keyWords response:(RequestCallBackBlockV2)requestCallBackBlock
{
    LetvFindMachineModelInputParams *input = [LetvFindMachineModelInputParams new];
    input.machineText = keyWords;
    input.machineBrand = self.productBrand;
    
    [self.httpClient letv_findMachineModel:input response:^(NSError *error, HttpResponseData *responseData) {
        NSArray *modelArray;
        if(!error && kHttpReturnCodeSuccess == responseData.resultCode){
            modelArray = [MiscHelper parserObjectList:responseData.resultData objectClass:@"LetvProductModelDes"];
            modelArray = [self convertToProductModelDesArray:modelArray];
        }
        requestCallBackBlock(error, responseData, modelArray);
    }];
}

- (NSArray*)convertToProductModelDesArray:(NSArray*)letvModelArray
{
    NSMutableArray *modelArray = [[NSMutableArray alloc]init];
    for (LetvProductModelDes *letvModel in letvModelArray) {
        ProductModelDes *model = [[ProductModelDes alloc]initWithLetv:letvModel];
        [modelArray addObject:model];
    }
    return modelArray;
}

@end
