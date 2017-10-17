//
//  NetworkManager.h
//  NetworkManager
//
//  Created by wordoor－z on 16/4/14.
//  Copyright © 2016年 wzx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
@interface CRZNetworkManager : AFHTTPSessionManager
typedef NS_ENUM(NSInteger,RequestType){
    GET,
    POST,
    PUT,
    DELETE,
    PATCH,
};

typedef NS_ENUM(NSInteger,RequestSerializer){
    RequestSerializerJSON,
    RequestSerializerHTTP
};

typedef NS_ENUM(NSInteger,ResponseSerializer){
    ResponseSerializerJSON,
    ResponseSerializerHTTP
};

typedef NS_ENUM(NSInteger,ApiVersion){
    NONE,
    V1,
    V2
};

+ (CRZNetworkManager *)manager;

/** 
 *  @method      填充网址
 */
- (CRZNetworkManager* (^)(NSString * url))setRequest;

/**
 *  @method      填充请求类型，默认为GET
 */
- (CRZNetworkManager* (^)(RequestType type))RequestType;

/**
 *  @method      填充参数
 */
- (CRZNetworkManager* (^)(id parameters))Parameters;

/**
 *  @method      填充请求头
 */
- (CRZNetworkManager* (^)(NSDictionary * HTTPHeaderDic))HTTPHeader;

/**
 *  @method      更改数据发送类型，默认HTTP
 */
- (CRZNetworkManager* (^)(RequestSerializer))RequestSerialize;

/**
 *  @method      更改数据接收类型，默认JSON
 */
- (CRZNetworkManager* (^)(ResponseSerializer))ResponseSerialize;
- (CRZNetworkManager* (^)(ApiVersion))Version;

/**
 *  @method      发送请求
 */
- (void)startRequestWithSuccess:(void (^)(id response))success failure:(void (^)())failure;
@end
