#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

static NSString *const kAPIKeyKey = @"SiriGPT_APIKey";
static NSString *const kEnabledKey  = @"SiriGPT_Enabled";
static NSString *const kAPIEndpoint = @"https://api.openai.com/v1/chat/completions";

@interface SiriGPTHelper : NSObject
+ (BOOL)isEnabled;
+ (NSString *)apiKey;
+ (void)sendToChatGPT:(NSString *)query completion:(void (^)(NSString *))completion;
+ (void)speak:(NSString *)text;
@end

@implementation SiriGPTHelper

+ (BOOL)isEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kEnabledKey];
}

+ (NSString *)apiKey {
    return [[NSUserDefaults standardUserDefaults] stringForKey:kAPIKeyKey];
}

+ (void)speak:(NSString *)text {
    AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
    AVSpeechUtterance *utt = [AVSpeechUtterance speechUtteranceWithString:text];
    utt.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
    utt.rate = 0.5f;
    [synth speakUtterance:utt];
}

+ (void)sendToChatGPT:(NSString *)query completion:(void (^)(NSString *))completion {
    NSString *key = [self apiKey];
    if (!key || key.length == 0) {
        completion(@"No OpenAI API key set. Open Settings > SiriGPT to add one.");
        return;
    }

    NSURL *url = [NSURL URLWithString:kAPIEndpoint];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    req.HTTPMethod = @"POST";
    [req setValue:[NSString stringWithFormat:@"Bearer %@", key] forHTTPHeaderField:@"Authorization"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSDictionary *msgUser = @{@"role": @"user", @"content": query};
    NSDictionary *body = @{
        @"model": @"gpt-4o-mini",
        @"messages": @[msgUser],
        @"max_tokens": @256,
        @"temperature": @0.7
    };
    NSError *err = nil;
    req.HTTPBody = [NSJSONSerialization dataWithJSONObject:body options:0 error:&err];
    if (err) {
        completion([NSString stringWithFormat:@"JSON error: %@", err.localizedDescription]);
        return;
    }

    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:req
        completionHandler:^(NSData *data, NSURLResponse *resp, NSError *err) {
        if (err) {
            completion([NSString stringWithFormat:@"Network error: %@", err.localizedDescription]);
            return;
        }
        if (!data) {
            completion(@"Empty response from ChatGPT.");
            return;
        }
        NSError *parseErr = nil;
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseErr];
        if (parseErr || !json) {
            completion(@"Failed to parse ChatGPT response.");
            return;
        }
        NSArray *choices = json[@"choices"];
        if (!choices || choices.count == 0) {
            completion(@"No choices in ChatGPT response.");
            return;
        }
        NSDictionary *first = choices[0];
        NSDictionary *msg = first[@"message"];
        NSString *content = msg[@"content"];
        if (!content) content = @"(no response)";
        completion(content);
    }];
    [task resume];
}

@end

%hook SiriUIAssistantViewController

- (void)viewDidAppear:(BOOL)animated {
    %orig(animated);
}

%end

%hook SiriUITextInputView

- (void)setText:(NSString *)text {
    %orig(text);
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kEnabledKey] && text && text.length > 0) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [SiriGPTHelper sendToChatGPT:text completion:^(NSString *reply) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SiriGPTHelper speak:reply];
                });
            }];
        });
    }
}

%end
