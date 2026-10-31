#import <Foundation/Foundation.h>

extern void MSHookMessageEx(Class class, SEL selector, IMP replacement, IMP *result);
extern void MSHookFunction(void *function, void *replacement, void **original);
