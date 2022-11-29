
# flutter_seo

[![pub package](https://img.shields.io/pub/v/seo.svg)](https://pub.dartlang.org/packages/seo)

Flutter package for SEO support on Web. The package listens to widget tree changes and converts `Seo.text(...)`, `Seo.image(...)`, `Seo.link(...)` widgets into html document tree.

See demo here: https://seo.krokyze.dev

&nbsp;
## Getting Started

To use this plugin, add `seo` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).
```yaml
dependencies:
  seo: ^0.0.2
```

&nbsp;  
Wrap your app within `SeoController` which will handle listening to widget tree changes and updating the html document tree. In case your app has authorization and user is logged in you can disable the controller by `enabled: false` as it's redundant to update the html document tree at that state.

```dart
import 'package:seo/seo.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return SeoController(
      enabled: true,
      tree: WidgetTree(context: context),
      child: MaterialApp(...),
    );
  }
}
```

&nbsp;  
There's two available SeoTree implementations:
* **WidgetTree (recommended)** - based on traversing widget tree, while it's bit slower than SemanticsTree it's production ready and doesn't have any blocking Flutter SDK issues.
* **SemanticsTree (`experimental`)** - based on traversing semantic data node tree. Does traverses the tree faster but enables known Flutter SDK issues:
    * https://github.com/flutter/flutter/issues/90794
    * https://github.com/flutter/flutter/issues/110284

&nbsp;
## Sample Usage
You should wrap all your SEO required widgets accordingly within `Seo.text(...)`, `Seo.image(...)`, `Seo.link(...)`.

##### Text
```dart
Seo.text(
  text: 'Some text',
  child: ...,
); // converts to: <p>Some text</p>
```

##### Image
```dart
Seo.image(
  src: 'http://www.example.com/image.jpg',
  alt: 'Some example image',
  child: ...,
); // converts to: <img src="http://www.example.com/image.jpg" alt="Some example image"/>
```

##### Link
```dart
Seo.link(
  href: 'http://www.example.com',
  anchor: 'Some example',
  child: ...,
); // converts to: <a href="http://www.example.com"><p>Some example</p></a>
```

From personal experience it's more comfortable to create custom [AppText](https://github.com/krokyze/flutter_seo/blob/main/example/lib/widgets/app_text.dart), [AppImage](https://github.com/krokyze/flutter_seo/blob/main/example/lib/widgets/app_image.dart), [AppLink](https://github.com/krokyze/flutter_seo/blob/main/example/lib/widgets/app_link.dart) base widgets and use those in the project.
