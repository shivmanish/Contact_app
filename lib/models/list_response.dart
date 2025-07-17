part of contact_app;

class ContactListApiResponse<O> extends Equatable {
  final int? count;
  final String? next;
  final String? previous;
  final List<O> results;

  const ContactListApiResponse({
    this.count,
    this.next,
    this.previous,
    required this.results,
  });

  @override
  List<Object?> get props => [count, previous, next, results.length];
}
