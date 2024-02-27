import 'dart:async';

import 'package:piiprent/constants.dart';

class ListService {
  final Function? action;
  Map<String, dynamic> params;
  Map<String, dynamic>? _initParams;

  int _limit = listLimit;
  int _offset = 0;
  int _count = 0;
  List<dynamic>? _data;

  get canFetchMore {
    return _offset < _count;
  }

  StreamController _streamController = StreamController();
  StreamController _fetchStreamController = StreamController.broadcast();

  get stream {
    return _streamController.stream;
  }

  get fetchStream {
    return _fetchStreamController.stream;
  }

  ListService({
    this.action,
    this.params = const <String, dynamic>{},
  }) {
    _initParams = params;
    start();
    _fetchStreamController.add(false);
  }

  start() async {
    try {
      updateParams({
        "limit": _limit.toString(),
        "offset": _offset.toString(),
      });

      var data = await action!(params);
      _count = data['count'];
      _offset = _offset + data['list'].length as int;
      _data = data['list'];
      _streamController.add(_data);
    } catch (e) {
      print(e);
    }
  }

  fetchMore() async {
    _fetchStreamController.add(true);

    try {
      updateParams({
        "limit": _limit.toString(),
        "offset": _offset.toString(),
      });
      var data = await action!(params);
      data['list'].insertAll(0, _data);
      _data = data['list'];
      _offset = _data!.length;
      _streamController.add(_data);
    } catch (e) {
      print(e);
    }
  }

  updateParams(Map<String, dynamic> query, [bool reset = false]) {
    params = {...params, ...query};

    if (reset) {
      _streamController.add(null);
      _offset = 0;
      start();
    }
  }

  Future reset() {
    params = _initParams!;
    _offset = 0;
    _streamController.add(null);
    return start();
  }

  closeStream() {
    _streamController.close();
  }
}
