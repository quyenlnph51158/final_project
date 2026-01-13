import 'package:flutter/material.dart';
import 'package:final_project/core/constants/colors.dart';

// ======================= MODEL TÀU HỎA =======================
class TrainResult {
  final String trainCompany;
  final String trainCompanyLogoUrl;
  final String trainNumber; // Số hiệu tàu (SE1, TN2, v.v.)
  final String departureTime;
  final String arrivalTime;
  final String departureStation;
  final String arrivalStation;
  final String duration;
  final String lowestPrice; // Giá vé thấp nhất
  final String price; // Giá vé hiển thị

  TrainResult({
    required this.trainCompany,
    required this.trainCompanyLogoUrl,
    required this.trainNumber,
    required this.departureTime,
    required this.arrivalTime,
    required this.departureStation,
    required this.arrivalStation,
    required this.duration,
    required this.lowestPrice,
    required this.price,
  });
}

// ======================= HÀM TẠO CARD =======================
Widget buildTrainResultCard(BuildContext context, TrainResult train) {
  void _selectTrainAndContinue(BuildContext context, TrainResult selectedTrain) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Đã chọn tàu ${selectedTrain.trainNumber} (${selectedTrain.departureStation} → ${selectedTrain.arrivalStation})',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  return GestureDetector(
    onTap: () => _selectTrainAndContinue(context, train),
    child: Container(
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
          const Icon(Icons.train, color: kPrimaryColor, size: 28),
          const SizedBox(width: 8),
          Text(
            train.trainNumber,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kPrimaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  "Thời gian: ${train.duration}",
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                train.lowestPrice,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              const SizedBox(height: 4),
              ElevatedButton(
                onPressed: () => _selectTrainAndContinue(context, train),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Chọn tàu',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    ),
  );
}

// ======================= MÀN HÌNH CHÍNH =======================
class TrainResultScreen extends StatelessWidget {
  const TrainResultScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final trains = [
      TrainResult(
        trainCompany: 'Đường Sắt Việt Nam',
        trainCompanyLogoUrl: 'https://upload.wikimedia.org/wikipedia/commons/5/5b/VNR_logo.png',
        trainNumber: 'SE1',
        departureStation: 'Hà Nội',
        arrivalStation: 'Đà Nẵng',
        departureTime: '06:00',
        arrivalTime: '13:45',
        duration: '7h 45m',
        lowestPrice: '450.000đ',
        price: '450.000đ',
      ),
      TrainResult(
        trainCompany: 'VietRail Express',
        trainCompanyLogoUrl: 'https://cdn-icons-png.flaticon.com/512/1061/1061810.png',
        trainNumber: 'TN2',
        departureStation: 'Hà Nội',
        arrivalStation: 'Đà Nẵng',
        departureTime: '09:15',
        arrivalTime: '17:05',
        duration: '7h 50m',
        lowestPrice: '520.000đ',
        price: '520.000đ',
      ),
      TrainResult(
        trainCompany: 'Saigon Railway',
        trainCompanyLogoUrl: 'https://cdn-icons-png.flaticon.com/512/786/786432.png',
        trainNumber: 'SE3',
        departureStation: 'Hà Nội',
        arrivalStation: 'Đà Nẵng',
        departureTime: '12:30',
        arrivalTime: '20:20',
        duration: '7h 50m',
        lowestPrice: '490.000đ',
        price: '490.000đ',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn chuyến tàu'),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF7F8FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2))
              ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '20-11-2025: Hà Nội → Sài Gòn',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '1 Người lớn | 1 Chiều',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Thay đổi',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: trains.length,
              itemBuilder: (context, index) =>
                  buildTrainResultCard(context, trains[index]),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================= MAIN =======================
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ứng dụng Đặt vé Tàu',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        useMaterial3: true,
      ),
      home: const TrainResultScreen(),
    );
  }
}
