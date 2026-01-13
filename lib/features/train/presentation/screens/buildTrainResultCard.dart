import 'package:flutter/material.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/app/l10n/app_localizations.dart';

class TrainResult {
  final String trainCompany;
  final String trainCompanyLogoUrl;
  final String departureStation;
  final String arrivalStation;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final String price;

  TrainResult({
    required this.trainCompany,
    required this.trainCompanyLogoUrl,
    required this.departureStation,
    required this.arrivalStation,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.price,
  });
}

Widget buildTrainResultCard(BuildContext context, TrainResult train) {
  final l10n = AppLocalizations.of(context)!;
  void _selectTrainAndContinue(BuildContext context, TrainResult selectedTrain) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            l10n.train_directOfMove(selectedTrain.trainCompany,selectedTrain.departureStation,selectedTrain.arrivalStation),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.15),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        // Logo hãng tàu
        Image.network(
          train.trainCompanyLogoUrl,
          height: 28,
          width: 28,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.train, color: Colors.orange, size: 26),
        ),
        const SizedBox(width: 12),

        // Giờ khởi hành + ga đi đến
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Giờ đi – giờ đến
              Row(
                children: [
                  Text(
                    train.departureTime,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 4),
                  const Text("–", style: TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(width: 4),
                  Text(
                    train.arrivalTime,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                "${train.departureStation} → ${train.arrivalStation}",
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 2),
              Text(
                train.duration,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),

        // Giá + nút đặt vé
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              train.price,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(height: 6),
            ElevatedButton(
              onPressed: () => _selectTrainAndContinue(context, train),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                l10n.general_bookingButton,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
