import '../core/utils/formatters.dart';
import '../core/utils/response_reader.dart';

class LedgerEntryModel {
  const LedgerEntryModel({
    required this.id,
    required this.type,
    required this.direction,
    required this.amount,
    required this.currency,
    required this.oldBalance,
    required this.newBalance,
    required this.status,
    required this.note,
    required this.createdAt,
    this.receiptId,
  });

  final int id;
  final String type;
  final String direction;
  final num amount;
  final String currency;
  final num oldBalance;
  final num newBalance;
  final String status;
  final String note;
  final String createdAt;
  final int? receiptId;

  factory LedgerEntryModel.fromJson(Map<String, dynamic> json) {
    int? readNullableInt(String key) {
      final value = json[key];
      if (value == null || '$value'.trim().isEmpty) return null;
      return int.tryParse('$value');
    }

    String readText(String key, {String fallback = ''}) {
      return AppFormatters.safeText(json[key], fallback: fallback);
    }

    return LedgerEntryModel(
      id: AppFormatters.safeInt(json['id']),
      type: readText('type', fallback: 'transaction'),
      direction: readText('direction', fallback: 'increase'),
      amount: AppFormatters.safeNum(json['amount']),
      currency: readText('currency', fallback: 'IQD'),
      oldBalance: AppFormatters.safeNum(json['old_balance']),
      newBalance: AppFormatters.safeNum(json['new_balance']),
      status: readText('status', fallback: 'posted'),
      note: readText('note'),
      createdAt: readText('created_at'),
      receiptId: readNullableInt('receipt_id'),
    );
  }

  static List<LedgerEntryModel> listFrom(dynamic value) {
    return ResponseReader.listFrom(value)
        .map((item) => LedgerEntryModel.fromJson(ResponseReader.mapFrom(item)))
        .toList();
  }

  bool get isIncrease => direction == 'increase';

  String get title {
    switch (type) {
      case 'debt':
        return 'قەرزدان';
      case 'payment':
        return 'پارە وەرگرتن';
      case 'discount':
        return 'داشکاندن';
      case 'forgive':
        return 'لێخۆشبوون';
      case 'adjustment':
        return 'ڕێکخستن';
      case 'correction':
        return 'چاککردنەوە';
      case 'void_reversal':
        return 'هەڵوەشاندنەوە';
      default:
        return 'مامەڵە';
    }
  }
}
