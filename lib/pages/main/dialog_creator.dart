import 'package:flutter/material.dart';
import 'package:quiet/part/part.dart';
import 'package:quiet/repository/netease.dart';

class PlaylistCreatorDialog extends StatefulWidget {
  @override
  _PlaylistCreatorDialogState createState() {
    return _PlaylistCreatorDialogState();
  }
}

class _PlaylistCreatorDialogState extends State<PlaylistCreatorDialog> {
  ///communicate to server,creating new playlist
  bool creating = false;

  String? error;

  final GlobalKey<FormFieldState<String>> _formKey = GlobalKey();

  Future<void> _create(String? name) async {
    final playlistDetail = await showLoaderOverlay(context,
        neteaseRepository!.createPlaylist(name).then((value) => value!));
    if (playlistDetail.isValue) {
      Navigator.pop(context, playlistDetail);
    } else {
      setState(() {
        error = playlistDetail.asError!.error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.only(left: 24, right: 24, top: 4),
      title: const Text("新建歌单"),
      content: TextFormField(
        key: _formKey,
        maxLength: 20,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: "请输入歌单标题",
          errorText: error,
        ),
        validator: (v) {
          if (v!.isEmpty) {
            return "歌单名不能为空";
          }
          return null;
        },
        onFieldSubmitted: _create,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            primary: Theme.of(context).textTheme.caption?.color,
          ),
          child: const Text("取消"),
        ),
        TextButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            _create(_formKey.currentState!.value);
          },
          child: const Text("创建"),
        )
      ],
    );
  }
}
