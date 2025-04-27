import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeMode themeMode = ThemeMode.system;
    final brightness = Theme.of(context).brightness;
    if (brightness == Brightness.dark) themeMode = ThemeMode.dark;
    if (brightness == Brightness.light) themeMode = ThemeMode.light;

    // Get all Google Fonts dynamically
    final allGoogleFontFamilies = GoogleFonts.asMap().keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: const SizedBox.shrink(),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(32),
            children: [
              Text('Appearance',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.brightness_6, size: 28),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text('Theme',
                            style: Theme.of(context).textTheme.bodyLarge),
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<ThemeMode>(
                          value: themeMode,
                          underline: const SizedBox.shrink(),
                          isDense: false,
                          borderRadius: BorderRadius.circular(8),
                          onChanged: (mode) {
                            if (mode != null) {
                              ref
                                  .read(settingsNotifierProvider.notifier)
                                  .toggleDarkMode(mode);
                            }
                          },
                          items: const [
                            DropdownMenuItem(
                              value: ThemeMode.system,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 8),
                                child: Row(
                                  children: [
                                    Icon(Icons.laptop_mac, size: 20),
                                    SizedBox(width: 8),
                                    Text('System'),
                                  ],
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: ThemeMode.light,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 8),
                                child: Row(
                                  children: [
                                    Icon(Icons.light_mode, size: 20),
                                    SizedBox(width: 8),
                                    Text('Light'),
                                  ],
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: ThemeMode.dark,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 8),
                                child: Row(
                                  children: [
                                    Icon(Icons.dark_mode, size: 20),
                                    SizedBox(width: 8),
                                    Text('Dark'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Font Family Picker (searchable dialog)
              Text('Font',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.font_download, size: 28),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text('Font Family',
                            style: Theme.of(context).textTheme.bodyLarge),
                      ),
                      Builder(
                        builder: (context) {
                          final selectedFont = ref.watch(settingsNotifierProvider).fontFamily;
                          return TextButton(
                            onPressed: () async {
                              final font = await showDialog<String>(
                                context: context,
                                builder: (context) => _FontPickerDialog(
                                  initialFont: selectedFont,
                                ),
                              );
                              if (font != null && font != selectedFont) {
                                ref.read(settingsNotifierProvider.notifier).setFontFamily(font);
                              }
                            },
                            child: Row(
                              children: [
                                Text(
                                  selectedFont,
                                  style: GoogleFonts.getFont(selectedFont),
                                ),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text('About',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Version'),
                  subtitle: const Text('0.0.1'),
                ),
              ),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.code),
                  title: const Text('Source Code'),
                  subtitle: const Text('github.com/ketanchoyal/secure_env'),
                  onTap: () {
                    // TODO: launch URL
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Font picker dialog widget
class _FontPickerDialog extends StatefulWidget {
  final String initialFont;
  const _FontPickerDialog({required this.initialFont});

  @override
  State<_FontPickerDialog> createState() => _FontPickerDialogState();
}

class _FontPickerDialogState extends State<_FontPickerDialog> {
  late TextEditingController _controller;
  String _filter = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allFonts = GoogleFonts.asMap().keys.toList()..sort();
    final filteredFonts = _filter.isEmpty
        ? allFonts
        : allFonts.where((f) => f.toLowerCase().contains(_filter.toLowerCase())).toList();
    return Dialog(
      child: SizedBox(
        width: 400,
        height: 500,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _controller,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Search Fonts',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (v) => setState(() => _filter = v),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                itemCount: filteredFonts.length,
                itemBuilder: (context, i) {
                  final font = filteredFonts[i];
                  return ListTile(
                    title: Text(font, style: GoogleFonts.getFont(font)),
                    trailing: font == widget.initialFont
                        ? const Icon(Icons.check, color: Colors.blue)
                        : null,
                    onTap: () => Navigator.of(context).pop(font),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
