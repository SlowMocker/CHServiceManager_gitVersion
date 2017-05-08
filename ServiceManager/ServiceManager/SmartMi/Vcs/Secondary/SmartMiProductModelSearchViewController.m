//
//  SmartMiProductModelSearchViewController.m
//  ServiceManager
//
//  Created by Wu on 17/4/13.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "SmartMiProductModelSearchViewController.h"

@interface SmartMiProductModelSearchViewController ()

@end

@implementation SmartMiProductModelSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) queryMachineModels:(NSString *)keyWords response:(RequestCallBackBlockV2)requestCallBackBlock {
    SmartMiRepairerQueryFuzzyAircraftInputParams *input = [SmartMiRepairerQueryFuzzyAircraftInputParams new];
    input.machineText = keyWords;
    input.machineBrand = self.brand;
    
    [self.httpClient smartMi_repairer_queryFuzzyAircraft:input response:^(NSError *error, HttpResponseData *responseData) {
        NSArray *modelArray;
        if(!error && kHttpReturnCodeSuccess == responseData.resultCode){
            modelArray = [MiscHelper parserObjectList:responseData.resultData objectClass:@"SmartMiProductModelDes"];
            modelArray = [self convertToProductModelDesArray:modelArray];
        }
        requestCallBackBlock(error, responseData, modelArray);
    }];
}

- (NSArray<ProductModelDes *> *) convertToProductModelDesArray:(NSArray<SmartMiProductModelDes *> *)smModelArray {
    NSMutableArray *modelArray = [[NSMutableArray alloc]init];
    for (SmartMiProductModelDes *smModel in smModelArray) {
        ProductModelDes *model = [[ProductModelDes alloc] initWithSmartMi:smModel];
        [modelArray addObject:model];
    }
    return modelArray;
}


@end
