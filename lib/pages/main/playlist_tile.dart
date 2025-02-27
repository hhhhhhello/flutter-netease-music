import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:quiet/material.dart';
import 'package:quiet/model/playlist_detail.dart';
import 'package:quiet/pages/page_playlist_edit.dart';
import 'package:quiet/pages/playlist/page_playlist_detail.dart';
import 'package:quiet/part/part.dart';
import 'package:quiet/repository/cached_image.dart';

///歌单列表元素
class PlaylistTile extends StatelessWidget {
  const PlaylistTile({
    Key? key,
    required this.playlist,
    this.enableMore = true,
    this.enableHero = true,
  }) : super(key: key);

  final PlaylistDetail playlist;

  final bool enableMore;

  final bool enableHero;

  @override
  Widget build(BuildContext context) {
    Widget cover = ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(4)),
      child: FadeInImage(
        placeholder: const AssetImage("assets/playlist_playlist.9.png"),
        image: CachedImage(playlist.coverUrl ?? ''),
        fit: BoxFit.cover,
        height: 50,
        width: 50,
      ),
    );
    if (enableHero) {
      cover = QuietHero(
        tag: playlist.heroTag,
        child: cover,
      );
    }

    return InkWell(
      onTap: () {
        context.secondaryNavigator!.push(MaterialPageRoute(
            builder: (context) =>
                PlaylistDetailPage(playlist.id!, previewData: playlist)));
      },
      child: SizedBox(
        height: 60,
        child: Row(
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(left: 16)),
            cover,
            const Padding(padding: EdgeInsets.only(left: 10)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Spacer(),
                  Text(
                    playlist.name!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 4)),
                  Text("${playlist.trackCount}首",
                      style: Theme.of(context).textTheme.caption),
                  const Spacer(),
                ],
              ),
            ),
            if (enableMore)
              PopupMenuButton<PlaylistOp>(
                itemBuilder: (context) {
                  return const [
                    PopupMenuItem(value: PlaylistOp.share, child: Text("分享")),
                    PopupMenuItem(
                        value: PlaylistOp.edit, child: Text("编辑歌单信息")),
                    PopupMenuItem(value: PlaylistOp.delete, child: Text("删除")),
                  ];
                },
                onSelected: (op) {
                  switch (op) {
                    case PlaylistOp.delete:
                    case PlaylistOp.share:
                      toast("未接入。");
                      break;
                    case PlaylistOp.edit:
                      context.secondaryNavigator!
                          .push(MaterialPageRoute(builder: (context) {
                        return PlaylistEditPage(playlist);
                      }));
                      break;
                  }
                },
                icon: const Icon(Icons.more_vert),
              ),
          ],
        ),
      ),
    );
  }
}

enum PlaylistOp { edit, share, delete }
