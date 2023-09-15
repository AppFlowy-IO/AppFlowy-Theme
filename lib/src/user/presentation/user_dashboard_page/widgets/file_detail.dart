
import 'package:appflowy_theme_marketplace/src/user/presentation/user_dashboard_page/widgets/upload_form.dart';
import 'package:appflowy_theme_marketplace/src/widgets/ui_utils.dart';
import 'package:flutter/material.dart';
import '../../../domain/models/plugin_file_object.dart';
import 'delete_file_form.dart';

class FileDetail extends StatefulWidget {
  const FileDetail({super.key, required this.fileContent, required this.bucket});
  final PluginFileObject fileContent;
  final String bucket;

  @override
  State<FileDetail> createState() => _FileDetailState();
}

class _FileDetailState extends State<FileDetail> {
  void showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteFileForm(
          fileContent: widget.fileContent,
          bucket: widget.bucket,
        );
      },
    );
  }

  void showUploadDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return UploadForm(
          file: widget.fileContent,
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.parse(widget.fileContent.updatedAt!);
    String formattedDate = UiUtils.formatDate(date);

    return Container(
      padding: const EdgeInsets.all(ContentPadding.padding_12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Spacer(),
              IconButton(
                splashColor: UiUtils.transparent,
                splashRadius: IconSize.size_16,
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          Text(
            widget.fileContent.name,
            style: FontText.font_18,
          ),
          ContentSpacer.verticalSpacer_24,
          Text(style: FontText.font_14, 'bucket: ${widget.bucket}'),
          ContentSpacer.verticalSpacer_16,
          Text(style: FontText.font_14, 'bucketId: ${widget.fileContent.bucketId}'),
          ContentSpacer.verticalSpacer_16,
          Text(style: FontText.font_14, 'owner: ${widget.fileContent.owner}'),
          ContentSpacer.verticalSpacer_16,
          Text(style: FontText.font_14, 'id: ${widget.fileContent.id}'),
          ContentSpacer.verticalSpacer_16,
          Text(style: FontText.font_14, 'updatedAt: $formattedDate'),
          ContentSpacer.verticalSpacer_16,
          Text(style: FontText.font_14, 'createdAt: ${widget.fileContent.createdAt}'),
          ContentSpacer.verticalSpacer_16,
          Text(style: FontText.font_14, 'lastAccessedAt: ${widget.fileContent.lastAccessedAt}'),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () => showDeleteDialog(),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(UiUtils.error),
                ),
                child: const Text('Delete'),
              ),
              ContentSpacer.horizontalSpacer_16,
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('close'),
              ),
            ],
          )
        ],
      ),
    );
  }
}