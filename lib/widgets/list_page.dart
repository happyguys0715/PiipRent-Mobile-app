import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:piiprent/screens/more_button.dart';
import 'package:piiprent/services/list_service.dart';
import 'package:piiprent/widgets/size_config.dart';

class ListPage<T> extends StatefulWidget {
  final Function action;
  final Map<String, dynamic>? params;
  final Function getChild;
  final Stream? updateStream;

  ListPage({
    required this.action,
    required this.getChild,
    this.params,
    this.updateStream,
  });

  @override
  _ListPageState<T> createState() => _ListPageState<T>();
}

class _ListPageState<T> extends State<ListPage<T>> {
  ListService? _listService;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> params;

    if (widget.params == null) {
      params = Map();
    } else {
      params = widget.params!;
    }

    _listService = ListService(action: widget.action, params: params);

    if (widget.updateStream != null) {
      widget.updateStream?.listen((params) {
        _listService?.updateParams(params, true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    BoxConstraints constraints =
        BoxConstraints(maxWidth: size.width, maxHeight: size.height);
    SizeConfig().init(constraints, orientation);
    if (_listService == null) {
      return Container(
        width: 0,
        height: 0,
      );
    }

    return StreamBuilder(
      stream: _listService?.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<T> data = snapshot.data;

          if (data.length == 0) {
            return Center(
              child: Text(
                translate('message.no_data'),
                style: TextStyle(
                  fontSize: SizeConfig.heightMultiplier * 2.34,
                ),
              ),
            );
          }

          return RefreshIndicator(
            child: ListView.builder(
              itemCount: data.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == data.length) {
                  return MoreButton(
                    isShow: _listService?.canFetchMore,
                    stream: _listService?.fetchStream,
                    onPressed: () => _listService?.fetchMore(),
                  );
                }

                T instance = data[index];

                return Padding(
                  padding: EdgeInsets.all(
                    //16.0,
                    SizeConfig.heightMultiplier*2.34,
                  ),
                  child: widget.getChild(instance, _listService?.reset),
                );
              },
            ),
            onRefresh: () => _listService!.reset(),
          );

          ///todo:OriginalCode
          // return RefreshIndicator(
          //   child: ListView.builder(
          // itemCount: data.length + 1,
          //   itemBuilder: (BuildContext context, int index) {
          //     if (index == data.length) {
          //       return MoreButton(
          //         isShow: _listService.canFetchMore,
          //         stream: _listService.fetchStream,
          //         onPressed: () => _listService.fetchMore(),
          //       );
          //     }
          //
          //     T instance = data[index];
          //
          //     return Padding(
          //       padding: const EdgeInsets.all(16.0),
          //       child: widget.getChild(instance, _listService.reset),
          //     );
          //   },
          // ),
          //
          //   onRefresh: () => _listService.reset(),
          // );
          ///todo:OriginalCode
        }

        if (snapshot.hasError) {
          return Container(
            child: Text(translate('message.has_error'),style: TextStyle(
              fontSize: SizeConfig.heightMultiplier*2.34,
            ),),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
// return ListView.builder(
//   itemCount: data.length + 1,
//   itemBuilder: (BuildContext context, int index) {
//     if (index == data.length) {
//       return MoreButton(
//         isShow: _listService.canFetchMore,
//         stream: _listService.fetchStream,
//         onPressed: () => _listService.fetchMore(),
//       );
//     }
//
//     T instance = data[index];
//
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: widget.getChild(instance, _listService.reset),
//     );
//   },
// );
}

// child: LayoutBuilder(
//   builder: (context, constraints) {
//     return OrientationBuilder(builder: (context, orientation) {
//       return GridView.builder(
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           childAspectRatio: orientation == Orientation.landscape
//               ?  5 / 4.6
//               :  5 / 3.45,
//           crossAxisCount: size.width > 550
//               ?  2
//               : 1,
//         ),
//         itemCount: data.length + 1,
//         itemBuilder: (context, index) {
//           if (index == data.length) {
//             return MoreButton(
//               isShow: _listService.canFetchMore,
//               stream: _listService.fetchStream,
//               onPressed: () => _listService.fetchMore(),
//             );
//           }
//
//           T instance = data[index];
//
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: widget.getChild(instance, _listService.reset),
//           );
//         },
//       );
//     });
//   },
// ),
