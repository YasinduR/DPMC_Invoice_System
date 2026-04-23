import 'dart:io';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:myapp/config/app_config.dart';
import 'package:myapp/widgets/app_loading_overlay.dart';

class RemoteFileService {
  String _normalizedBasePath() {
    final basePath = Config.baseSftp;
    if (basePath.isEmpty) {
      throw Exception('Missing SFTP base path');
    }
    return basePath.endsWith('/')
        ? basePath.substring(0, basePath.length - 1)
        : basePath;
  }

  String _normalizeRelativePath(String path) {
    return path.startsWith('/') ? path.substring(1) : path;
  }

  // Creates and returns an authenticated SFTP client - added by Darshan R on 22/04/2026.
  Future<SSHClient> _createClient() async {
    final host = Config.sftpHost;
    final port = Config.sftpPort;
    final username = Config.sftpUsername;
    final password = Config.sftpPassword;

    if (host.isEmpty || username.isEmpty || password.isEmpty) {
      throw Exception('Missing SFTP configuration');
    }

    final socket = await SSHSocket.connect(host, port);
    return SSHClient(
      socket,
      username: username,
      onPasswordRequest: () => password,
    );
  }

  Future<T> _withClient<T>(Future<T> Function(SSHClient client) action) async {
    final client = await _createClient();
    try {
      return await action(client);
    } finally {
      client.close();
    }
  }

  // Wraps operations with loading overlay and common error handling - added by Darshan R on 22/04/2026.
  Future<void> _runWithOverlay({
    required BuildContext context,
    required Future<void> Function() action,
    required Function(String errorMessage) onError,
    required String errorPrefix,
  }) async {
    final loadingOverlay = AppLoadingOverlay();
    if (!context.mounted) return;

    try {
      loadingOverlay.show(context);
      await action();
    } catch (e) {
      onError('$errorPrefix: $e');
    } finally {
      if (loadingOverlay.isShowing) {
        loadingOverlay.hide();
      }
    }
  }

  // Resolves a full SFTP path from folder and filename - added by Darshan R on 22/04/2026.
  String buildRemotePath({
    required String remoteFolder,
    required String fileName,
  }) {
    final base = _normalizedBasePath();
    final folder = _normalizeRelativePath(remoteFolder);
    return '$base/$folder/$fileName';
  }

  String buildAbsolutePathFromRelative(String relativePath) {
    final base = _normalizedBasePath();
    final rel = _normalizeRelativePath(relativePath);
    return '$base/$rel';
  }

  // Internal file upload handle without overlay - added by Darshan R on 22/04/2026.
  Future<String> _uploadFileInternal({
    required File localFile,
    required String remoteFolder,
    required String fileName,
  }) async {
    final remotePath = buildRemotePath(
      remoteFolder: remoteFolder,
      fileName: fileName,
    );

    return _withClient((client) async {
      final sftp = await client.sftp();
      final remoteFile = await sftp.open(
        remotePath,
        mode:
            SftpFileOpenMode.create |
            SftpFileOpenMode.write |
            SftpFileOpenMode.truncate,
      );
      final bytes = await localFile.readAsBytes();
      await remoteFile.writeBytes(bytes);
      await remoteFile.close();
      return remotePath;
    });
  }

  // Internal fetch helper that downloads to a temporary local file - added by Darshan R on 22/04/2026.
  Future<File> _fetchFileInternal({
    required String remotePath,
    String? localFileName,
  }) async {
    return _withClient((client) async {
      final sftp = await client.sftp();
      final remoteFile = await sftp.open(
        remotePath,
        mode: SftpFileOpenMode.read,
      );
      final bytes = await remoteFile.readBytes();
      await remoteFile.close();

      final fileName = localFileName ?? remotePath.split('/').last;
      final localFile = File('${Directory.systemTemp.path}/$fileName');
      await localFile.writeAsBytes(bytes, flush: true);
      return localFile;
    });
  }

  // Public file upload with overlay - added by Darshan R on 22/04/2026.
  Future<void> uploadFile({
    required BuildContext context,
    required File localFile,
    required String remoteFolder,
    required String fileName,
    required Function(String remotePath) onSuccess,
    required Function(String errorMessage) onError,
  }) async {
    await _runWithOverlay(
      context: context,
      errorPrefix: 'Image upload failed',
      onError: onError,
      action: () async {
        final remotePath = await _uploadFileInternal(
          localFile: localFile,
          remoteFolder: remoteFolder,
          fileName: fileName,
        ).timeout(const Duration(seconds: 25));
        onSuccess(remotePath);
      },
    );
  }

  // Public file fetching with overlay - added by Darshan R on 23/04/2026.
  Future<void> fetchFile({
    required BuildContext context,
    required String remotePath,
    String? localFileName,
    required Function(File file) onSuccess,
    required Function(String errorMessage) onError,
  }) async {
    await _runWithOverlay(
      context: context,
      errorPrefix: 'Image fetch failed',
      onError: onError,
      action: () async {
        final file = await _fetchFileInternal(
          remotePath: remotePath,
          localFileName: localFileName,
        ).timeout(const Duration(seconds: 25));
        onSuccess(file);
      },
    );
  }

  // Public file delete with overlay - added by Darshan R on 22/04/2026.
  Future<void> deleteFile({
    required BuildContext context,
    required String remotePath,
    required VoidCallback onSuccess,
    required Function(String errorMessage) onError,
  }) async {
    await _runWithOverlay(
      context: context,
      errorPrefix: 'Image delete failed',
      onError: onError,
      action: () async {
        await _withClient((client) async {
          final sftp = await client.sftp();
          await sftp.remove(remotePath);
        }).timeout(const Duration(seconds: 25));
        onSuccess();
      },
    );
  }
}
