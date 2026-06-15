import 'package:final_project/core/constants/image_link.dart';
import 'package:final_project/features/policy/presentation/screens/news_list_screen.dart';
import 'package:final_project/shared/footer/section_and_widget/footer_contact_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/features/policy/presentation/screens/policy_screen.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
import '../../core/utils/responsive_layout.dart';

class AppFooter extends StatefulWidget {
  const AppFooter({super.key});

  @override
  State<AppFooter> createState() => _AppFooterState();
}

class _AppFooterState extends State<AppFooter> {
  bool _isIntroExpanded = false;
  bool _isContactExpanded = false;
  bool _isInfoExpanded = false;
  bool _isPolicySubExpanded = false;

  Future<void> _launchUrlWithFallback(String primaryUrl, String fallbackUrl) async {
    final Uri primaryUri = Uri.parse(primaryUrl);
    final Uri fallbackUri = Uri.parse(fallbackUrl);
    try {
      bool launched = await launchUrl(primaryUri, mode: LaunchMode.externalApplication);
      if (!launched) await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool isMobile = context.screenWidth < 800;

    // Styles sử dụng extension sp()
    TextStyle headerStyle = TextStyle(
        color: kHeaderTextColor,
        fontSize: context.sp(18),
        fontWeight: FontWeight.bold);

    TextStyle descriptionStyle = TextStyle(
        color: Colors.white,
        fontSize: context.sp(14),
        height: 1.5); // Thêm line-height cho dễ đọc

    return Container(
      width: double.infinity,
      color: kFooterBackgroundColor,
      // Sử dụng rh cho padding dọc của footer
      padding: EdgeInsets.symmetric(vertical: context.rh(40)),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. LOGO SECTION
                Center(
                  child: SvgPicture.network(
                    ImageLink.logoFooter,
                    // Sử dụng rh để scale logo theo chiều dọc linh hoạt
                    height: isMobile ? context.rh(50) : context.rh(70),
                  ),
                ),
                SizedBox(height: context.rh(30)),

                // 2. CONTACT CARDS
                Wrap(
                  spacing: context.rw(16),
                  runSpacing: context.rh(16),
                  alignment: WrapAlignment.center,
                  children: [
                    _buildContactCardWrapper(context, isMobile, Icons.phone_outlined, l10n.general_hotline, l10n.general_hotlineNumber),
                    _buildContactCardWrapper(context, isMobile, Icons.email_outlined, l10n.footer_emailTitle, l10n.general_emailInfo),
                    _buildContactCardWrapper(context, isMobile, Icons.access_time, l10n.general_workingHours, l10n.general_workingTime),
                  ],
                ),

                Divider(color: kSidebarDividerColor.withOpacity(0.2), height: context.rh(50)),

                // 3. MAIN CONTENT
                LayoutBuilder(builder: (context, constraints) {
                  double colWidth = isMobile ? constraints.maxWidth : (constraints.maxWidth / 2) - context.rw(20);

                  return Wrap(
                    spacing: context.rw(40),
                    runSpacing: context.rh(20),
                    children: [
                      // --- CỘT TRÁI ---
                      SizedBox(
                        width: colWidth,
                        child: Column(
                          children: [
                            _buildExpandableSection(
                              context: context,
                              title: l10n.footer_introduce,
                              isExpanded: isMobile ? _isIntroExpanded : true,
                              isMobile: isMobile,
                              onTap: () => setState(() => _isIntroExpanded = !_isIntroExpanded),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.footer_introDescription, style: descriptionStyle),
                                  SizedBox(height: context.rh(12)),
                                  _buildIconDetail(context, Icons.location_on_outlined, l10n.footer_addressDetail),
                                  _buildIconDetail(context, Icons.phone_in_talk_outlined, l10n.footer_contactDetail),
                                  _buildIconDetail(context, Icons.mail_outline, l10n.footer_emailDetail),
                                ],
                              ),
                            ),
                            SizedBox(height: isMobile ? 0 : context.rh(30)),
                            _buildExpandableSection(
                              context: context,
                              title: l10n.footer_contact,
                              isExpanded: isMobile ? _isContactExpanded : true,
                              isMobile: isMobile,
                              onTap: () => setState(() => _isContactExpanded = !_isContactExpanded),
                              child: Wrap( // Đổi sang Wrap cho social icons
                                spacing: context.rw(15),
                                children: [
                                  _socialIcon(context, Icons.facebook, () => _launchUrlWithFallback('fb://facewebmodal/f?href=https://www.facebook.com/wonderingvietnam', 'https://www.facebook.com/wonderingvietnam')),
                                  _socialIcon(context, Icons.camera_alt_outlined, () => _launchUrlWithFallback('instagram://user?username=wonderingvietnam', 'https://www.instagram.com/wonderingvietnam')),
                                  _socialIcon(context, Icons.tiktok, () => _launchUrlWithFallback('tiktok://user?username=wondering_vietnam', 'https://www.tiktok.com/@wondering_vietnam')),
                                  _socialIcon(context, Icons.chat_bubble_outline, () => _launchUrlWithFallback('whatsapp://send?phone=84901118185', 'https://wa.me/84901118185')),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // --- CỘT PHẢI ---
                      SizedBox(
                        width: colWidth,
                        child: Column(
                          children: [
                            _buildExpandableSection(
                              context: context,
                              title: l10n.footer_informationTitle,
                              isExpanded: isMobile ? _isInfoExpanded : true,
                              isMobile: isMobile,
                              onTap: () => setState(() => _isInfoExpanded = !_isInfoExpanded),
                              child: Column(
                                children: [
                                  _buildInfoItem(context, l10n.footer_introduce, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PolicyScreen(postId: 10)))),
                                  _buildInfoItem(context, l10n.footer_newsTitle, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NewsListScreen()))),
                                  _buildInfoItem(
                                    context,
                                    l10n.footer_cancellationPolicy,
                                    hasDropdown: true,
                                    onTap: () => setState(() => _isPolicySubExpanded = !_isPolicySubExpanded),
                                    isExpanded: _isPolicySubExpanded,
                                  ),
                                  if (_isPolicySubExpanded) _buildPolicySubMenu(context, l10n),
                                  _buildInfoItem(context, l10n.footer_guideTitle, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PolicyScreen(postId: 8)))),
                                ],
                              ),
                            ),
                            SizedBox(height: context.rh(20)),
                            _buildNewsletterSection(context, isMobile, l10n, headerStyle),
                          ],
                        ),
                      ),
                    ],
                  );
                }),

