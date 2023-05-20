#import "APPAPIClient.h"

@implementation APPAPIClient

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [APPAPIClient new];
    });
    return _shared;
}

// Fetches a ConnectionToken from your backend
- (void)fetchConnectionToken:(SCPConnectionTokenCompletionBlock)completion {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURL *url = [NSURL URLWithString:@"https://{{YOUR_BACKEND_URL}}/connection_token"];
    if (!url) {
        NSAssert(NO, @"Invalid backend URL");
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        id jsonObject = nil;
        NSError *jsonSerializationError;
        if (data) {
            jsonObject = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)kNilOptions error:&jsonSerializationError];
        }
        else {
            NSError *error = [NSError errorWithDomain:@"com.stripe-terminal-ios.example"
                                                 code:1000
                                             userInfo:@{NSLocalizedDescriptionKey: @"No data in response from ConnectionToken endpoint"}];
            completion(nil, error);
        }
        if (!(jsonObject && [jsonObject isKindOfClass:[NSDictionary class]])) {
            completion(nil, jsonSerializationError);
            return;
        }
        NSDictionary *json = (NSDictionary *)jsonObject;
        id secret = json[@"secret"];
        if (!(secret && [secret isKindOfClass:[NSString class]])) {
            NSError *error = [NSError errorWithDomain:@"com.stripe-terminal-ios.example"
                                                 code:2000
                                             userInfo:@{NSLocalizedDescriptionKey: @"Missing `secret` in ConnectionToken JSON response"}];
            completion(nil, error);
            return;
        }
        completion((NSString *)secret, nil);
    }];
    [task resume];
}

// ...

@end