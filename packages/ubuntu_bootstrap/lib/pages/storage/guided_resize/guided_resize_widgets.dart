import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subiquity_client/subiquity_client.dart';
import 'package:ubuntu_bootstrap/l10n.dart';
import 'package:ubuntu_widgets/ubuntu_widgets.dart';
import 'package:ubuntu_wizard/ubuntu_wizard.dart';
import 'package:yaru/yaru.dart';

import 'guided_resize_model.dart';

class StorageSelector extends ConsumerWidget {
  const StorageSelector({
    super.key,
    required this.count,
    this.selectedIndex,
    this.onSelected,
  });

  final int count;
  final int? selectedIndex;
  final ValueChanged<int?>? onSelected;

  static String formatStorage(BuildContext context, WidgetRef ref, int index) {
    final model = ref.read(guidedResizeModelProvider);
    final partition = model.getPartition(index);
    final os = model.getOS(index);

    // "sda1 - Ubuntu 22.04 LTS - 123 GB"
    final parts = [
      partition?.sysname,
      if (os != null) os.long,
      if (partition?.size != null) context.formatByteSize(partition!.size!),
    ];
    return parts.join(' - ');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = UbuntuBootstrapLocalizations.of(context);
    return Row(
      children: <Widget>[
        Text(lang.selectGuidedStorageDropdownLabel),
        const SizedBox(width: kWizardSpacing),
        Expanded(
          child: MenuButtonBuilder<int>(
            values: List.generate(count, (index) => index),
            selected: selectedIndex != null &&
                    selectedIndex! >= 0 &&
                    selectedIndex! < count
                ? selectedIndex
                : null,
            onSelected: onSelected,
            itemBuilder: (context, index, child) => Text(
              formatStorage(context, ref, index),
              key: ValueKey(index),
            ),
          ),
        )
      ],
    );
  }
}

class HiddenPartitionLabel extends StatelessWidget {
  const HiddenPartitionLabel({
    super.key,
    required this.partitions,
    required this.onTap,
  });

  final List<Partition> partitions;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hidden = partitions.length - 1;
    if (hidden <= 1) {
      return const SizedBox.shrink();
    }

    final lang = UbuntuBootstrapLocalizations.of(context);
    return Html(
      data: lang.installAlongsideHiddenPartitions(hidden, ''),
      style: {
        'body': Style(
          margin: Margins.zero,
          fontSize: FontSize(
            Theme.of(context).textTheme.bodySmall!.fontSize!,
          ),
        ),
        'a': Style(color: Theme.of(context).colorScheme.link),
      },
      onLinkTap: (url, _, __) => onTap(),
    );
  }
}
