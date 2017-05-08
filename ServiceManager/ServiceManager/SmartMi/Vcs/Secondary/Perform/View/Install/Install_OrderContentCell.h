//
//  Install_OrderContentCellTableViewCell.h
//  ServiceManager
//
//  Created by Wu on 17/3/29.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

// 可复用 UploadPictureCell

#import <UIKit/UIKit.h>

@interface Install_OrderContentCell : UITableViewCell

@property (nonatomic , assign) BOOL hasUpload;/**< 图片是否已经上传 */
@property (strong, nonatomic) IBOutlet UILabel *titlelabel;/**< title */

@property (nonatomic , assign) BOOL needHandleUploadImg;/**< 是否需要处理上传图片事件，这个 cell 有两种类型: 可以显示图片的 不可以的 */

@property (strong, nonatomic) IBOutlet UILabel *label;

@end
