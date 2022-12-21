# flutter_seo

[![pub package](https://img.shields.io/pub/v/seo.svg)](https://pub.dartlang.org/packages/seo)

Flutter package for SEO support on Web. The package listens to widget tree changes and converts `Seo.text(...)`, `Seo.image(...)`, `Seo.link(...)`, `Seo.meta(...)` widgets into html document tree.

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
* **SemanticsTree (`experimental`)** - based on traversing semantic data node tree. Does traverse the tree faster but enables known Flutter SDK issues and doesn't support `Seo.meta(...)`:
    * https://github.com/flutter/flutter/issues/90794
    * https://github.com/flutter/flutter/issues/110284

&nbsp;
## Sample Usage
You should wrap all your SEO required widgets accordingly within `Seo.text(...)`, `Seo.image(...)`, `Seo.link(...)` and SEO required pages within `Seo.meta(...)`. From personal experience it's more comfortable to create custom [AppText](https://github.com/krokyze/flutter_seo/blob/main/example/lib/widgets/app_text.dart), [AppImage](https://github.com/krokyze/flutter_seo/blob/main/example/lib/widgets/app_image.dart), [AppLink](https://github.com/krokyze/flutter_seo/blob/main/example/lib/widgets/app_link.dart), [AppMeta](https://github.com/krokyze/flutter_seo/blob/main/example/lib/widgets/app_meta.dart) base widgets and use those in the project.

#### Text
```dart
Seo.text(
  text: 'Some text',
  child: ...,
); // converts to: <p>Some text</p>
```

#### Image
```dart
Seo.image(
  src: 'http://www.example.com/image.jpg',
  alt: 'Some example image',
  child: ...,
); // converts to: <img src="http://www.example.com/image.jpg" alt="Some example image"/>
```

#### Link
```dart
Seo.link(
  href: 'http://www.example.com',
  anchor: 'Some example',
  child: ...,
); // converts to: <a href="http://www.example.com"><p>Some example</p></a>
```

#### Meta
```dart
Seo.meta(
  tags: [
    MetaNameTag(name: 'title', content: 'Flutter SEO Example'),
  ],
  child: ...,
); // converts to: <meta name="title" content="Flutter SEO Example">
```
> **WARNING**: Open Graph (og:title, og:description, etc.) and Twitter Card (twitter:title, twitter:description, etc.) will not work. [Read more](#supporting-open-graph-twitter-card-tags).

&nbsp;
## Tips

#### Force HTML renderer for bots
To improve initial page load speed for bots you can force HTML renderer which is 2MB smaller in download size than CanvasKit. Full example [here](https://github.com/krokyze/flutter_seo/blob/main/example/web/index.html).
```html
<script>
  if (bot) {
    window.flutterWebRenderer = "html";
  }
</script>
```

#### Supporting Open Graph, Twitter Card tags
Facebook, Twitter, etc. simply load index.html and don't execute any JavaScript that webpage contains so we're not able to change meta tags within Dart code. The proposed solution is to create simple Server-Side Rendering which would add Open Graph, Twitter Card tags within `index.html` before returning it to Client.