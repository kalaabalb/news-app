import 'package:flutter/material.dart';
import '../blocs/stories_provider.dart';
class Refresh extends StatelessWidget {
  final Widget child;
  final Future<void> Function()? onRefresh;

  const Refresh({
    Key? key,
    required this.child,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);
    return RefreshIndicator(
      child: child,
      onRefresh: onRefresh ?? () async {
        await bloc.clearCache();
        await bloc.fetchTopIds();
      },
    );
  }
}