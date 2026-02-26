import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/shared/widgets/app_footer.dart';
import 'package:final_project/shared/widgets/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/widgets/app_drawer.dart';
import '../controller/news_controller.dart';
import '../widget/news_card.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsController>().fetchNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      endDrawer: AppDrawer(
        onTabSelected: (_) {},
        onHomeSelected: () {},
        onTabFlightSelected: (_) {},
      ),
      body: SafeArea(
        child: Consumer<NewsController>(
          builder: (context, controller, _) {
            final state = controller.state;

            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage != null) {
              return Center(child: Text(state.errorMessage!));
            }

            return SingleChildScrollView(
              controller: controller.scrollController,
              child: Column(
                children: [
                  CustomAppBar(backgroundColor: kPrimaryColor,image: 'https://www.wonderingvietnam.com/assets/img/logo_wondering.svg',),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ...List.generate(state.newsList.length, (index) {
                          final news = state.newsList[index];
                          final isExpanded = _expandedIndex == index;

                          return NewsCard(
                            key: ValueKey(news.id),
                            news: news,
                            isExpanded: isExpanded,
                            onTap: () {
                              setState(() {
                                _expandedIndex = isExpanded ? null : index;
                              });
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  AppFooter(), // ✅ FULL WIDTH
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

