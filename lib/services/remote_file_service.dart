import 'dart:io';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:myapp/config/app_config.dart';
import 'package:myapp/widgets/app_loading_overlay.dart';

class RemoteFileService {
  Future<String> uploadFile({
    required File localFile,
    required String remoteFolder,
    required String fileName,
  }) async {
    final host = Config.sftpHost;
    final port = Config.sftpPort;
    final username = Config.sftpUsername;
    final password = Config.sftpPassword;
    final basePath = Config.baseSftp;

    if (host.isEmpty ||
        username.isEmpty ||
        password.isEmpty ||
        basePath.isEmpty) {
      throw Exception('Missing SFTP configuration');
    }

    final normalizedFolder = remoteFolder.startsWith('/')
        ? remoteFolder.substring(1)
        : remoteFolder;
    final remotePath = '$basePath/$normalizedFolder/$fileName';

    final socket = await SSHSocket.connect(host, port);
    final client = SSHClient(
      socket,
      username: username,
      onPasswordRequest: () => password,
    );

    try {
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
    } finally {
      client.close();
    }
  }

  Future<void> uploadFileWithLoading({
    required BuildContext context,
    required File localFile,
    required String remoteFolder,
    required String fileName,
    required Function(String remotePath) onSuccess,
    required Function(String errorMessage) onError,
  }) async {
    final loadingOverlay = AppLoadingOverlay();
    if (!context.mounted) return;

    try {
      loadingOverlay.show(context);

      final remotePath = await uploadFile(
        localFile: localFile,
        remoteFolder: remoteFolder,
        fileName: fileName,
      ).timeout(const Duration(seconds: 25));

      onSuccess(remotePath);
    } catch (e) {
      onError('Image upload failed: $e');
    } finally {
      if (loadingOverlay.isShowing) {
        loadingOverlay.hide();
      }
    }
  }

  Future<void> deleteFile({required String remotePath}) async {
    final host = Config.sftpHost;
    final port = Config.sftpPort;
    final username = Config.sftpUsername;
    final password = Config.sftpPassword;

    final socket = await SSHSocket.connect(host, port);
    final client = SSHClient(
      socket,
      username: username,
      onPasswordRequest: () => password,
    );

    try {
      final sftp = await client.sftp();
      await sftp.remove(remotePath);
    } finally {
      client.close();
    }
  }
}
