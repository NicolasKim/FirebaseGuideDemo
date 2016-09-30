//
//  TopicModel.h
//  FirstFireBaseDemo
//
//  Created by 金秋成 on 16/9/27.
//  Copyright © 2016年 金秋成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicModel : NSObject
@property (nonatomic,strong)NSString * topicId;
@property (nonatomic,strong)NSString * topicDesc;
@property (nonatomic,strong)NSString * topicImageURL;
@property (nonatomic,strong)NSString * authName;
@property (nonatomic,strong)NSDate   * postDate;


-(instancetype)initWithDict:(NSDictionary *)dict;

@end
