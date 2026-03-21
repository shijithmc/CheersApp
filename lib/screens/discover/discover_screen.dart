import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';
import '../../providers/app_data_provider.dart';
import '../../widgets/common_widgets.dart';
import '../profile/referral_screen.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});
  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  int _selectedCat = 0;

  static const _categories = [
    {'emoji': '⭐', 'label': '5 Star Bar', 'color': 0xFFFDEBD0},
    {'emoji': '🏨', 'label': '4 Star Bar', 'color': 0xFFFADBD8},
    {'emoji': '🍻', 'label': '3 Star Bar', 'color': 0xFFD5F5E3},
    {'emoji': '🎉', 'label': 'Pubs', 'color': 0xFFFEF9E7},
    {'emoji': '🍷', 'label': 'Beer Wine Parlour', 'color': 0xFFE8DAEF},
  ];

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppDataProvider>();
    final allPosters = data.posters;
    final catLabel = _categories[_selectedCat]['label'] as String;
    final filtered = allPosters.where((p) => p.category == catLabel || allPosters.length <= 1).toList();
    final displayPosters = filtered.isNotEmpty ? filtered : allPosters;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          _topBar(data),
          _categoryTabs(),
          Expanded(
            child: displayPosters.isEmpty
                ? const Center(child: Text('No posters yet', style: TextStyle(color: AppTheme.textHint)))
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    itemCount: displayPosters.length,
                    itemBuilder: (_, i) => _PosterCard(poster: displayPosters[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _topBar(AppDataProvider data) {
    return Container(
      color: AppTheme.topBarBg,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8, left: 16, right: 16, bottom: 11),
      child: Row(
        children: [
          const SizedBox(width: 32),
          const Spacer(),
          const Text('All Posters', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReferralScreen())),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(50)),
              child: Row(children: [
                Container(width: 22, height: 22, decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                    child: const Center(child: Text('🎁', style: TextStyle(fontSize: 12)))),
                const SizedBox(width: 5),
                Text('${data.points}', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryTabs() {
    return Container(
      color: Colors.white,
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppTheme.border))),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_categories.length, (i) {
            final c = _categories[i];
            final active = _selectedCat == i;
            return GestureDetector(
              onTap: () => setState(() => _selectedCat = i),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Column(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: Color(c['color'] as int),
                        shape: BoxShape.circle,
                        border: Border.all(color: active ? AppTheme.primary : Colors.transparent, width: 2),
                      ),
                      child: Center(child: Text(c['emoji'] as String, style: const TextStyle(fontSize: 18))),
                    ),
                    const SizedBox(height: 4),
                    Text(c['label'] as String, style: TextStyle(fontSize: 9, color: active ? AppTheme.primary : AppTheme.textSecondary, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

Color _parseColor(String? c) {
  if (c == null || c.isEmpty) return const Color(0xFF333333);
  try { return Color(int.parse(c.replaceFirst('0x', ''), radix: 16)); } catch (_) { return const Color(0xFF333333); }
}

class _PosterCard extends StatefulWidget {
  final Poster poster;
  const _PosterCard({required this.poster});
  @override
  State<_PosterCard> createState() => _PosterCardState();
}

class _PosterCardState extends State<_PosterCard> {
  bool _liked = false;
  bool _saved = false;
  bool _commentsOpen = false;
  late int _likeCount;
  late int _commentCount;
  final _commentCtrl = TextEditingController();
  final List<_Comment> _comments = [_Comment('R', 'Rahul K', 'Amazing! 🔥', '2h ago', const Color(0xFFE07A3A))];

  @override
  void initState() {
    super.initState();
    _likeCount = widget.poster.likeCount;
    _commentCount = widget.poster.commentCount;
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.poster;
    final bg1 = _parseColor(p.bgColor1);
    final bg2 = _parseColor(p.bgColor2);
    final tagColor = _parseColor(p.tagColor);
    final saveColor = _parseColor(p.saveColor);

    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(shape: BoxShape.circle, color: p.avatarText != null ? const Color(0xFF1A2A3A) : const Color(0xFFEEEEEE)),
                child: Center(child: p.avatarText != null
                    ? Text(p.avatarText!, style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600))
                    : Text(p.avatarEmoji ?? '🏨', style: const TextStyle(fontSize: 20))),
              ),
              const SizedBox(width: 9),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p.venueName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                Text(p.venueMeta, style: const TextStyle(fontSize: 10, color: AppTheme.textHint)),
              ])),
              const Text('···', style: TextStyle(fontSize: 18, color: AppTheme.textHint)),
            ]),
          ),
          // Image area
          Stack(children: [
            Container(
              width: double.infinity, height: p.height,
              decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [bg1, bg2])),
              child: p.image != null
                  ? Image.network(p.image!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _contentWidget(p))
                  : _contentWidget(p),
            ),
            if (p.tag != null)
              Positioned(top: 10, left: 10, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(color: tagColor, borderRadius: BorderRadius.circular(50)),
                child: Text(p.tag!, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
              )),
            if (p.topRightLabel != null)
              Positioned(top: 10, right: 10, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4)),
                child: Text(p.topRightLabel!, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
              )),
          ]),
          // Actions
          Container(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFF0F0F0)))),
            child: Row(children: [
              _actionBtn(icon: Icons.favorite_border, activeIcon: Icons.favorite, active: _liked, activeColor: AppTheme.red,
                  label: _formatCount(_likeCount), onTap: () => setState(() { _liked = !_liked; _likeCount += _liked ? 1 : -1; })),
              _actionBtn(icon: Icons.chat_bubble_outline, label: '$_commentCount',
                  onTap: () => setState(() => _commentsOpen = !_commentsOpen)),
              _actionBtn(icon: Icons.send_outlined, onTap: () => _showShareSheet(context)),
              const Spacer(),
              GestureDetector(
                onTap: () => setState(() => _saved = !_saved),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: _saved ? AppTheme.green : (p.saveColor != null ? saveColor : AppTheme.primary),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(children: [
                    const Icon(Icons.bookmark_border, size: 12, color: Colors.white),
                    const SizedBox(width: 5),
                    Text(_saved ? 'Saved ✓' : (p.saveLabel ?? 'Save'),
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                  ]),
                ),
              ),
            ]),
          ),
          if (_commentsOpen) _commentSection(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _contentWidget(Poster p) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        if (p.contentEmoji != null) Text(p.contentEmoji!, style: const TextStyle(fontSize: 40)),
        if (p.contentTitle.isNotEmpty) ...[
          if (p.contentEmoji != null) const SizedBox(height: 8),
          Text(p.contentTitle, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white, height: 1.1), textAlign: TextAlign.center),
        ],
        if (p.contentSubtitle != null) ...[
          const SizedBox(height: 6),
          Text(p.contentSubtitle!, style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.7)), textAlign: TextAlign.center),
        ],
      ]),
    );
  }

  Widget _actionBtn({required IconData icon, IconData? activeIcon, bool active = false, Color? activeColor, String? label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Row(children: [
          Icon(active ? (activeIcon ?? icon) : icon, size: 20, color: active ? activeColor : const Color(0xFF555555)),
          if (label != null) ...[const SizedBox(width: 5), Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF555555), fontWeight: FontWeight.w500))],
        ]),
      ),
    );
  }

  Widget _commentSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFF0F0F0)))),
      child: Column(children: [
        ..._comments.map((c) => Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(width: 28, height: 28, decoration: BoxDecoration(color: c.color, shape: BoxShape.circle),
                child: Center(child: Text(c.initial, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)))),
            const SizedBox(width: 9),
            Expanded(child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(c.name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF333333))),
                Text(c.text, style: const TextStyle(fontSize: 12, color: Color(0xFF555555))),
                Text(c.time, style: const TextStyle(fontSize: 10, color: Color(0xFFAAAAAA))),
              ]),
            )),
          ]),
        )),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(children: [
            Container(width: 30, height: 30, decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                child: const Center(child: Text('A', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)))),
            const SizedBox(width: 8),
            Expanded(child: TextField(
              controller: _commentCtrl,
              style: const TextStyle(fontSize: 12, color: Color(0xFF333333)),
              decoration: InputDecoration(
                hintText: 'Add a comment...', hintStyle: const TextStyle(fontSize: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: const BorderSide(color: Color(0xFFE8E8E8))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: const BorderSide(color: Color(0xFFE8E8E8))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: const BorderSide(color: AppTheme.primary)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                filled: true, fillColor: const Color(0xFFFAFAFA),
              ),
              onSubmitted: (_) => _addComment(),
            )),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _addComment,
              child: Container(width: 32, height: 32, decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.send, size: 14, color: Colors.white)),
            ),
          ]),
        ),
      ]),
    );
  }

  void _addComment() {
    if (_commentCtrl.text.trim().isEmpty) return;
    setState(() {
      _comments.add(_Comment('Y', 'You', _commentCtrl.text.trim(), 'Just now', AppTheme.primary));
      _commentCount++;
      _commentCtrl.clear();
    });
    Future.delayed(const Duration(milliseconds: 600), () { if (mounted) setState(() => _commentsOpen = false); });
  }

  String _formatCount(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1).replaceAll('.0', '')}k' : '$n';

  void _showShareSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 8, 24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 36, height: 4, decoration: BoxDecoration(color: const Color(0xFFDDDDDD), borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          Text('Share – ${widget.poster.venueName}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              _shareItem('💬', 'WhatsApp', const Color(0xFFE8F5E9)),
              _shareItem('📸', 'Instagram', const Color(0xFFFCE4EC)),
              _shareItem('👍', 'Facebook', const Color(0xFFE3F2FD)),
              _shareItem('🐦', 'Twitter', const Color(0xFFE3F2FD)),
              _shareItem('🔗', 'Copy Link', const Color(0xFFF3E5F5)),
            ]),
          ),
          const SizedBox(height: 14),
          SizedBox(width: double.infinity, child: TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(backgroundColor: const Color(0xFFF5F5F5), padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Cancel', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
          )),
        ]),
      ),
    );
  }

  Widget _shareItem(String emoji, String label, Color bg) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Shared via $label ✓'), duration: const Duration(seconds: 2)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(children: [
          Container(width: 52, height: 52, decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
              child: Center(child: Text(emoji, style: const TextStyle(fontSize: 24)))),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF555555), fontWeight: FontWeight.w500)),
        ]),
      ),
    );
  }
}

class _Comment {
  final String initial, name, text, time;
  final Color color;
  _Comment(this.initial, this.name, this.text, this.time, this.color);
}
