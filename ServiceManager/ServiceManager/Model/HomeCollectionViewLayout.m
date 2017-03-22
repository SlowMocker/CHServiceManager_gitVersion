//
//  HomeCollectionViewLayout.m
//  ServiceManager
//
//  Created by will.wang on 2016/12/21.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "HomeCollectionViewLayout.h"
#import "HomeCollectionViewCell.h"
#import "HomeCollectionSectionHeaderView.h"

@interface HomeCollectionViewLayout()<UICollectionViewDelegateFlowLayout>
@end

@implementation HomeCollectionViewLayout

- (void)prepareLayout
{
    [super prepareLayout];

    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.itemSize = CGSizeMake(ScreenWidth/4, [HomeCollectionViewCell cellHeight]);
    self.headerReferenceSize = CGSizeMake(ScreenWidth, [HomeCollectionSectionHeaderView viewTotalHeight]);
    self.minimumInteritemSpacing = 0;
    self.minimumLineSpacing = 0;
    self.sectionInset = UIEdgeInsetsMake(6, 0, 6, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(ScreenWidth, kTableViewSectionHeaderHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(ScreenWidth, 0);
}

@end
