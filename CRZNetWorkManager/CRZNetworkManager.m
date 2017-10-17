//
//  NetworkManager.m
//  NetworkManager
//
//  Created by wordoor－z on 16/4/14.
//  Copyright © 2016年 wzx. All rights reserved.
//

#import "CRZNetworkManager.h"
@interface CRZNetworkManager()
@property (nonatomic,copy)NSString * url;
@property (nonatomic,assign)RequestType wRequestType;
@property (nonatomic,assign)RequestSerializer requestSerialize;
@property (nonatomic,assign)ResponseSerializer responseSerialize;
@property (nonatomic,copy)id parameters;
@property (nonatomic,copy)NSDictionary * wHTTPHeader;
@property (nonatomic,assign)ApiVersion version;
@end
@implementation CRZNetworkManager

+ (CRZNetworkManager *)manager {
    static CRZNetworkManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CRZNetworkManager alloc]init];
        [manager replace];
    });
    return manager;
}

- (CRZNetworkManager *(^)(NSString *))setRequest {
    return ^CRZNetworkManager* (NSString * url) {
        self.url = url;
        return self;
    };
}

- (CRZNetworkManager *(^)(RequestType))RequestType {
    return ^CRZNetworkManager* (RequestType type) {
        self.wRequestType = type;
        return self;
    };
}

- (CRZNetworkManager* (^)(id parameters))Parameters {
    return ^CRZNetworkManager* (id parameters) {
        self.parameters = parameters;
        return self;
    };
}
- (CRZNetworkManager *(^)(NSDictionary *))HTTPHeader {
    return ^CRZNetworkManager* (NSDictionary * HTTPHeaderDic) {
        self.wHTTPHeader = HTTPHeaderDic;
        return self;
    };
}

- (CRZNetworkManager *(^)(RequestSerializer))RequestSerialize {
    return ^CRZNetworkManager* (RequestSerializer requestSerializer) {
        self.requestSerialize = requestSerializer;
        return self;
    };
}

- (CRZNetworkManager *(^)(ApiVersion))Version {
    return ^CRZNetworkManager * (ApiVersion version) {
        self.version = version;
        return self;
    };
}

- (CRZNetworkManager *(^)(ResponseSerializer))ResponseSerialize {
    return ^CRZNetworkManager* (ResponseSerializer responseSerializer) {
        self.responseSerialize = responseSerializer;
        return self;
    };
}

- (void)startRequestWithSuccess:(void (^)(id))success failure:(void (^)())failure {
    CRZNetworkManager * manager = [[self class]manager];
    //设置请求头
    [self setupRequestSerializerWithManager:manager];
    [self setupHTTPHeaderWithManager:manager];
    //设置返回头
    [self setupResponseSerializerWithManager:manager];
   
    NSString * url = [self setupUrl];
    
    switch (self.wRequestType) {
        case GET: {
        [manager GET:url parameters:self.parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            failure(error);
        }];
        }
            break;
            
        case POST: {
            [manager POST:url parameters:self.parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                failure(error);
            }];
        }
            break;
            
        case PUT: {
            [manager PUT:url parameters:self.parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                failure(error);
            }];
        }
            break;
            
        case PATCH: {
            [manager PATCH:url parameters:self.parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                failure(error);
            }];
        }
            break;
            
        case DELETE: {
            [manager DELETE:url parameters:self.parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                failure(error);
            }];
        }
            break;
            
        default:
            break;
    }
    [self replace];
}

- (CRZNetworkManager *)setupRequestSerializerWithManager:(CRZNetworkManager *)manager {
    
    switch (self.requestSerialize) {
        case RequestSerializerJSON: {
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
        }
            break;
        case RequestSerializerHTTP: {
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        }
            break;
        default:
            break;
    }
    return manager;
}

- (CRZNetworkManager *)setupResponseSerializerWithManager:(CRZNetworkManager *)manager {
    switch (self.responseSerialize) {
        case ResponseSerializerJSON: {
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
        }
            break;
        case ResponseSerializerHTTP: {
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        }
            break;
        default:
            break;
    }
    return manager;
}

- (CRZNetworkManager *)setupHTTPHeaderWithManager:(CRZNetworkManager *)manager {
    for (NSString * key in self.wHTTPHeader.allKeys) {
        [manager.requestSerializer setValue:self.wHTTPHeader[key] forHTTPHeaderField:key];
    }
    return manager;
}

- (NSString *)setupUrl {
    NSString * version = @"";
    switch (self.version) {
        case V1: {
            version = @"v1";
        }
            break;
        case V2: {
            version = @"v2";
        }
            break;
        case NONE: {
            return self.url;
        }
            break;
        default:
            break;
    }
    return [NSString stringWithFormat:@"%@,%@",self.url,version];
}

//重置
- (void)replace {
    self.url = nil;
    self.version = NONE;
    self.wRequestType = GET;
    self.parameters = nil;
    self.wHTTPHeader = nil;
    self.requestSerialize = RequestSerializerHTTP;
    self.responseSerialize = ResponseSerializerJSON;
}
@end
