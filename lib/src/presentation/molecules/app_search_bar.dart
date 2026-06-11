import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_durations.dart';
import '../../core/extensions/context_extensions.dart';

/// Reusable, debounced search input — independent of any feature. Wire
/// [onChanged] (debounced) / [onSubmitted] to a cubit wherever it's used.
/// Works uncontrolled or controlled (pass a [controller]).
class AppSearchBar extends StatefulWidget {
  const AppSearchBar({
    super.key,
    this.hint,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.debounce = AppDurations.searchDebounce,
    this.autofocus = false,
  });

  final String? hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final Duration debounce;
  final bool autofocus;

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late final TextEditingController _controller;
  late final bool _ownsController;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_refreshClearButton);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_refreshClearButton);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _refreshClearButton() => setState(() {});

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(widget.debounce, () => widget.onChanged?.call(value));
  }

  void _clear() {
    _controller.clear();
    _debounce?.cancel();
    widget.onChanged?.call('');
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final type = context.typography;

    return Container(
      decoration: BoxDecoration(
        color: palette.inputBg,
        borderRadius: BorderRadius.circular(AppDimens.radiusChip),
        border: Border.all(color: palette.divider),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(Icons.search_rounded, size: 20, color: palette.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: widget.autofocus,
              onChanged: _onChanged,
              onSubmitted: widget.onSubmitted,
              textInputAction: TextInputAction.search,
              style: type.inputText,
              cursorColor: palette.textPrimary,
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: widget.hint ?? context.translate.searchHint,
                hintStyle: type.inputHint,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          if (_controller.text.isNotEmpty)
            GestureDetector(
              onTap: _clear,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.close_rounded,
                    size: 18, color: palette.textMuted),
              ),
            )
          else
            const SizedBox(width: 12),
        ],
      ),
    );
  }
}
