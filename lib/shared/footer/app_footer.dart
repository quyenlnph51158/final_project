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
  // --- STATE VARIABLES ---
  bool _isPolicyExpanded = false;

  // --- LOGIC METHODS ---
  Future<void> _launchUrlWithFallback(String primaryUrl, String fallbackUrl) async {
    final Uri primaryUri = Uri.parse(primaryUrl);
    final Uri fallbackUri = Uri.parse(fallbackUrl);
    try {
      bool launched = await launchUrl(
        primaryUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        await launchUrl(
          fallbackUri,
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      await launchUrl(
        fallbackUri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool isMobile = context.isMobile;
    final bool isDesktop = context.isDesktop;

    // Styles for consistency
    TextStyle headerStyle = TextStyle(
        color: kHeaderTextColor,
        fontSize: context.sp(18),
        fontWeight: FontWeight.bold
    );

    TextStyle itemStyle = TextStyle(
        color: kHeaderTextColor,
        fontSize: context.sp(14)
    );

    TextStyle descriptionStyle = TextStyle(
        color: Colors.white70,
        fontSize: context.sp(14)
    );

    return Container(
      width: double.infinity,
      color: kFooterBackgroundColor,
      padding: EdgeInsets.symmetric(vertical: context.hp(5)),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? context.wp(6) : 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. LOGO SECTION
                Center(
                  child: SvgPicture.network(
                    ImageLink.logoFooter,
                    height: isDesktop
                        ? context.wp(6) // Smaller logo on desktop
                        : context.isTablet
                        ? context.wp(10)
                        : context.wp(18),
                  ),
                ),
                SizedBox(height: context.hp(4)),

                // 2. CONTACT CARDS (Adaptive Layout)
                // On Desktop/Tablet we wrap them, on Mobile they stack
                Wrap(
                  spacing: 20,
                  runSpacing: 15,
                  children: [
                    SizedBox(
                      width: isMobile ? double.infinity : 300,
                      child: FooterContactCard(
                          icon: Icons.phone_outlined,
                          title: l10n.general_hotline,
                          subtitle: l10n.general_hotlineNumber),
                    ),
                    SizedBox(
                      width: isMobile ? double.infinity : 300,
                      child: FooterContactCard(
                          icon: Icons.email_outlined,
                          title: l10n.footer_emailTitle,
                          subtitle: l10n.general_emailInfo),
                    ),
                    SizedBox(
                      width: isMobile ? double.infinity : 300,
                      child: FooterContactCard(
                          icon: Icons.access_time,
                          title: l10n.general_workingHours,
                          subtitle: l10n.general_workingTime),
                    ),
                  ],
                ),

                Divider(color: kSidebarDividerColor, height: context.hp(6)),

                // 3. MAIN CONTENT (Adaptive Grid: 1 Column on Mobile, 2 on Desktop)
                LayoutBuilder(builder: (context, constraints) {
                  return Wrap(
                    spacing: context.wp(5),
                    runSpacing: 40,
                    children: [
                      // --- LEFT COLUMN: Introduction & Social ---
                      SizedBox(
                        width: isMobile ? constraints.maxWidth : (constraints.maxWidth / 2) - 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.footer_introduce, style: headerStyle),
                            const SizedBox(height: 25),
                            Text(l10n.footer_introDescription, style: descriptionStyle),
                            const SizedBox(height: 12),
                            Text(l10n.footer_addressDetail, style: descriptionStyle),
                            const SizedBox(height: 8),
                            Text(l10n.footer_contactDetail, style: descriptionStyle),
                            const SizedBox(height: 8),
                            Text(l10n.footer_emailDetail, style: descriptionStyle),

                            const SizedBox(height: 30),

                            // SOCIAL MEDIA SECTION
                            Text(l10n.footer_contact, style: headerStyle),
                            const SizedBox(height: 20),
                            _buildSocialMediaItem(Icons.facebook, l10n.social_facebook, () {
                              _launchUrlWithFallback(
                                'fb://facewebmodal/f?href=https://www.facebook.com/wonderingvietnam',
                                'https://www.facebook.com/wonderingvietnam',
                              );
                            }),
                            _buildSocialMediaItem(Icons.camera_alt_outlined, l10n.social_instagram, () {
                              _launchUrlWithFallback(
                                'instagram://user?username=wonderingvietnam',
                                'https://www.instagram.com/wonderingvietnam',
                              );
                            }),
                            _buildSocialMediaItem(Icons.tiktok, l10n.social_tiktok, () {
                              _launchUrlWithFallback(
                                'tiktok://user?username=wondering_vietnam',
                                'https://www.tiktok.com/@wondering_vietnam',
                              );
                            }),
                            _buildSocialMediaItem(Icons.chat_bubble_outline, l10n.social_whatsapp, () {
                              _launchUrlWithFallback(
                                'whatsapp://send?phone=84901118185',
                                'https://wa.me/84901118185',
                              );
                            }),
                          ],
                        ),
                      ),

                      // --- RIGHT COLUMN: Info Links & Newsletter ---
                      SizedBox(
                        width: isMobile ? constraints.maxWidth : (constraints.maxWidth / 2) - 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.footer_informationTitle, style: headerStyle),
                            const SizedBox(height: 20),
                            _buildInfoItem(l10n.footer_introduce, onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const PolicyScreen(postId: 10)));
                            }),
                            _buildInfoItem(l10n.footer_newsTitle, onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const NewsListScreen()));
                            }),
                            _buildInfoItem(
                              l10n.footer_cancellationPolicy,
                              hasDropdown: true,
                              onTap: () => setState(() => _isPolicyExpanded = !_isPolicyExpanded),
                              isExpanded: _isPolicyExpanded,
                            ),
                            if (_isPolicyExpanded)
                              Padding(
                                padding: EdgeInsets.only(left: context.wp(4), bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSubItem(l10n.footer_policyFlight, 37),
                                    _buildSubItem(l10n.footer_policyTour, 1),
                                    _buildSubItem(l10n.footer_policyTrain, 38),
                                    _buildSubItem(l10n.footer_policyCruise, 61),
                                  ],
                                ),
                              ),
                            _buildInfoItem(l10n.footer_guideTitle, onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const PolicyScreen(postId: 8)));
                            }),

                            const SizedBox(height: 40),

                            // NEWSLETTER SECTION
                            Text(l10n.footer_registerOffer, style: headerStyle),
                            const SizedBox(height: 15),
                            Text(l10n.footer_registerOfferDescription, style: itemStyle),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: l10n.footer_emailTitle,
                                      hintStyle: TextStyle(color: kHeaderTextColor.withOpacity(0.5)),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.1),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    ),
                                    style: TextStyle(color: kHeaderTextColor, fontSize: context.sp(14)),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.footer_emailSentSnackbar)));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kAccentColor,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  child: Text(l10n.general_sendButton, style: const TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),

                SizedBox(height: context.hp(6)),
                const Divider(color: kHeaderTextColor),
                const SizedBox(height: 15),

                // 4. COPYRIGHT & CARDS SECTION (The Overflow Fix)
                // Use Wrap so it stacks on narrow phones like iPhone Mini
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 15,
                  children: [
                    SizedBox(
                      width: isMobile ? double.infinity : null,
                      child: Text(
                        l10n.general_copyright,
                        textAlign: isMobile ? TextAlign.center : TextAlign.left,
                        style: TextStyle(color: kHeaderTextColor, fontSize: context.sp(13)),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.end,
                      children: [
                        SvgPicture.asset("assets/icons/card_icon.svg", width: context.wp(isMobile ? 8 : 4)),
                        const SizedBox(width: 12),
                        SvgPicture.asset("assets/icons/master_card_icon.svg", width: context.wp(isMobile ? 8 : 4)),
                        const SizedBox(width: 12),
                        SvgPicture.asset("assets/icons/jcb_card_icon.svg", width: context.wp(isMobile ? 8 : 4)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: context.hp(2)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildSubItem(String title, int postId) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PolicyScreen(postId: postId))),
        child: Text('• $title', style: TextStyle(color: Colors.white70, fontSize: context.sp(14))),
      ),
    );
  }

  Widget _buildSocialMediaItem(IconData icon, String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white70, size: context.sp(22)),
            const SizedBox(width: 15),
            Text(text, style: TextStyle(color: Colors.white70, fontSize: context.sp(15))),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, {bool hasDropdown = false, required VoidCallback onTap, bool isExpanded = false}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(color: kHeaderTextColor, fontSize: context.sp(15), fontWeight: FontWeight.w500)),
            if (hasDropdown)
              Icon(
                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: kHeaderTextColor,
                size: context.sp(22),
              ),
          ],
        ),
      ),
    );
  }
}