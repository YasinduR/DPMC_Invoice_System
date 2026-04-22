import 'dart:io';
import 'package:dartssh2/dartssh2.dart';
import 'package:myapp/config/app_config.dart';

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
    } catch (e, st) {
      rethrow;
    } finally {
      client.close();
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
