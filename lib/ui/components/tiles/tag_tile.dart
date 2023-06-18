import 'package:flutter/material.dart';

class TagTile extends StatelessWidget {
  final String tag;
  final Function(String) onDeleteTag;

  const TagTile(
      this.tag,
      this.onDeleteTag,
      {super.key}
      );

  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding: const EdgeInsets.symmetric(horizontal: 5.0),
      label: Text(tag),
      deleteIcon: const Icon(Icons.close),
      onDeleted: () => onDeleteTag(tag),
    );
  }
}