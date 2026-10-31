#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "substitute.h"

static NSString *const kEnabledKey = @"SiriGPT_Enabled";
static NSString *const kChatGPTScheme = @"openai-chatgpt://";

@interface SiriGPTHelper : NSObject
+ (BOOL)isEnabled;
+ (void)sendToChatGPTApp:(NSString *)query;
+ (void)speak:(NSString *)text;
@end

@implementation SiriGPTHelper

+ (BOOL)isEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kEnabledKey];
}

+ (void)speak:(NSString *)text {
    AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
    AVSpeechUtterance *utt = [AVSpeechUtterance speechUtteranceWithString:text];
    utt.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
    utt.rate = 0.5f;
    [synth speakUtterance:utt];
}

+ (void)sendToChatGPTApp:(NSString *)query {
    NSString *encoded = [query stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlString = [NSString stringWithFormat:@"%@x-callback-url/ask?text=%@&x-success=sirigpt://result?answer=", kChatGPTScheme, encoded];
    NSURL *url = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    } else {
        [self speak:@"ChatGPT app not found. Install it from the App Store."];
    }
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
            [SiriGPTHelper sendToChatGPTApp:text];
        });
    }
}

%end
