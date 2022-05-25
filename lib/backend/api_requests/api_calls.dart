import '../../flutter_flow/flutter_flow_util.dart';

import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

class DadjokeCall {
  static Future<ApiCallResponse> call() {
    return ApiManager.instance.makeApiCall(
      callName: 'dadjoke',
      apiUrl: 'https://icanhazdadjoke.com/',
      callType: ApiCallType.GET,
      headers: {
        'User-Agent': 'DadJokes (https://github.com/timsneath/dadjokes)',
        'Accept': 'application/json',
      },
      params: {},
      returnBody: true,
    );
  }

  static dynamic joke(dynamic response) => getJsonField(
        response,
        r'''$.joke''',
      );
}
