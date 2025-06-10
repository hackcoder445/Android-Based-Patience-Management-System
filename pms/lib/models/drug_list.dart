class DrugList {
  final String? drugId;
  final String name;
  final double price;
  final double total;
  final String qty;
  final String dosage;

  const DrugList({
    this.drugId,
    required this.name,
    required this.price,
    required this.total,
    required this.qty,
    required this.dosage,
  });
}
