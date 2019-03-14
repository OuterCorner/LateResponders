# LateResponders

A framework to delay handling responder chain actions further up the chain. Read the rationale behind this on this [blog post](http://pfandrade.me/blog/late-responders-sidestepping-the-responder-chain/).

## Installation

You have a few different options:

### Manual installation

 * Include the LateResponders.xcodeproj as a dependency in your project.
 * Copy the source files manually to your project.

### Carthage

Add LateResponders as a dependency on your ```Cartfile```:

```
github "OuterCorner/LateResponders"
```
And run:

```
carthage update
```

## Usage

Implement the ```OCLateResponderRegistering``` protocol on a responder high up the responder chain. On iOS this could be the root view controller for example.

``` ObjC
@interface RootViewController <OCLateResponderRegistering>
@end

@implementation RootViewController {
    OCLateResponderRegistry *_registry;
}

#pragma mark - Late responders

- (OCLateResponderRegistry *)lateResponderRegistry
{
    if (_registry == nil) {
        _registry = [[OCLateResponderRegistry alloc] init];
        __weak typeof(self) wSelf = self;
        _registry.lastResponder.nextResponderBlock = ^UIResponder *{
            return [wSelf superNextResponder];
        };
    }
    
    return _registry;
}

- (UIResponder *)nextResponder
{
    return [self.lateResponderRegistry initialResponder];
}

- (UIResponder *)superNextResponder
{
    return [super nextResponder];
}
```


To register late responders with the registry you could do something like this:

```ObjC
- (void)registerLateResponders
{
    OCLateResponderRegistry *registry = [[self lateResponderRegisteringViewController] lateResponderRegistry];
    
    [self.lateResponder deregister];
    OCLateResponderProxy *proxy = [[OCLateResponderProxy alloc] initWithProxiedResponder:self weight:20];
    proxy.proxiedSelectorNames = @[
        NSStringFromSelector(@selector(action1:)),
        NSStringFromSelector(@selector(action2:)),
        ];
    proxy.keyCommands =
    @[
      [UIKeyCommand keyCommandWithInput:@"1" modifierFlags:UIKeyModifierCommand action:@selector(action1:)],
      [UIKeyCommand keyCommandWithInput:@"2" modifierFlags:UIKeyModifierCommand action:@selector(action2:)]
    ];
    [registry registerLateResponder:proxy];
    self.lateResponder = proxy;
}
```

## License

This project is licensed under the MIT License - see [LICENSE](LICENSE).
