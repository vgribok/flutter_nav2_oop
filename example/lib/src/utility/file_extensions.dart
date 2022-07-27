import 'package:flutter_nav2_oop/all.dart';
// import 'package:glob/glob.dart';
// ignore: library_prefixes
import 'package:path/path.dart' as Path;
import 'dart:io';

extension DirectoryEx on Directory {
  // static final Glob allEntriesPattern = Glob("*");

  Directory subDir(String subDirPath) =>
      Directory(Path.join(path, subDirPath)).absolute;

  File file(String fileNameOnly) =>
      File(Path.join(path, fileNameOnly));

  Stream<T> _all<T>() =>
      list().where((entity) => entity is T).cast<T>();

  Stream<File> allFiles() => _all<File>();

  Stream<Directory> allDirectories() => _all<Directory>();

// Stream<FileSystemEntity> findEntities({Glob? pattern}) =>
//     pattern == null ? list() :
//     list().where((entry) => pattern.matches(entry.baseNameWithExtension));
//
// Stream<FileSystemEntity> findEntitiesExcept({Glob? pattern}) =>
//     pattern == null ? list() :
//     list().where((entry) => !pattern.matches(entry.baseNameWithExtension));
//
// Stream<T> _findEntities<T extends FileSystemEntity>({Glob? pattern}) =>
//     findEntities(pattern: pattern).where((entity) => entity is T).cast<T>();
//
// Stream<T> _findEntitiesExcept<T extends FileSystemEntity>({Glob? pattern}) =>
//     findEntitiesExcept(pattern: pattern).where((entity) => entity is T).cast<T>();
//
// Stream<File> findFiles({Glob? pattern}) =>
//     _findEntities<File>(pattern: pattern);
//
// Stream<File> findFilesExcept({Glob? pattern}) =>
//     _findEntitiesExcept<File>(pattern: pattern);
//
// Stream<Directory> findDirectories({Glob? pattern}) =>
//     _findEntities<Directory>(pattern: pattern);
//
// Stream<Directory> findDirectoriesExcept({Glob? pattern}) =>
//     _findEntitiesExcept<Directory>(pattern: pattern);
}

extension FileEx on File {
  Future<File> move(String newPath) async {
    try {
      // prefer using rename as it is probably faster
      return await rename(newPath);
    } on FileSystemException catch (e) {
      "Failed to move file vie rename due to $e".debugPrint();
      // if rename fails, copy the source file and then delete it
      final File newFile = await copy(newPath);
      await delete();
      return newFile;
    }
  }
}

extension FileSystemEntityEx on FileSystemEntity {
  String get extension => Path.extension(path);
  String get baseNameWithExtension => Path.basename(path);
  String get baseNameOnly => Path.basenameWithoutExtension(path);
  String get parentDirectoryPath => Path.dirname(absolute.path);
  Directory get parentDirectory => Directory(parentDirectoryPath);
  String getNewPathName(String newName) => Path.join(parentDirectoryPath, newName);
}