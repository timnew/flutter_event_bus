part of 'flutter_event_bus.dart';

/// The signature of StoreWidgetBuilder
/// It returns a [ProxyWidget], who wraps up [child].
/// Typically an [InheritedWidget] or [InheritedModel] should be returned
typedef ProxyWidget StoreWidgetBuilder(BuildContext context, Widget child);
