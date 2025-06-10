 
// 请在 lib/models/api_models.dart 文件中创建此类

class EchoResponse {
  final Args args;
  final Headers headers;
  final String origin;
  final String url;

  EchoResponse({
    required this.args,
    required this.headers,
    required this.origin,
    required this.url,
  });

  factory EchoResponse.fromJson(Map<String, dynamic> json) {
    return EchoResponse(
      args: Args.fromJson(json['args'] as Map<String, dynamic>),
      headers: Headers.fromJson(json['headers'] as Map<String, dynamic>),
      origin: json['origin'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'args': args.toJson(),
        'headers': headers.toJson(),
        'origin': origin,
        'url': url,
      };
}

class Args {
  final String q1;

  Args({required this.q1});

  factory Args.fromJson(Map<String, dynamic> json) {
    return Args(q1: json['q1'] as String);
  }

  Map<String, dynamic> toJson() => {'q1': q1};
}

class Headers {
  final String accept;
  final String acceptEncoding;
  final String connection;
  final String host;
  final String remoteip;
  final String userAgent;

  Headers({
    required this.accept,
    required this.acceptEncoding,
    required this.connection,
    required this.host,
    required this.remoteip,
    required this.userAgent,
  });

  factory Headers.fromJson(Map<String, dynamic> json) {
    return Headers(
      accept: json['Accept'] as String,
      acceptEncoding: json['Accept-Encoding'] as String,
      connection: json['Connection'] as String,
      host: json['Host'] as String,
      remoteip: json['Remoteip'] as String,
      userAgent: json['User-Agent'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'Accept': accept,
        'Accept-Encoding': acceptEncoding,
        'Connection': connection,
        'Host': host,
        'Remoteip': remoteip,
        'User-Agent': userAgent,
      };
}
