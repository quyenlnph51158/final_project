import 'package:final_project/features/tour/data/models/tour_detail_faqs.dart';
import 'package:flutter/material.dart';

import '../../../app/l10n/app_localizations.dart';

class FaqsTourDetailData {
  static List<TourDetailFaqs> faqs(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return [
      TourDetailFaqs(id: 1, question: l10n.faq_q1, answer: l10n.faq_a1),
      TourDetailFaqs(id: 2, question: l10n.faq_q2, answer: l10n.faq_a2),
      TourDetailFaqs(id: 3, question: l10n.faq_q3, answer: l10n.faq_a3),
      TourDetailFaqs(id: 4, question: l10n.faq_q4, answer: l10n.faq_a4),
      TourDetailFaqs(id: 5, question: l10n.faq_q5, answer: l10n.faq_a5),
    ];
  }
}
