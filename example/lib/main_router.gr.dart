// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'main_router.dart';

/// generated route for
/// [PostDetailsPage]
class PostDetailsRoute extends PageRouteInfo<PostDetailsRouteArgs> {
  PostDetailsRoute({
    Key? key,
    required int id,
    List<PageRouteInfo>? children,
  }) : super(
          PostDetailsRoute.name,
          args: PostDetailsRouteArgs(
            key: key,
            id: id,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'PostDetailsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<PostDetailsRouteArgs>(
          orElse: () => PostDetailsRouteArgs(id: pathParams.getInt('id')));
      return PostDetailsPage(
        key: args.key,
        id: args.id,
      );
    },
  );
}

class PostDetailsRouteArgs {
  const PostDetailsRouteArgs({
    this.key,
    required this.id,
  });

  final Key? key;

  final int id;

  @override
  String toString() {
    return 'PostDetailsRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [PostListPage]
class PostListRoute extends PageRouteInfo<void> {
  const PostListRoute({List<PageRouteInfo>? children})
      : super(
          PostListRoute.name,
          initialChildren: children,
        );

  static const String name = 'PostListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PostListPage();
    },
  );
}
