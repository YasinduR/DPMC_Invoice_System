import 'package:flutter/material.dart';
import 'package:myapp/errors/error_mapper.dart';
import 'package:myapp/widgets/app_loading_overlay.dart';
import 'package:myapp/widgets/app_snack_bars.dart';

// Execute API request with Loading Overlay
Future<T?> execute<T>({
  required BuildContext context,
  required Future<T> Function() task,
  Function(Exception e)? onError,
}) async {
  final overlay = AppLoadingOverlay();
  try {
    overlay.show(context);
    return await task();
  } catch (e) {
    final error = ErrorMapper.fromError(e);
    if (onError != null) {
      onError(error);
    } else {
      showSnackBar(
        context: context,
        message: error.toString(),
        type: MessageType.error,
      );
    }

    return null;
  } finally {
    overlay.hide();
  }
}
