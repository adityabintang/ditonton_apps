import 'dart:io';

String readJson(String name) {
  var dir = Directory.current.path;
  if (dir.endsWith('test')) {
    return File('$dir/$name').readAsStringSync();
  } else if (dir.endsWith('movie')) {
    return File('$dir/test/$name').readAsStringSync();
  } else {
    return File('$dir/movie/test/$name').readAsStringSync();
  }
}
