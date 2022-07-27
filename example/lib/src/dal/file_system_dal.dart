import 'dart:io';
import 'package:flutter_nav2_oop/all.dart';
import 'package:path_provider/path_provider.dart';

late final FileSystemShortcuts fileSystemShortcuts;

class FileSystemShortcuts {
  final Directory documentsDirectory;

  FileSystemShortcuts({required this.documentsDirectory});
}

class FileSystemFutureProvider extends FutureProviderFacade<FileSystemShortcuts> {

  FileSystemFutureProvider() : super(
      (ref) async {
        final List<Future<Object>> futures = [
          getApplicationDocumentsDirectory()
        ];

        final List<Object> results = await Future.wait(futures);

        fileSystemShortcuts = FileSystemShortcuts(
            documentsDirectory: results[0] as Directory
        );

        return fileSystemShortcuts;
      }
  );
}