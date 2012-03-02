//
//  Created by zen on 3/1/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DXDALConfigurableRequest.h"
#import "DXDALRequest.h"
#import "DXDALDataProvider.h"

@interface DXDALRequest () <DXDALConfigurableRequest>

@end

@implementation DXDALRequest {
    NSMutableArray *_successHandlers;
    NSMutableArray *_errorHandlers;
    __unsafe_unretained id<DXDALDataProvider> _dataProvider;

    NSMutableDictionary *_params;
}

- (id)initWithDataProvider:(id<DXDALDataProvider>)dataProvider {
    assert(dataProvider != nil);
    
    self = [super init];
    if (self) {
        _dataProvider = dataProvider;
        _successHandlers = [NSMutableArray new];
        _errorHandlers = [NSMutableArray new];
        _params = [NSMutableDictionary new];
    }
    return self;
}

- (void)addParam:(NSString *)param withName:(NSString *)key {
    [_params setObject:param forKey:key];
}

- (void)addSuccessHandler:(DXDALRequestSuccesHandler)handler {
    assert(handler != nil);
    [_successHandlers addObject:handler];
}

- (void)addErrorHandler:(DXDALRequestErrorHandler)handler {
    assert(handler != nil);
    [_errorHandlers addObject:handler];
}

- (void)start {
    [_dataProvider enqueueRequest:self];
}

- (void)stop {

}

- (void)pause {

}

- (void)resume {

}

- (void)didFinishWithResponse:(id)response {
    for (id block in _successHandlers) {
        DXDALRequestErrorHandler handler = block;
        handler(response);
    }
}

- (void)didFailWithResponse:(id)response {
    for (id block in _errorHandlers) {
        DXDALRequestErrorHandler handler = block;
        handler(response);
    }
}


@end