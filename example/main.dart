import 'package:angel_framework/angel_framework.dart';
import 'package:angel_framework/http.dart';
import 'package:angel_static/angel_static.dart';
import 'package:file/local.dart';
import 'package:http_multi_server/http_multi_server.dart';
import 'package:logging/logging.dart';

main() async {
  var app = Angel();
  var fs = LocalFileSystem();
  app.logger = Logger('throwaway')..onRecord.listen(print);
  app.mimeTypeResolver
    ..addExtension('dart', 'text/dart')
    ..addExtension('lock', 'text/dart-lock')
    ..addExtension('yaml', 'text/yaml');

  app.get('/status/int:status', (req, res) {
    res.statusCode = req.params['status'];
    return res.close();
  });

  var vDir = CachingVirtualDirectory(app, fs,
      source: fs.currentDirectory, allowDirectoryListing: true);
  app.fallback(vDir.handleRequest);

  app.fallback((req, res) => throw AngelHttpException.notFound());

  app.errorHandler = (e, req, res) {
    res.statusCode = e.statusCode;
  };

  var http = AngelHttp.custom(app, (_, port) => HttpMultiServer.loopback(port));
  await http.startServer('127.0.0.1', 3000);
  print('Listening at ${http.uri}');
}
