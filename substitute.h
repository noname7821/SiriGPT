#import <Foundation/Foundation.h>

extern void MSHookMessageEx(Class class, SEL selector, IMP replacement, IMP *result);
extern void MSHookMessageEx(void *handle, const char *selector_name, IMP replacement, IMP *result);
extern void MSHookFunction(void *function, void *replacement, void **original);
extern void MSHookIvar(void *object, const char *ivar_name, void *replacement, void **original);
