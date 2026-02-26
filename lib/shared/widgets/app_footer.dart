import 'package:final_project/core/constants/image_link.dart';
import 'package:final_project/features/policy/presentation/screens/news_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/features/policy/presentation/screens/policy_screen.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
// BƯỚC 1: CHUYỂN SANG STATEFULWIDGET
class AppFooter extends StatefulWidget {
  const AppFooter({super.key});

  @override
  State<AppFooter> createState() => _AppFooterState();
}

// BƯỚC 2: TẠO CLASS STATE VÀ ĐẶT TẤT CẢ LOGIC VÀO ĐÂY
class _AppFooterState extends State<AppFooter> {
  // BIẾN TRẠNG THÁI CHO DROPDOWN
  bool _isPolicyExpanded = false;

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
    const TextStyle headerStyle = TextStyle(
        color: kHeaderTextColor, fontSize: 18, fontWeight: FontWeight.bold);
    const TextStyle itemStyle = TextStyle(
        color: kHeaderTextColor, fontSize: 16);
    return Container(
      color: kFooterBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo/Tên thương hiệu ở đầu footer
          Center(
            child: SvgPicture.network(ImageLink.logoFooter,
              height: 80,
              width: 80,
            ),
          ),
          const SizedBox(height: 30),

          // Các thẻ liên hệ
          _buildContactCard(Icons.phone_outlined, l10n.general_hotline, l10n.general_hotlineNumber),
          _buildContactCard(
              Icons.email_outlined, l10n.footer_emailTitle, l10n.general_emailInfo),
          _buildContactCard(
              Icons.access_time, l10n.general_workingHours, l10n.general_workingTime),

          const Divider(color: kSidebarDividerColor, height: 40),

          // Phần Giới thiệu
           Text(l10n.footer_introduce,
              style: TextStyle(
                  color: kHeaderTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(
            l10n.footer_introDescription,
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.footer_addressDetail,
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.footer_contactDetail,
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.footer_emailDetail,
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 30),

          // Phần Liên hệ Mạng xã hội
          Text(l10n.footer_contact,
              style: TextStyle(
                  color: kHeaderTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildSocialMediaItem(
            Icons.facebook,
            l10n.social_facebook,
                () {
              _launchUrlWithFallback(
                'fb://facewebmodal/f?href=https://www.facebook.com/wonderingvietnam',
                'https://www.facebook.com/wonderingvietnam',
              );
            },
          ),
          _buildSocialMediaItem(Icons.camera_alt_outlined, l10n.social_instagram, () {
            _launchUrlWithFallback(
              'instagram://user?username=wonderingvietnam',
              'https://www.instagram.com/wonderingvietnam',
            );
          }),
          _buildSocialMediaItem(
              Icons.tiktok, l10n.social_tiktok, () {
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
          const SizedBox(height: 30),

          // PHẦN THÔNG TIN BẮT ĐẦU
          Text(l10n.footer_informationTitle, style: headerStyle),
          const SizedBox(height: 12),

          _buildInfoItem(
            l10n.footer_introduce,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PolicyScreen(postId: 10),
                ),
              );
            },
          ),

          _buildInfoItem(
            l10n.footer_newsTitle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewsListScreen(),
                ),
              );
            },
          ),

          // MỤC DROPDOWN
          _buildInfoItem(
            l10n.footer_cancellationPolicy,
            hasDropdown: true,
            onTap: () {
              // GỌI setState() Ở ĐÂY LÀ ĐÚNG VÌ NÓ NẰM TRONG _AppFooterState
              setState(() {
                _isPolicyExpanded = !_isPolicyExpanded;
              });
            },
            isExpanded: _isPolicyExpanded, // Truyền trạng thái hiện tại để đổi icon
          ),

          // NỘI DUNG DROPDOWN CỤ THỂ
          if (_isPolicyExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 8.0, bottom: 8.0),
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

          _buildInfoItem(
            l10n.footer_guideTitle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PolicyScreen(postId: 8),
                ),
              );
            },
          ),
          // PHẦN THÔNG TIN KẾT THÚC

          const SizedBox(height: 24),

          // Đăng ký ưu đãi
          Text(l10n.footer_registerOffer, style: headerStyle),
          const SizedBox(height: 12),
          Text(
              l10n.footer_registerOfferDescription,
              style: itemStyle),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: l10n.footer_emailTitle,
                    hintStyle:
                    TextStyle(color: kHeaderTextColor.withOpacity(0.7)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  style: const TextStyle(color: kHeaderTextColor),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(l10n.footer_emailSentSnackbar)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAccentColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(l10n.general_sendButton,
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Divider(color: kHeaderTextColor),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.general_copyright,
                style: TextStyle(color: kHeaderTextColor, fontSize: 12),
              ),
              Row(
                children: [
                  SvgPicture.asset("assets/icons/card_icon.svg", width :30, height:20),
                  const SizedBox(width: 8),
                  SvgPicture.asset("assets/icons/master_card_icon.svg", width :30, height:20),
                  const SizedBox(width: 8),
                  SvgPicture.asset("assets/icons/jcb_card_icon.svg", width :30, height:20),

                ],

              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSubItem(String title, int postId) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PolicyScreen(postId: postId),
            ),
          );
        },
        child: Text(
          '• $title',
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildContactCard(IconData icon, String title, String subtitle) {
    return Card(
      color: kContactBoxColor, // Màu nền cho thẻ liên hệ
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: kHeaderTextColor, size: 28),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      color: kHeaderTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: kHeaderTextColor, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaItem(IconData icon, String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: Colors.white70, size: 24),
            const SizedBox(width: 12),
            Text(text,
                style: const TextStyle(color: Colors.white70, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  // Thêm tham số isExpanded để đổi icon
  Widget _buildInfoItem(String title, {bool hasDropdown = false, required VoidCallback onTap, bool isExpanded = false}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(color: kHeaderTextColor)),
            if (hasDropdown)
              Icon(
                // Đổi Icon tùy theo trạng thái mở/đóng
                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: kHeaderTextColor,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}