                SizedBox(height: context.rh(40)),
                Divider(color: kHeaderTextColor.withOpacity(0.3)),
                SizedBox(height: context.rh(15)),

                // 4. COPYRIGHT & CARDS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        l10n.general_copyright,
                        style: TextStyle(color: kHeaderTextColor, fontSize: context.sp(12)),
                      ),
                    ),
                    Row(
                      children: [
                        _cardIcon(context, "assets/icons/card_icon.svg"),
                        SizedBox(width: context.rw(10)),
                        _cardIcon(context, "assets/icons/master_card_icon.svg"),
                        SizedBox(width: context.rw(10)),
                        _cardIcon(context, "assets/icons/jcb_card_icon.svg"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- REFACTOR CÁC WIDGET NHỎ ---

  Widget _buildIconDetail(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.rh(6)),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: context.icon(16)),
          SizedBox(width: context.rw(8)),
          Expanded(child: Text(text, style: TextStyle(color: Colors.white70, fontSize: context.sp(13)))),
        ],
      ),
    );
  }

  Widget _socialIcon(BuildContext context, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(context.rw(8)),
        decoration: BoxDecoration(
          color: Colors.white10,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: context.icon(20)),
      ),
    );
  }

  Widget _cardIcon(BuildContext context, String path) {
    return SvgPicture.asset(path, width: context.rw(35));
  }

  Widget _buildExpandableSection({
    required BuildContext context,
    required String title,
    required bool isExpanded,
    required bool isMobile,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: isMobile ? onTap : null,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: context.rh(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(color: kHeaderTextColor, fontSize: context.sp(16), fontWeight: FontWeight.bold)),
                if (isMobile)
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: kHeaderTextColor,
                    size: context.icon(22),
                  ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity),
          secondChild: Padding(
            padding: EdgeInsets.only(bottom: context.rh(15)),
            child: child,
          ),
          crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
        if (isMobile) Divider(color: Colors.white10, height: 1),
      ],
    );
  }

  Widget _buildContactCardWrapper(BuildContext context, bool isMobile, IconData icon, String title, String sub) {
    return SizedBox(
      width: isMobile ? double.infinity : context.rw(300),
      child: FooterContactCard(icon: icon, title: title, subtitle: sub),
    );
  }

  Widget _buildNewsletterSection(BuildContext context, bool isMobile, AppLocalizations l10n, TextStyle headerStyle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.footer_registerOffer, style: headerStyle),
        SizedBox(height: context.rh(10)),
        Text(l10n.footer_registerOfferDescription,
            style: TextStyle(color: kHeaderTextColor.withOpacity(0.8), fontSize: context.sp(13))),
        SizedBox(height: context.rh(15)),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: context.rh(45),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: l10n.footer_emailTitle,
                    hintStyle: TextStyle(color: kHeaderTextColor.withOpacity(0.4), fontSize: context.sp(14)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(context.radius),
                        borderSide: BorderSide(color: Colors.white10)
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: context.rw(15)),
                  ),
                  style: TextStyle(color: kHeaderTextColor, fontSize: context.sp(14)),
                ),
              ),
            ),
            SizedBox(width: context.rw(10)),
            SizedBox(
              height: context.rh(45),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.radius)),
                  padding: EdgeInsets.symmetric(horizontal: context.rw(20)),
                ),
                child: Text(l10n.general_sendButton, style: TextStyle(color: Colors.white, fontSize: context.sp(14))),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPolicySubMenu(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: EdgeInsets.only(left: context.rw(15), bottom: context.rh(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubItem(context, l10n.footer_policyFlight, 37),
          _buildSubItem(context, l10n.footer_policyTour, 1),
          _buildSubItem(context, l10n.footer_policyTrain, 38),
          _buildSubItem(context, l10n.footer_policyCruise, 61),
        ],
      ),
    );
  }

  Widget _buildSubItem(BuildContext context, String title, int postId) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PolicyScreen(postId: postId))),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.rh(6)),
        child: Text('• $title', style: TextStyle(color: Colors.white70, fontSize: context.sp(13))),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String title, {bool hasDropdown = false, required VoidCallback onTap, bool isExpanded = false}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.rh(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(color: kHeaderTextColor, fontSize: context.sp(14), fontWeight: FontWeight.w500)),
            if (hasDropdown)
              Icon(
                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: kHeaderTextColor,
                size: context.icon(18),
              ),
          ],
        ),
      ),
    );
  }
}